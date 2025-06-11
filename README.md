# Notes API

REST API для создания, получения, обновления и удаления заметок. Поддерживает фильтрацию по архивному статусу и заголовку.

## 🚀 Стек технологий

- **Ruby** 3.4.4
- **Rails** 8.0.2 (API-only)
- **PostgreSQL**
- **RSpec**, **FactoryBot**, **Shoulda Matchers**
- **Blueprinter** для сериализации

## 🛡️ Code Quality

- Подключены GitHub Actions workflow-файлы для:
  - ✅ RuboCop (линтинг)
  - ✅ RSpec (тестирование)

## 📦 Установка

```bash
git clone https://github.com/DariaKalinina25/notes_api.git
cd notes_api

bundle install
rails db:setup
```

## 📘 Эндпоинты

Базовый префикс: `/api/v1`

### Получить список заметок

```http
GET /api/v1/notes
```

**Query-параметры:**
- `archived=true/false`
- `title=some text`

### Получить одну заметку

```http
GET /api/v1/notes/:id
```

### Создать заметку

```http
POST /api/v1/notes
Content-Type: application/json

{
  "note": {
    "title": "My Note",
    "body": "Some content",
    "archived": false
  }
}
```

### Обновить заметку

```http
PATCH /api/v1/notes/:id
Content-Type: application/json

{
  "note": {
    "title": "Updated title"
  }
}
```

### Удалить заметку

```http
DELETE /api/v1/notes/:id
```

## 🧪 Тестирование

- `spec/requests/api/v1/notes_spec.rb` — тесты API (CRUD, фильтрация)
- `spec/services/notes_filter_spec.rb` — тесты фильтрации
- `spec/models/note_spec.rb` — валидации и колонки
