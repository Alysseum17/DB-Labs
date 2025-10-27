--- 1 --- 
SELECT q.title, COUNT(qa.attempt_id) AS attempt_count FROM quizes q
LEFT JOIN quiz_attempts qa USING(quiz_id)
GROUP BY q.title
ORDER BY attempt_count DESC;

SELECT q.title, AVG(r.rating) AS average_rating FROM quizes q
LEFT JOIN reviews r USING(quiz_id)
GROUP BY q.title
ORDER BY average_rating DESC NULLS LAST;

SELECT u.username, COUNT(q.quiz_id) AS quiz_count FROM users u
INNER JOIN quizes q USING(author_id)
GROUP BY u.username
ORDER BY quiz_count DESC;

SELECT q.title, qs.question_type, COUNT(qs.question_id) AS question_count FROM quizes q
INNER JOIN questions qs USING(quiz_id)
GROUP BY q.title, qs.question_type 
ORDER BY q.title, qs.question_type;

SELECT u.username AS author_name, AVG(r.rating) AS average_rating_of_quizes FROM users u
INNER JOIN quizes q ON u.user_id = q.author_id
LEFT JOIN reviews r ON q.quiz_id = r.quiz_id
GROUP BY u.username
ORDER BY average_rating_of_quizes DESC NULLS LAST;

SELECT u.username, AVG(qa.score) AS average_score_on_easy FROM users u
INNER JOIN quiz_attempts qa ON USING(user_id)
INNER JOIN quizes q ON USING(quiz_id)
WHERE q.difficulty = 'easy' AND qa.attempt_status = 'completed' 
GROUP BY u.username
ORDER BY average_score_on_easy DESC NULLS LAST;

SELECT u.username AS author_name, AVG(uqs.best_score) AS average_best_score FROM users u
INNER JOIN quizes q ON u.user_id = q.author_id 
LEFT JOIN user_quiz_stats uqs ON USING(quiz_id)
GROUP BY u.username
ORDER BY average_best_score DESC NULLS LAST;

SELECT q.title, COUNT(qa.attempt_id) AS attempts_count FROM quizes q
INNER JOIN quiz_attempts qa USING(quiz_id)
GROUP BY q.title
HAVING COUNT(qa.attempt_id) >= 5
ORDER BY attempts_count DESC;


SELECT u.username, COUNT(q.quiz_id) AS quizes_count FROM users u 
INNER JOIN quizes q ON u.user_id = q.author_id 
GROUP BY u.username
HAVING COUNT(q.quiz_id) >= 3
ORDER BY quizes_count DESC;


SELECT q.title, AVG(r.rating) AS average_rating FROM quizes q
INNER JOIN reviews r USING(quiz_id)
GROUP BY q.title
HAVING AVG(r.rating) >= 4.0
ORDER BY average_rating DESC;

SELECT * FROM questions q
FULL JOIN answer_options a USING(question_id)
WHERE q.question_id IS NULL OR (a.answer_option_id IS NULL AND q.question_type IN('single_choice','multiple_choice'));

--- 2 ---
SELECT
  question_type,
  COUNT(question_id) AS total_questions,
  SUM(points) AS total_points,
  AVG(points) AS average_points,
  MIN(points) AS min_points,
  MAX(points) AS max_points
FROM
  questions
GROUP BY
  question_type;


SELECT
  q.title,
  SUM(qs.points) AS total_possible_score
FROM
  quizes q
JOIN
  questions qs ON q.quiz_id = qs.quiz_id
GROUP BY
  q.quiz_id, q.title
ORDER BY
  total_possible_score DESC;


SELECT
  u.username,
  COUNT(uqs.quiz_id) AS quizes_taken_count
FROM
  users u
JOIN
  user_quiz_stats uqs ON u.user_id = uqs.user_id
GROUP BY
  u.user_id, u.username
HAVING
  COUNT(uqs.quiz_id) > 2
ORDER BY
  quizes_taken_count DESC;


SELECT
  q.title,
  MIN(qa.score) AS min_score,
  MAX(qa.score) AS max_score,
  AVG(qa.score) AS average_score,
  COUNT(qa.attempt_id) AS total_completed_attempts
FROM
  quiz_attempts qa
JOIN
  quizes q ON qa.quiz_id = q.quiz_id
WHERE
  q.quiz_id = 2 AND qa.score IS NOT NULL
GROUP BY
  q.title;


SELECT
  u.username,
  COUNT(r.review_id) AS review_count
FROM
  users u
LEFT JOIN
  reviews r ON u.user_id = r.user_id
GROUP BY
  u.user_id, u.username
ORDER BY
  review_count DESC;


SELECT
  qa.attempt_id,
  qa.score,
  u.username
FROM
  users u
RIGHT JOIN
  quiz_attempts qa ON u.user_id = qa.user_id
WHERE
  qa.quiz_id = 1;


SELECT
  u.username,
  q.title
FROM
  users u
CROSS JOIN
  quizes q
WHERE
  q.difficulty = 'easy';


SELECT
  title,
  difficulty,
  created_at
FROM
  quizes
WHERE
  quiz_id NOT IN (
    SELECT DISTINCT quiz_id FROM quiz_attempts
  );


SELECT
  u.username,
  (
    SELECT AVG(qa.score)
    FROM quiz_attempts qa
    WHERE qa.user_id = u.user_id AND qa.score IS NOT NULL
  ) AS user_average_score
FROM
  users u
ORDER BY
  user_average_score DESC NULLS LAST;


--- 3 ---
SELECT COUNT(*) AS total_users FROM users;

SELECT
    MAX(score) AS max_score,
    MIN(score) AS min_score
FROM
    quiz_attempts
WHERE
    quiz_id = 1;

SELECT AVG(rating) AS average_rating FROM reviews;

SELECT
    q.title AS quiz_title,
    u.username AS author_name
FROM
    quizes q
INNER JOIN
    users u ON q.author_id = u.user_id;

SELECT
    q.title,
    r.rating,
    r.review_text
FROM
    reviews r
RIGHT JOIN
    quizes q ON r.quiz_id = q.quiz_id;

SELECT
    u.username,
    q.title
FROM
    users u
LEFT JOIN
    quizes q ON u.user_id = q.author_id;

SELECT username
FROM users
WHERE user_id IN (
    SELECT user_id FROM quiz_attempts WHERE quiz_id = 1
);

SELECT
    attempt_id,
    score,
    (SELECT AVG(score) FROM quiz_attempts) AS overall_average_score
FROM
    quiz_attempts;

SELECT
    user_id,
    AVG(score) AS user_average
FROM
    quiz_attempts
GROUP BY
    user_id
HAVING
    AVG(score) > (SELECT AVG(score) FROM quiz_attempts);

