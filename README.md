# Pheditor

Мобильное приложение для редактирования изображений с возможностью рисования.

## Технологии

- **Flutter 3.10** — кроссплатформенный UI фреймворк
- **Firebase Auth** — аутентификация пользователей
- **Cloud Firestore** — хранение метаданных изображений
- **Cloudinary** — облачное хранилище изображений
- **flutter_bloc** — управление состоянием (Cubit)
- **go_router** — декларативная навигация

## Архитектура

```
DI/                    # Service Locator
DS/                    # Design System (цвета, шрифты, иконки)
models/                # Модели данных
navigation/            # Роутинг
pages/                 # Экраны
auth_page/         # Авторизация
canvas/            # Холст для рисования
gallery/           # Галерея
repositories/          # Работа с Firestore
services/              # Auth, Cloudinary, Connectivity
widgets/               # Общие виджеты
```

### Слои

1. **Presentation** — UI, страницы
2. **State Management** — Cubit для состояния экранов
3. **Services** — внешние API (Firebase, Cloudinary)
4. **Repositories** — абстракция над данными

### Модули

**Canvas** — рисование на холсте с кистью и ластиком, выбор цвета и толщины

**Auth** — вход/регистрация через Firebase Auth

**Gallery** — отображение и управление сохранёнными изображениями

## Запуск

```bash
flutter pub get
flutter run
```

## Конфигурация

Создайте `.env` в корне:

```
CLOUDINARY_CLOUD_NAME=xxx
CLOUDINARY_UPLOAD_PRESET=xxx
```
