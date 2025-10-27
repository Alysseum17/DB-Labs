# Lab 4: Analytical SQL Queries (OLAP)

## Overview
This document describes and explains a series of analytical SQL queries written for a quiz-based database system. The purpose of these queries is to analyze data about quizzes, users, attempts, questions, and reviews using **aggregate functions**, **JOINs**, **subqueries**, and **filters** (`HAVING`), as required by the lab instructions.

---

## 1. Aggregation and Grouping Queries

### 1.1 Counting Quiz Attempts
```sql
SELECT q.title, COUNT(qa.attempt_id) AS attempt_count 
FROM quizes q
LEFT JOIN quiz_attempts qa USING(quiz_id)
GROUP BY q.title
ORDER BY attempt_count DESC;
```
**Explanation:**  
Counts how many attempts each quiz has received. Quizzes with no attempts are also included due to the `LEFT JOIN`. Results are ordered from the most attempted quiz to the least.

---

### 1.2 Average Rating per Quiz
```sql
SELECT q.title, AVG(r.rating) AS average_rating 
FROM quizes q
LEFT JOIN reviews r USING(quiz_id)
GROUP BY q.title
ORDER BY average_rating DESC NULLS LAST;
```
**Explanation:**  
Calculates the average review rating for each quiz. Quizzes without reviews appear last due to `NULLS LAST`.

---

### 1.3 Quizzes per Author
```sql
SELECT u.username, COUNT(q.quiz_id) AS quiz_count 
FROM users u
INNER JOIN quizes q ON u.user_id = q.author_id
GROUP BY u.username
ORDER BY quiz_count DESC;
```
**Explanation:**  
Shows how many quizzes each author has created, ranking them in descending order of output.

---

### 1.4 Question Types per Quiz
```sql
SELECT q.title, qs.question_type, COUNT(qs.question_id) AS question_count 
FROM quizes q
INNER JOIN questions qs USING(quiz_id)
GROUP BY q.title, qs.question_type 
ORDER BY q.title, qs.question_type;
```
**Explanation:**  
Displays the number of questions per quiz, grouped by type (e.g., single choice, multiple choice, etc.).

---

### 1.5 Average Rating by Quiz Author
```sql
SELECT u.username AS author_name, AVG(r.rating) AS average_rating_of_quizes 
FROM users u
INNER JOIN quizes q ON u.user_id = q.author_id
LEFT JOIN reviews r ON q.quiz_id = r.quiz_id
GROUP BY u.username
ORDER BY average_rating_of_quizes DESC NULLS LAST;
```
**Explanation:**  
Computes each author's average rating across all their quizzes. Authors with unrated quizzes appear at the end.

---

### 1.6 Average User Score on Easy Quizzes
```sql
SELECT u.username, AVG(qa.score) AS average_score_on_easy 
FROM users u
INNER JOIN quiz_attempts qa USING(user_id)
INNER JOIN quizes q USING(quiz_id)
WHERE q.difficulty = 'easy' AND qa.attempt_status = 'completed'
GROUP BY u.username
ORDER BY average_score_on_easy DESC NULLS LAST;
```
**Explanation:**  
Calculates the average score per user on easy-level quizzes they have completed.

---

### 1.7 Author Performance by Average Best Score
```sql
SELECT u.username AS author_name, AVG(uqs.best_score) AS average_best_score 
FROM users u
INNER JOIN quizes q ON u.user_id = q.author_id 
LEFT JOIN user_quiz_stats uqs USING(quiz_id)
GROUP BY u.username
ORDER BY average_best_score DESC NULLS LAST;
```
**Explanation:**  
Evaluates authors based on the average of their quizzes’ best scores across users.

---

### 1.8 Quizzes with at Least 5 Attempts
```sql
SELECT q.title, COUNT(qa.attempt_id) AS attempts_count 
FROM quizes q
INNER JOIN quiz_attempts qa USING(quiz_id)
GROUP BY q.title
HAVING COUNT(qa.attempt_id) >= 5
ORDER BY attempts_count DESC;
```
**Explanation:**  
Filters and lists only those quizzes that have been attempted 5 or more times.

---

### 1.9 Authors with at Least 3 Quizzes
```sql
SELECT u.username, COUNT(q.quiz_id) AS quizes_count 
FROM users u 
INNER JOIN quizes q ON u.user_id = q.author_id 
GROUP BY u.username
HAVING COUNT(q.quiz_id) >= 3
ORDER BY quizes_count DESC;
```
**Explanation:**  
Displays authors who have created at least three quizzes.

---

### 1.10 Highly Rated Quizzes
```sql
SELECT q.title, AVG(r.rating) AS average_rating 
FROM quizes q
INNER JOIN reviews r USING(quiz_id)
GROUP BY q.title
HAVING AVG(r.rating) >= 4.0
ORDER BY average_rating DESC;
```
**Explanation:**  
Shows quizzes with an average rating of 4.0 or higher.

---

### 1.11 Incomplete or Missing Question Data
```sql
SELECT * 
FROM questions q
FULL JOIN answer_options a USING(question_id)
WHERE q.question_id IS NULL 
   OR (a.answer_option_id IS NULL AND q.question_type IN ('single_choice','multiple_choice'));
```
**Explanation:**  
Identifies inconsistencies: questions without answer options or answer options without a corresponding question.

---

## 2. Analytical Aggregations (OLAP Metrics)

### 2.1 Question Type Statistics
```sql
SELECT question_type,
       COUNT(question_id) AS total_questions,
       SUM(points) AS total_points,
       AVG(points) AS average_points,
       MIN(points) AS min_points,
       MAX(points) AS max_points
FROM questions
GROUP BY question_type;
```
**Explanation:**  
Summarizes question points by type — useful for balancing quiz design.

---

### 2.2 Total Possible Quiz Scores
```sql
SELECT q.title, SUM(qs.points) AS total_possible_score
FROM quizes q
JOIN questions qs ON q.quiz_id = qs.quiz_id
GROUP BY q.quiz_id, q.title
ORDER BY total_possible_score DESC;
```
**Explanation:**  
Shows each quiz’s total score potential based on question point values.

---

### 2.3 Users Who Took More Than Two Quizzes
```sql
SELECT u.username, COUNT(uqs.quiz_id) AS quizes_taken_count
FROM users u
JOIN user_quiz_stats uqs ON u.user_id = uqs.user_id
GROUP BY u.user_id, u.username
HAVING COUNT(uqs.quiz_id) > 2
ORDER BY quizes_taken_count DESC;
```
**Explanation:**  
Lists users who have taken at least three different quizzes.

---

### 2.4 Score Statistics for a Specific Quiz
```sql
SELECT q.title,
       MIN(qa.score) AS min_score,
       MAX(qa.score) AS max_score,
       AVG(qa.score) AS average_score,
       COUNT(qa.attempt_id) AS total_completed_attempts
FROM quiz_attempts qa
JOIN quizes q ON qa.quiz_id = q.quiz_id
WHERE q.quiz_id = 2 AND qa.score IS NOT NULL
GROUP BY q.title;
```
**Explanation:**  
Summarizes score distribution for quiz ID 2 — minimum, maximum, average, and total attempts.

---

### 2.5 Review Count per User
```sql
SELECT u.username, COUNT(r.review_id) AS review_count
FROM users u
LEFT JOIN reviews r ON u.user_id = r.user_id
GROUP BY u.user_id, u.username
ORDER BY review_count DESC;
```
**Explanation:**  
Counts how many reviews each user has written, including users who wrote none.

---

### 2.6 Attempts and Scores for a Specific Quiz
```sql
SELECT qa.attempt_id, qa.score, u.username
FROM users u
RIGHT JOIN quiz_attempts qa ON u.user_id = qa.user_id
WHERE qa.quiz_id = 1;
```
**Explanation:**  
Lists all attempts for quiz ID 1, showing each score with the username (if available).

---

### 2.7 Easy Quizzes Cross-Join
```sql
SELECT u.username, q.title
FROM users u
CROSS JOIN quizes q
WHERE q.difficulty = 'easy';
```
**Explanation:**  
Produces all possible user–quiz combinations for easy quizzes — useful for recommendation scenarios.

---

### 2.8 Unattempted Quizzes
```sql
SELECT title, difficulty, created_at
FROM quizes
WHERE quiz_id NOT IN (SELECT DISTINCT quiz_id FROM quiz_attempts);
```
**Explanation:**  
Lists quizzes that have never been attempted by any user.

---

### 2.9 Average Score per User
```sql
SELECT u.username,
       (SELECT AVG(qa.score)
        FROM quiz_attempts qa
        WHERE qa.user_id = u.user_id AND qa.score IS NOT NULL) AS user_average_score
FROM users u
ORDER BY user_average_score DESC NULLS LAST;
```
**Explanation:**  
Uses a **subquery in SELECT** to calculate each user’s personal average score across all quizzes.

---

## 3. Basic Statistical Queries

### 3.1 Total Users
```sql
SELECT COUNT(*) AS total_users FROM users;
```
**Explanation:**  
Simple count of all users registered in the system.

---

### 3.2 Score Range for a Specific Quiz
```sql
SELECT MAX(score) AS max_score, MIN(score) AS min_score
FROM quiz_attempts
WHERE quiz_id = 1;
```
**Explanation:**  
Displays the highest and lowest scores achieved on quiz ID 1.

---

### 3.3 Overall Average Rating
```sql
SELECT AVG(rating) AS average_rating FROM reviews;
```
**Explanation:**  
Computes the global average of all quiz ratings.

---

### 3.4 Quiz Titles and Their Authors
```sql
SELECT q.title AS quiz_title, u.username AS author_name
FROM quizes q
INNER JOIN users u ON q.author_id = u.user_id;
```
**Explanation:**  
Lists each quiz along with its author’s username.

---

### 3.5 Quizzes with or without Reviews
```sql
SELECT q.title, r.rating, r.review_text
FROM reviews r
RIGHT JOIN quizes q ON r.quiz_id = q.quiz_id;
```
**Explanation:**  
Shows all quizzes — including those with no reviews — along with available rating details.

---

### 3.6 All Users and Their Quizzes
```sql
SELECT u.username, q.title
FROM users u
LEFT JOIN quizes q ON u.user_id = q.author_id;
```
**Explanation:**  
Lists all users and the quizzes they have created. Users with no quizzes are still shown.

---

### 3.7 Users Who Attempted a Specific Quiz
```sql
SELECT username
FROM users
WHERE user_id IN (SELECT user_id FROM quiz_attempts WHERE quiz_id = 1);
```
**Explanation:**  
Finds all users who have attempted quiz ID 1 using a **subquery in WHERE**.

---

### 3.8 Attempt Scores with Overall Average
```sql
SELECT attempt_id, score, (SELECT AVG(score) FROM quiz_attempts) AS overall_average_score
FROM quiz_attempts;
```
**Explanation:**  
Shows each attempt’s score along with the overall average score for comparison.

---

### 3.9 Users with Above-Average Scores
```sql
SELECT user_id, AVG(score) AS user_average
FROM quiz_attempts
GROUP BY user_id
HAVING AVG(score) > (SELECT AVG(score) FROM quiz_attempts);
```
**Explanation:**  
Finds users whose average score exceeds the global average — demonstrating a **subquery in HAVING**.

---

## Summary
This collection of queries fulfills all OLAP requirements:
- **Aggregation Functions:** COUNT, SUM, AVG, MIN, MAX  
- **JOIN Types:** INNER, LEFT, RIGHT, FULL, CROSS  
- **Subqueries:** Used in SELECT, WHERE, and HAVING  
- **Filtering and Grouping:** GROUP BY and HAVING for data segmentation  

Together, they provide a comprehensive analytical toolkit for exploring the quiz platform’s data structure and performance.
