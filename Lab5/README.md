

### Створення бази даних

Ця база даних розроблена для онлайн-платформи квізів. Вона дозволяє користувачам створювати тести, проходити їх, відстежувати свою успішність та залишати відгуки. Схема складається з 9 основних таблиць, які забезпечують цілісність та ефективність роботи з даними.

#### Діаграма схеми (ERD)

```mermaid
erDiagram
    Users {
        serial user_id PK
        varchar(32) username
        varchar(255) email
        varchar(255) avatar_url
        timestamp_with_time_zone created_at
        boolean is_active
    }

    Quizes {
        serial quiz_id PK
        integer author_id FK
        varchar(255) title
        text description
        integer time_limit
        smallint attempts_limit
        timestamp_with_time_zone created_at
        timestamp_with_time_zone updated_at
        difficulty_enum difficulty
        boolean is_active
    }

    Reviews {
        serial review_id PK
        integer user_id FK
        integer quiz_id FK
        numeric(2-1) rating
        text review_text
        timestamp_with_time_zone created_at
        timestamp_with_time_zone updated_at
    }

    Questions  {
        serial question_id PK
        integer quiz_id FK
        text question_text
        question_type_enum question_type
        smallint points
        boolean is_active
    }

    Answer_Options {
        serial answer_option_id PK
        integer question_id FK
        text option_text
        boolean is_correct
    }

    Quiz_Attempts {
        serial attempt_id PK
        integer user_id FK
        integer quiz_id FK
        timestamp_with_time_zone started_at
        timestamp_with_time_zone finished_at
        smallint score
    }

    Questions_Responses {
        serial question_response_id PK
        integer attempt_id FK
        integer question_id FK
        text free_text_answer
        smallint earned_points
    }

    Selected_Answers {
        integer question_response_id PK,FK
        integer answer_option_id PK,FK
    }

    %% Зв'язки (Relationships)
    Users ||--o{ Quizes : "creates"
    Users ||--o{ Reviews : "writes"
    Users ||--o{ Quiz_Attempts : "makes"
    
    Quizes ||--o{ Reviews : "has"
    Quizes ||--o{ Questions  : "contains"
    Quizes ||--o{ Quiz_Attempts : "is_taken_in"

    Questions  ||--o{ Answer_Options : "has_options"
    Questions  ||--o{ Questions_Responses : "is_answered_in"

    Quiz_Attempts ||--o{ Questions_Responses : "consists_of"
    
    Questions_Responses ||--o{ Selected_Answers : "includes"
    Answer_Options ||--o{ Selected_Answers : "is_selected"
```
### Users

<img width="848" height="291" alt="image" src="https://github.com/user-attachments/assets/0e42e515-10b6-4565-8449-d3f05bddd718" />

### Quizes

<img width="1349" height="345" alt="image" src="https://github.com/user-attachments/assets/d8e0678d-e50e-41a6-93a4-f214de5123d8" />

### Reviews

<img width="905" height="220" alt="image" src="https://github.com/user-attachments/assets/a814c4d9-d12b-48a6-a2d3-0401e64ebc4c" />

### Questions

<img width="822" height="670" alt="image" src="https://github.com/user-attachments/assets/49e39351-21bf-4eb1-b9f6-4eebd68e369c" />

### Answer_Options

<img width="497" height="765" alt="image" src="https://github.com/user-attachments/assets/a4d9d6f9-a9a6-4376-a39f-71f3ec784142" />

### Quiz_Attempts

<img width="800" height="320" alt="image" src="https://github.com/user-attachments/assets/a08d4499-2147-4d31-8874-bc4bb280db82" />

### Questions_Responses

<img width="775" height="270" alt="image" src="https://github.com/user-attachments/assets/2d893223-44e7-4f3b-8f93-6e0cbd79f1f4" />

### Selected_Answers 

<img width="321" height="282" alt="image" src="https://github.com/user-attachments/assets/faf8e4bb-8e84-454b-8725-c435efc375fb" />










