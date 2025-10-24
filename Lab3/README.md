

### Створення бази даних

Ця база даних розроблена для онлайн-платформи квізів. Вона дозволяє користувачам створювати тести, проходити їх, відстежувати свою успішність та залишати відгуки. Схема складається з 9 основних таблиць, які забезпечують цілісність та ефективність роботи з даними.

#### Діаграма схеми (ERD)

```mermaid
erDiagram
    users ||--o{ quizes : "створює"
    users ||--o{ reviews : "пише"
    users ||--o{ quiz_attempts : "проходить"
    users ||--o{ user_quiz_stats : "має"

    quizes ||--o{ reviews : "отримує"
    quizes ||--|{ questions : "містить"
    quizes ||--o{ quiz_attempts : "має"
    quizes ||--o{ user_quiz_stats : "має"

    questions ||--|{ answer_options : "має"
    
    quiz_attempts ||--|{ question_responses : "складається з"

    question_responses ||--o{ selected_answers : "деталізується в"
    answer_options ||--o{ selected_answers : "обирається в"
```

#### Опис таблиць, ключів та обмежень

1.  **users** - Зберігає дані про користувачів.

      * `user_id` (PK): Унікальний числовий ідентифікатор.
      * `username`, `email`: Текстові поля, які є унікальними (`UNIQUE`) для кожного користувача.

2.  **quizes** - Зберігає інформацію про тести (квізи).

      * `quiz_id` (PK): Унікальний ідентифікатор.
      * `author_id` (FK): Зовнішній ключ, що посилається на `users(user_id)`. **Припущення**: Квіз не може існувати без автора. **Обмеження**: При видаленні користувача всі його квізи також видаляються (`ON DELETE CASCADE`).

3.  **questions** - Зберігає питання, що належать до квізів.

      * `question_id` (PK): Унікальний ідентифікатор.
      * `quiz_id` (FK): Зовнішній ключ, що посилається на `quizes(quiz_id)`. **Обмеження**: Питання жорстко прив'язане до квізу і видаляється разом з ним.

4.  **answer\_options** - Зберігає варіанти відповідей до питань.

      * `answer_option_id` (PK): Унікальний ідентифікатор.
      * `question_id` (FK): Зовнішній ключ, що посилається на `questions(question_id)`. **Припущення**: Ця таблиця також зберігає правильні відповіді-ключі для питань типу `free_text`.

5.  **quiz\_attempts** - Детальний журнал кожної спроби проходження тесту.

      * `attempt_id` (PK): Унікальний ідентифікатор.
      * `user_id` (FK), `quiz_id` (FK): Зовнішні ключі, що посилаються на `users` та `quizes`. **Обмеження**: `score` зберігає вже обчислений фінальний бал для швидкості доступу та історичної точності.

6.  **question\_responses** - Фіксує відповідь користувача на одне питання в рамках однієї спроби.

      * `question_response_id` (PK): Унікальний ідентифікатор.
      * `attempt_id` (FK), `question_id` (FK): Зовнішні ключі, що зв'язують відповідь зі спробою та питанням.

7.  **selected\_answers** - Проміжна таблиця для фіксації обраних варіантів у питаннях типу `multiple_choice`.

      * `question_response_id` (PK, FK), `answer_option_id` (PK, FK): Композитний первинний ключ, що гарантує унікальність пари "відповідь-обраний варіант".

8.  **user\_quiz\_stats** - Агрегована таблиця для швидкого доступу до статистики успішності.

      * `user_id` (PK, FK), `quiz_id` (PK, FK): Композитний первинний ключ, що забезпечує один запис статистики на унікальну пару "користувач-квіз". **Припущення**: Поля `best_score`, `last_score` та `attempts` оновлюються логікою додатку після кожної завершеної спроби.

9.  **reviews** - Відгуки та рейтинги користувачів до квізів.

      * `review_id` (PK): Унікальний ідентифікатор.
      * `user_id` (FK), `quiz_id` (FK): Зовнішні ключі, що посилаються на автора відгуку та квіз. **Обмеження**: Поле `rating` приймає лише числові значення від 0 до 5 завдяки `CHECK`.

<img width="848" height="291" alt="image" src="https://github.com/user-attachments/assets/0e42e515-10b6-4565-8449-d3f05bddd718" />

<img width="1349" height="345" alt="image" src="https://github.com/user-attachments/assets/d8e0678d-e50e-41a6-93a4-f214de5123d8" />

<img width="905" height="220" alt="image" src="https://github.com/user-attachments/assets/a814c4d9-d12b-48a6-a2d3-0401e64ebc4c" />

<img width="822" height="670" alt="image" src="https://github.com/user-attachments/assets/49e39351-21bf-4eb1-b9f6-4eebd68e369c" />

<img width="497" height="765" alt="image" src="https://github.com/user-attachments/assets/a4d9d6f9-a9a6-4376-a39f-71f3ec784142" />

<img width="800" height="320" alt="image" src="https://github.com/user-attachments/assets/a08d4499-2147-4d31-8874-bc4bb280db82" />

<img width="775" height="270" alt="image" src="https://github.com/user-attachments/assets/2d893223-44e7-4f3b-8f93-6e0cbd79f1f4" />

<img width="321" height="282" alt="image" src="https://github.com/user-attachments/assets/faf8e4bb-8e84-454b-8725-c435efc375fb" />

<img width="822" height="294" alt="image" src="https://github.com/user-attachments/assets/58a064a4-f548-4f61-a2d5-bbb0a6c672cf" />









