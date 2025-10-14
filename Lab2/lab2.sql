CREATE TYPE difficulty AS ENUM ('easy','medium','hard');
CREATE TABLE IF NOT EXISTS users (
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(32) UNIQUE NOT NULL,
	email VARCHAR(32) UNIQUE NOT NULL,
	avatar_url VARCHAR(255),
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS quizes (
	quiz_id SERIAL PRIMARY KEY,
	author_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
	title VARCHAR(255) NOT NULL,
	description TEXT,
	time_limit INTEGER,
	attempts_limit SMALLINT,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
	difficulty DIFFICULTY
);
CREATE TABLE IF NOT EXISTS reviews (
	review_id SERIAL PRIMARY KEY,
	user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
	quiz_id INTEGER NOT NULL REFERENCES quizes(quiz_id) ON DELETE CASCADE,
	rating NUMERIC(2,1) NOT NULL CHECK(rating >=0 AND rating <=5),
	review_text TEXT,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);
INSERT INTO users (username, email, avatar_url, created_at)
VALUES
    ('shadow_specter', 'specter@example.net', 'https://example.com/avatars/specter.png', '2023-05-15 10:30:00'),
    ('nebula_nomad', 'nomad@example.org', NULL, '2022-11-20 18:45:10'),
    ('circuit_charmer', 'charmer@example.com', 'https://example.com/avatars/charmer.png', '2024-01-05 12:00:00'),
    ('fusion_fanatic', 'fanatic@example.net', 'https://example.com/avatars/fanatic.png', '2023-08-01 22:15:30'),
    ('vector_voyager', 'voyager@example.org', NULL, '2021-07-19 09:05:25'),
    ('phoenix_phreak', 'phreak@example.com', 'https://example.com/avatars/phreak.png', '2024-03-22 14:20:00'),
    ('zenith_zephyr', 'zephyr@example.net', NULL, '2022-02-10 23:55:45'),
    ('iron_impulse', 'impulse@example.com', 'https://example.com/avatars/impulse.png', '2023-12-30 08:10:15'),
    ('karma_kernel', 'kernel@example.org', NULL, '2020-09-25 17:00:00'),
    ('omega_operator', 'operator@example.com', 'https://example.com/avatars/operator.png', '2024-05-01 11:11:11');
INSERT INTO quizes (author_id, title, description, time_limit, attempts_limit, difficulty, created_at, updated_at)
VALUES
    (1, 'Основи SQL', 'Тест на знання базових команд SELECT, INSERT, UPDATE.', 600, 3, 'easy', '2023-06-01 11:00:00', '2023-06-02 14:20:00'),
    (7, 'Історія України', NULL, 1200, 2, 'medium', '2023-07-15 15:30:00', '2023-07-15 15:30:00'),
    (3, 'Література XX століття', 'Впізнайте автора за цитатою або твором.', 900, NULL, 'hard', '2023-09-10 18:00:00', '2023-09-12 10:05:00'),
    (3, 'Загальна географія', 'Столиці, ріки та гори світу.', NULL, 5, 'easy', '2023-10-22 20:10:00', '2023-10-22 20:10:00'),
    (5, 'Docker для початківців', NULL, 750, 3, 'medium', '2024-01-20 12:45:00', '2024-01-21 16:00:00'),
    (7, 'Світ тварин', 'Цікаві факти про диких тварин з усього світу.', NULL, NULL, 'easy', '2024-02-14 09:00:00', '2024-02-14 09:00:00'),
    (7, 'Алгоритмічні задачі', 'Тест на логіку та вирішення базових алгоритмів.', 1800, 1, 'hard', '2024-03-05 22:00:00', '2024-03-08 13:13:00'),
    (8, 'Космічні відкриття', NULL, 1000, 4, 'medium', '2024-04-12 10:25:00', '2024-04-12 10:25:00'),
    (9, 'Правила дорожнього руху', 'Тест для перевірки знань ПДР України.', NULL, 2, 'medium', '2024-05-01 19:50:00', '2024-05-01 19:50:00'),
    (10, 'Англійські фразові дієслова', 'Перевірка знань популярних фразових дієслів.', 600, NULL, 'hard', '2024-05-10 17:00:00', '2024-05-11 11:30:00'),
	   (5, 'Вгадай країну по прапору', NULL, 450, 5, NULL, '2024-05-15 14:00:00', '2024-05-15 14:00:00'),
    (8, 'Класика кіно 90-х', 'Впізнай культовий фільм за відомим кадром або цитатою.', NULL, NULL, NULL, '2024-05-20 18:30:00', '2024-05-21 10:00:00');
INSERT INTO reviews (user_id, quiz_id, rating, review_text, created_at)
VALUES
    (3, 1, 5, 'Чудовий тест для початківців! Все чітко і по темі.', '2023-06-03 12:15:00'),
    (5, 1, 4, 'Непогано, але хотілося б більше складних питань.', '2023-06-04 09:00:00'),
    (1, 2, 5, 'Дуже цікавий та пізнавальний тест. Дізнався багато нового.', '2023-08-01 16:45:00'),
    (7, 5, 3, 'Заскладно для початківців, деякі питання незрозумілі.', '2024-02-01 11:30:00'),
    (3, 7, 5, NULL, '2024-03-10 21:00:00'),
    (9, 10, 4, 'Good test for practice!', '2024-05-12 14:05:21'),
    (2, 4, 4, NULL, '2023-11-01 13:00:00');
