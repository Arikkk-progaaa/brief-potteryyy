# Инструкция для ревьюера

Клиентское приложение гончарной мастерской «Глина».  
Платформы: **Android**, **Web** (Chrome). Сборка iOS возможна только на macOS.

---

## Что нужно установить

| Компонент | Версия | Ссылка |
|-----------|--------|--------|
| **Flutter SDK** | 3.35.3 stable | [Скачать Flutter](https://docs.flutter.dev/get-started/install) · [Архив версий](https://docs.flutter.dev/release/archive) |
| **Android Studio** | 2023+ (для Android) | [developer.android.com/studio](https://developer.android.com/studio) |
| **Android SDK** | API 34+ | Устанавливается в Android Studio → SDK Manager |
| **JDK** | 17+ | Входит в Android Studio; отдельно: [Adoptium Temurin 17](https://adoptium.net/) |
| **Google Chrome** | актуальная | [google.com/chrome](https://www.google.com/chrome/) |

Dart входит в состав Flutter SDK, отдельно ставить не нужно.

После установки Flutter добавьте его в `PATH` и выполните:

```bash
flutter doctor
```

Если есть ошибки по Android — откройте Android Studio → **SDK Manager** и установите **Android SDK Platform 34** и **Android SDK Build-Tools 34**.

---

## Запуск

Клонируйте репозиторий, перейдите в папку проекта и выполните:

```bash
flutter pub get
```

### Вариант 1 — Chrome (самый быстрый)

```bash
flutter run -d chrome
```

Приложение откроется в браузере.

### Вариант 2 — Android-эмулятор или телефон

1. Запустите эмулятор в Android Studio **или** подключите телефон с включённой «Отладкой по USB».
2. Выполните:

```bash
flutter run
```

### Вариант 3 — установочный APK на телефон

```bash
flutter build apk --release
```

Готовый файл: `build/app/outputs/flutter-apk/app-release.apk`  
Скопируйте его на телефон и установите (может понадобиться разрешение на установку из неизвестных источников).

---

## Тесты (по желанию)

```bash
flutter test
```
