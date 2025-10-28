# SQL Operations: Data Manipulation and Selection

## Overview
This document describes and explains SQL queries used for **data retrieval, insertion, updating, and deletion** within a quiz management system.  
The operations cover standard CRUD logic — **SELECT**, **INSERT**, **UPDATE**, and **DELETE** — applied to tables such as `users`, `quizes`, `questions`, `reviews`, and `quiz_attempts`.

---

## 1. SELECT Queries — Data Retrieval and Analysis

### 1.1 Count Users Who Took a Specific Quiz
```sql
SELECT COUNT(DISTINCT user_id) AS users_takes 
FROM quiz_attempts 
WHERE quiz_id = 1;
```
**Explanation:**  
Counts the number of **unique users** who attempted quiz ID 1.

---

### 1.2 Total Possible Points for a Quiz
```sql
SELECT SUM(points) AS max_points 
FROM questions 
WHERE quiz_id = 3 AND is_active;
```
**Explanation:**  
Calculates the **sum of active question points** for quiz ID 3 — representing the total achievable score.

---

### 1.3 Average Quiz Score
```sql
SELECT AVG(score) AS average_score 
FROM quiz_attempts 
WHERE quiz_id = 1;
```
**Explanation:**  
Determines the **average score** of all attempts for quiz ID 1.

---

### 1.4 Active Questions with Points Between 5 and 10
```sql
SELECT * 
FROM questions 
WHERE points BETWEEN 5 AND 10 AND is_active;
```
**Explanation:**  
Retrieves all active questions that offer between **5 and 10 points**.

---

### 1.5 Latest Active Quizzes
```sql
SELECT title, created_at 
FROM quizes 
WHERE is_active 
ORDER BY created_at DESC 
LIMIT 5;
```
**Explanation:**  
Displays the **five most recently created active quizzes**, sorted by creation date.

---

### 1.6 Average Rating for a Specific Quiz
```sql
SELECT AVG(rating) AS average_rating 
FROM reviews 
WHERE quiz_id = 1;
```
**Explanation:**  
Calculates the **average review rating** for quiz ID 1.

---

### 1.7 Active User by Email
```sql
SELECT * 
FROM users 
WHERE email = 'zephyr@example.net' AND is_active;
```
**Explanation:**  
Retrieves details of an **active user** by their email address.

---

### 1.8 Active Quizzes by Difficulty
```sql
SELECT title, difficulty 
FROM quizes 
WHERE difficulty IN('easy','medium') AND is_active;
```
**Explanation:**  
Shows the titles and difficulty levels of all active quizzes that are **easy or medium**.

---

### 1.9 Quizzes with Time Limit
```sql
SELECT title 
FROM quizes 
WHERE time_limit IS NOT NULL AND is_active;
```
**Explanation:**  
Lists active quizzes that have a **defined time limit**.

---

### 1.10 Questions Containing a Keyword
```sql
SELECT question_text 
FROM questions 
WHERE question_text ILIKE '%Docker%' AND is_active;
```
**Explanation:**  
Finds all active questions containing the keyword **“Docker”**, ignoring case.

---

## 2. INSERT Queries — Adding New Data

### 2.1 Add New Users
```sql
INSERT INTO users (username, email, avatar_url, created_at)
VALUES
    ('quantum_quark', 'quark@example.com', NULL, '2025-10-23 10:30:00'),
    ('pixel_pilot', 'pilot@example.net', 'https://example.com/avatars/pilot.png', '2025-10-23 11:00:00'),
    ('data_drifter', 'drifter@example.org', NULL, '2025-10-23 12:15:00');
SELECT * FROM users ORDER BY created_at DESC LIMIT 3;
```
**Explanation:**  
Adds three new users with different emails and timestamps.  
The `SELECT` query confirms insertion by retrieving the latest users.

---

### 2.2 Add New Reviews
```sql
INSERT INTO reviews (user_id, quiz_id, rating, review_text, created_at)
VALUES
    (11, 4, 5, 'Географія - це супер! Дуже сподобалось.', '2025-10-23 11:10:00'),
    (12, 5, 4, 'Docker - складно, але корисно. Дякую автору.', '2025-10-23 11:30:00'),
    (1, 3, 3, 'Дуже складний тест по літературі. Ледве впорався.', '2025-10-23 14:00:00');
SELECT * FROM reviews ORDER BY created_at DESC LIMIT 3;
```
**Explanation:**  
Inserts new user reviews with ratings and comments for specific quizzes, then displays the latest entries.

---

### 2.3 Add Quiz Attempts
```sql
INSERT INTO quiz_attempts (user_id, quiz_id, started_at, finished_at, score, attempt_status)
VALUES
    (11, 4, '2025-10-23 11:05:00', '2025-10-23 11:09:30', 90, 'completed'),
    (12, 5, '2025-10-23 11:15:00', '2025-10-23 11:28:00', 75, 'completed'),
    (13, 1, '2025-10-23 13:00:00', NULL, NULL, 'in_progress');
SELECT * FROM quiz_attempts ORDER BY started_at DESC LIMIT 3;
```
**Explanation:**  
Adds three quiz attempt records, including one **in-progress attempt**.  
The final `SELECT` retrieves the most recent attempts.

---

## 3. UPDATE Queries — Modifying Existing Data

### 3.1 Update Quiz Stats
```sql
UPDATE user_quiz_stats 
SET last_score = 100, best_score = GREATEST(best_score, 100), updated_at = NOW(), attempts = attempts + 1
WHERE user_id = 1 AND quiz_id = 1; 
SELECT * FROM user_quiz_stats ORDER BY updated_at DESC LIMIT 1;
```
**Explanation:**  
Updates user stats by setting a new best score, timestamp, and increasing attempt count.

---

### 3.2 Update Review Rating
```sql
UPDATE reviews SET rating = 4.0, updated_at = NOW() WHERE review_id = 4; 
SELECT * FROM reviews ORDER BY updated_at DESC LIMIT 1;
```
**Explanation:**  
Changes a review’s rating and updates the timestamp.

---

### 3.3 Deactivate a Quiz
```sql
UPDATE quizes SET is_active = false WHERE quiz_id = 6; 
SELECT * FROM quizes WHERE is_active = false;
```
**Explanation:**  
Marks a quiz as inactive (soft delete).

---

### 3.4 Update User Information
```sql
UPDATE users 
SET username = 'shadow_specter2001', email = 'specter2001@example.net' 
WHERE user_id = 1; 
SELECT username, email FROM users WHERE user_id = 1;
```
**Explanation:**  
Modifies the username and email for a specific user.

---

### 3.5 Deactivate a Question
```sql
UPDATE questions SET is_active = false WHERE question_id = 6; 
SELECT * FROM questions WHERE is_active = false;
```
**Explanation:**  
Marks a question as inactive, preventing it from appearing in quizzes.

---

### 3.6 Deactivate a User
```sql
UPDATE users SET is_active = false WHERE user_id = 10; 
SELECT * FROM users WHERE is_active = false;
```
**Explanation:**  
Disables a user account while keeping the data for record-keeping.

---

### 3.7 Update Quiz Details
```sql
UPDATE quizes 
SET title = 'Основи SQL для початківців', time_limit = 720, updated_at = NOW() 
WHERE quiz_id = 1; 
SELECT title FROM quizes ORDER BY updated_at DESC LIMIT 1;
```
**Explanation:**  
Changes a quiz’s title, time limit, and updates the modification date.

---

### 3.8 Correct Answer Options
```sql
UPDATE answer_options SET option_text = 'UPDATE', is_correct = false WHERE answer_option_id = 1; 
UPDATE answer_options SET option_text = 'SELECT', is_correct = true WHERE answer_option_id = 2; 
SELECT * FROM answer_options WHERE answer_option_id IN(1,2);
```
**Explanation:**  
Updates two answer options — one corrected to `SELECT` and marked as correct.

---

## 4. DELETE Queries — Removing Data

### 4.1 Remove Cancelled Attempts
```sql
DELETE FROM quiz_attempts WHERE attempt_status = 'cancelled'; 
SELECT * FROM quiz_attempts WHERE attempt_status = 'cancelled';
```
**Explanation:**  
Deletes all cancelled quiz attempts, ensuring only valid ones remain.

---

### 4.2 Delete Specific Review
```sql
DELETE FROM reviews WHERE review_id = 9;
SELECT * FROM reviews WHERE review_id = 9;
```
**Explanation:**  
Removes a review record identified by its ID.

---

### 4.3 Delete a Question
```sql
DELETE FROM questions WHERE question_id = 8;
SELECT * FROM questions WHERE question_id = 8;
```
**Explanation:**  
Deletes a question from the question bank permanently.

---

### 4.4 Delete a User
```sql
DELETE FROM users WHERE user_id = 13;
SELECT * FROM users WHERE user_id = 13;
```
**Explanation:**  
Removes a user and then checks if the record still exists (it should not).

---

## Summary
This set of SQL queries demonstrates:
- **SELECT** for retrieval and analysis of active and filtered data.  
- **INSERT** for adding users, reviews, and quiz attempts.  
- **UPDATE** for modifying quiz, user, and review data dynamically.  
- **DELETE** for data cleanup and maintenance.  

Together, these queries ensure full data lifecycle management in the quiz platform.
