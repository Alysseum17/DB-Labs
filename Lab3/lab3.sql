-- SELECT
SELECT COUNT(DISTINCT user_id) AS users_takes FROM quiz_attempts WHERE quiz_id = 1;
SELECT SUM(points) as max_points FROM questions WHERE quiz_id = 3 AND is_active;
SELECT AVG(score) as average_score FROM quiz_attempts WHERE quiz_id = 1;
-- INSERT
INSERT INTO users (username, email, avatar_url, created_at)
VALUES
    ('quantum_quark', 'quark@example.com', NULL, '2025-10-23 10:30:00'),
    ('pixel_pilot', 'pilot@example.net', 'https://example.com/avatars/pilot.png', '2025-10-23 11:00:00'),
    ('data_drifter', 'drifter@example.org', NULL, '2025-10-23 12:15:00');
SELECT * FROM users ORDER BY created_at DESC LIMIT 3;
-- UPDATE
UPDATE user_quiz_stats SET last_score = 100, best_score = GREATEST(best_score, 100), updated_at = NOW(), attempts= attempts + 1 
WHERE user_id = 1 AND quiz_id = 1;
SELECT * FROM user_quiz_stats ORDER BY updated_at DESC LIMIT 1;
UPDATE reviews SET rating = 4.0, updated_at = NOW() WHERE review_id = 4; 
SELECT * FROM reviews ORDER BY updated_at DESC LIMIT 1;
UPDATE quizes SET is_active = false WHERE quiz_id = 6;
SELECT * FROM quizes WHERE is_active = false;
--DELETE
DELETE FROM quiz_attempts WHERE attempt_status = 'cancelled';
SELECT * FROM quiz_attempts WHERE attempt_status = 'cancelled';
DELETE FROM reviews WHERE review_id = 9;
SELECT * FROM reviews WHERE review_id = 9;
