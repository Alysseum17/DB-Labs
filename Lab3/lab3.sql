-- SELECT
SELECT COUNT(DISTINCT user_id) AS users_takes FROM quiz_attempts WHERE quiz_id = 1;
SELECT SUM(points) as max_points FROM questions WHERE quiz_id = 3 AND is_active;
SELECT AVG(score) as average_score FROM quiz_attempts WHERE quiz_id = 1;
SELECT * FROM questions WHERE points BETWEEN 5 AND 10 AND is_active;
SELECT title,created_at FROM quizes WHERE is_active ORDER BY created_at DESC LIMIT 5;
SELECT AVG(rating) AS average_rating FROM reviews WHERE quiz_id = 1;
-- INSERT
INSERT INTO users (username, email, avatar_url, created_at)
VALUES
    ('quantum_quark', 'quark@example.com', NULL, '2025-10-23 10:30:00'),
    ('pixel_pilot', 'pilot@example.net', 'https://example.com/avatars/pilot.png', '2025-10-23 11:00:00'),
    ('data_drifter', 'drifter@example.org', NULL, '2025-10-23 12:15:00');
SELECT * FROM users ORDER BY created_at DESC LIMIT 3;
INSERT INTO reviews (user_id, quiz_id, rating, review_text, created_at)
VALUES
    (11, 4, 5, 'Географія - це супер! Дуже сподобалось.', '2025-10-23 11:10:00'),
    (12, 5, 4, 'Docker - складно, але корисно. Дякую автору.', '2025-10-23 11:30:00'),
    (1, 3, 3, 'Дуже складний тест по літературі. Ледве впорався.', '2025-10-23 14:00:00');
SELECT * FROM reviews ORDER BY created_at DESC LIMIT 3;
-- UPDATE
UPDATE user_quiz_stats SET last_score = 100, best_score = GREATEST(best_score, 100), updated_at = NOW(), attempts= attempts + 1 
WHERE user_id = 1 AND quiz_id = 1;
SELECT * FROM user_quiz_stats ORDER BY updated_at DESC LIMIT 1;
UPDATE reviews SET rating = 4.0, updated_at = NOW() WHERE review_id = 4; 
SELECT * FROM reviews ORDER BY updated_at DESC LIMIT 1;
UPDATE quizes SET is_active = false WHERE quiz_id = 6;
SELECT * FROM quizes WHERE is_active = false;
UPDATE users SET username = 'shadow_specter2001', email = 'specter2001@example.net' WHERE user_id = 1;
SELECT username, email FROM users WHERE user_id = 1;
UPDATE questions SET is_active = false WHERE question_id = 6;
SELECT * FROM questions WHERE is_active = false
UPDATE users SET is_active = false WHERE user_id = 10;
SELECT * FROM users WHERE is_active = false
--DELETE
DELETE FROM quiz_attempts WHERE attempt_status = 'cancelled';
SELECT * FROM quiz_attempts WHERE attempt_status = 'cancelled';
DELETE FROM reviews WHERE review_id = 9;
SELECT * FROM reviews WHERE review_id = 9;
DELETE FROM questions WHERE question_id = 8;
SELECT * FROM questions WHERE question_id = 8;
DELETE FROM users WHERE user_id = 13;
SELECT * FROM users WHERE user_id = 13;
