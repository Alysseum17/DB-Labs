CREATE TYPE difficulty AS ENUM ('easy','medium','hard');
CREATE TYPE question_type AS ENUM ('single_choice', 'multiple_choice', 'free_text');

CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(32) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    is_active BOOLEAN NOT NULL DEFAULT true
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
    difficulty DIFFICULTY,
    is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    quiz_id INTEGER NOT NULL REFERENCES quizes(quiz_id) ON DELETE CASCADE,
    rating NUMERIC(2,1) NOT NULL CHECK(rating >=0 AND rating <=5),
    review_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS questions (
    question_id SERIAL PRIMARY KEY,
    quiz_id INTEGER NOT NULL REFERENCES quizes(quiz_id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type question_type NOT NULL,
    points SMALLINT NOT NULL CHECK(points >= 0),
    is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS answer_options (
    answer_option_id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS quiz_attempts (
    attempt_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    quiz_id INTEGER NOT NULL REFERENCES quizes(quiz_id) ON DELETE CASCADE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    finished_at TIMESTAMP WITH TIME ZONE,
    score SMALLINT CHECK(score >= 0 AND score <= 100)
);

CREATE TABLE IF NOT EXISTS question_responses (
    question_response_id SERIAL PRIMARY KEY,
    attempt_id INTEGER NOT NULL REFERENCES quiz_attempts(attempt_id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    free_text_answer TEXT,
    earned_points SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS selected_answers (
    question_response_id INTEGER NOT NULL REFERENCES question_responses(question_response_id) ON DELETE CASCADE,
    answer_option_id INTEGER NOT NULL REFERENCES answer_options(answer_option_id) ON DELETE CASCADE,
    PRIMARY KEY (question_response_id, answer_option_id)
);

CREATE TABLE IF NOT EXISTS user_quiz_stats (
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    quiz_id INTEGER NOT NULL REFERENCES quizes(quiz_id) ON DELETE CASCADE,
    best_score SMALLINT DEFAULT 0,
    last_score SMALLINT DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    attempts SMALLINT DEFAULT 0,
    PRIMARY KEY (user_id, quiz_id)
);

INSERT INTO users (username, email, avatar_url, created_at) VALUES
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

INSERT INTO quizes (author_id, title, description, time_limit, attempts_limit, difficulty, created_at, updated_at) VALUES
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

INSERT INTO reviews (user_id, quiz_id, rating, review_text, created_at) VALUES
(3, 1, 5, 'Чудовий тест для початківців! Все чітко і по темі.', '2023-06-03 12:15:00'),
(5, 1, 4, 'Непогано, але хотілося б більше складних питань.', '2023-06-04 09:00:00'),
(1, 2, 5, 'Дуже цікавий та пізнавальний тест. Дізнався багато нового.', '2023-08-01 16:45:00'),
(7, 5, 3, 'Заскладно для початківців, деякі питання незрозумілі.', '2024-02-01 11:30:00'),
(3, 7, 5, NULL, '2024-03-10 21:00:00'),
(9, 10, 4, 'Good test for practice!', '2024-05-12 14:05:21'),
(2, 4, 4, NULL, '2023-11-01 13:00:00');

INSERT INTO questions (quiz_id, question_text, question_type, points) VALUES
(1, 'Яка команда використовується для вибірки даних з таблиці?', 'single_choice', 10),
(1, 'Які з цих операторів використовуються для фільтрації даних?', 'multiple_choice', 15),
(1, 'Як називається процес об''єднання даних з кількох таблиць?', 'free_text', 10),
(2, 'В якому році була проголошена незалежність України?', 'single_choice', 10),
(2, 'Хто був гетьманом Війська Запорозького під час битви під Конотопом?', 'free_text', 15),
(3, 'Хто є автором роману "Майстер і Маргарита"?', 'single_choice', 10),
(3, 'Назвіть українського поета, представника "розстріляного відродження".', 'free_text', 15),
(4, 'Які з цих річок протікають в Південній Америці?', 'multiple_choice', 15),
(4, 'Як називається найбільша пустеля у світі?', 'free_text', 10),
(5, 'Яка команда використовується для створення образу (image) з Dockerfile?', 'single_choice', 10),
(5, 'Що таке Docker-контейнер?', 'free_text', 15),
(6, 'Яка тварина є найбільшою на Землі?', 'single_choice', 10),
(6, 'Який птах не вміє літати, але є чудовим плавцем?', 'free_text', 10),
(7, 'Яка складність алгоритму сортування бульбашкою в найгіршому випадку?', 'single_choice', 15),
(7, 'Що таке рекурсія в програмуванні?', 'free_text', 10),
(8, 'Які планети Сонячної системи є газовими гігантами?', 'multiple_choice', 15),
(8, 'Хто був першою людиною, яка вийшла у відкритий космос?', 'free_text', 10),
(9, 'Що означає червоний сигнал світлофора?', 'single_choice', 5),
(9, 'Що таке "головна дорога"?', 'free_text', 10),
(10, 'Що означає фразове дієслово "give up"?', 'single_choice', 10),
(10, 'Наведіть приклад речення з фразовим дієсловом "look forward to".', 'free_text', 10),
(11, 'Прапор якої країни складається з червоного кола на білому тлі?', 'single_choice', 10),
(11, 'Опишіть прапор Канади.', 'free_text', 10),
(12, 'Які з цих фільмів зняв Квентін Тарантіно?', 'multiple_choice', 15),
(12, 'З якого фільму фраза "I''ll be back"?', 'free_text', 10);

INSERT INTO answer_options (question_id, option_text, is_correct) VALUES
(1, 'SELECT', TRUE), (1, 'UPDATE', FALSE), (1, 'DELETE', FALSE),
(2, 'WHERE', TRUE), (2, 'HAVING', TRUE), (2, 'ORDER BY', FALSE), (2, 'GROUP BY', FALSE),
(4, '1989', FALSE), (4, '1991', TRUE), (4, '1996', FALSE),
(6, 'Федір Достоєвський', FALSE), (6, 'Лев Толстой', FALSE), (6, 'Михайло Булгаков', TRUE),
(8, 'Ніл', FALSE), (8, 'Амазонка', TRUE), (8, 'Парана', TRUE), (8, 'Янцзи', FALSE),
(10, 'docker run', FALSE), (10, 'docker build', TRUE), (10, 'docker pull', FALSE),
(12, 'Слон', FALSE), (12, 'Синій кит', TRUE), (12, 'Жираф', FALSE),
(14, 'O(n)', FALSE), (14, 'O(n log n)', FALSE), (14, 'O(n^2)', TRUE),
(16, 'Марс', FALSE), (16, 'Юпітер', TRUE), (16, 'Сатурн', TRUE), (16, 'Венера', FALSE),
(18, 'Рух дозволено', FALSE), (18, 'Рух заборонено', TRUE), (18, 'Приготуватися до руху', FALSE),
(20, 'Продовжувати', FALSE), (20, 'Здаватися, кидати', TRUE), (20, 'Починати', FALSE),
(22, 'Китай', FALSE), (22, 'Японія', TRUE), (22, 'Туреччина', FALSE),
(24, 'Кримінальне чтиво', TRUE), (24, 'Форрест Гамп', FALSE), (24, 'Скажені пси', TRUE), (24, 'Матриця', FALSE);

INSERT INTO user_quiz_stats (user_id, quiz_id, best_score, last_score, attempts, created_at, updated_at) VALUES
(1, 1, 95, 95, 3, '2025-10-14 17:10:00', '2025-10-14 21:42:00'),
(2, 2, 78, 78, 1, '2025-10-11 11:05:00', '2025-10-11 11:05:00'),
(3, 1, 80, 70, 2, '2025-09-20 18:00:00', '2025-09-21 19:15:00'),
(4, 5, 100, 100, 1, '2025-08-30 22:30:00', '2025-08-30 22:30:00'),
(5, 4, 65, 85, 4, '2025-07-10 12:00:00', '2025-07-15 14:00:00'),
(6, 7, 50, 50, 1, '2025-10-01 10:10:10', '2025-10-01 10:10:10'),
(7, 8, 92, 92, 1, '2025-09-05 16:20:00', '2025-09-05 16:20:00'),
(8, 2, 88, 80, 2, '2025-10-12 13:00:00', '2025-10-13 15:45:00'),
(9, 10, 98, 98, 1, '2025-06-18 09:00:00', '2025-06-18 09:00:00'),
(2, 1, 75, 75, 1, '2025-10-14 08:30:00', '2025-10-14 08:30:00');

INSERT INTO quiz_attempts (user_id, quiz_id, started_at, finished_at, score) VALUES
(1, 1, '2025-10-14 17:10:00', '2025-10-14 17:18:30', 85),
(1, 1, '2025-10-14 19:00:00', '2025-10-14 19:15:00', 70),
(1, 1, '2025-10-14 21:30:00', '2025-10-14 21:42:00', 95),
(2, 2, '2025-10-11 11:05:00', '2025-10-11 11:24:15', 78),
(3, 1, '2025-09-20 18:00:00', '2025-09-20 18:11:45', 80),
(3, 1, '2025-09-21 19:15:00', '2025-09-21 19:25:10', 70),
(4, 5, '2025-08-30 22:30:00', '2025-08-30 22:42:05', 100),
(5, 4, '2025-07-15 14:00:00', '2025-07-15 14:11:30', 85),
(8, 2, '2025-10-12 13:00:00', '2025-10-12 13:19:00', 88),
(2, 1, '2025-10-14 08:30:00', '2025-10-14 08:39:22', 75),
(6, 7, '2025-10-14 22:00:00', NULL, NULL);

--- Normalization

DROP TABLE IF EXISTS user_quiz_stats;

SELECT 
    qa.user_id,
    qa.quiz_id,
    COUNT(qa.attempt_id) AS total_attempts,
    MAX(qa.score) AS best_score,
    MAX(qa.finished_at) AS last_attempt_date,
    (SELECT score 
     FROM quiz_attempts qa2 
     WHERE qa2.user_id = qa.user_id 
       AND qa2.quiz_id = qa.quiz_id 
     ORDER BY started_at DESC 
     LIMIT 1) AS last_score
FROM quiz_attempts qa
GROUP BY qa.user_id, qa.quiz_id;
