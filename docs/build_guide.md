# Инструкция по сборке и запуску

> **Проект:** Глина — клиентское мобильное приложение гончарной мастерской  
> **Flutter SDK:** 3.35.3 (стабильная)  
> **Платформы:** Android, iOS, Web

---

## 1. Требования к окружению

| Компонент | Версия | Где взять |
|-----------|--------|-----------|
| Flutter SDK | 3.35.3 stable | `C:\Users\uzeru\Desktop\flutter_windows_3.35.3-stable\flutter` |
| Dart SDK | ≥3.0.0 <4.0.0 | Входит в Flutter SDK |
| Android Studio | 2023+ | [developer.android.com/studio](https://developer.android.com/studio) |
| Android SDK | API 34+ | Устанавливается через Android Studio SDK Manager |
| JDK | 17+ | Входит в Android Studio |
| Xcode (только iOS) | 15+ | Только на macOS, из App Store |
| CocoaPods (только iOS) | 1.15+ | `sudo gem install cocoapods` (macOS) |

---

## 2. Проверка окружения

```bash
# Убедиться, что Flutter установлен и настроен
flutter doctor

# Ожидаемый вывод (пример):
# [✓] Flutter (Channel stable, 3.35.3)
# [✓] Windows Version (10.0.19045)
# [✓] Android toolchain (Android SDK version 34.0.0)
# [✓] Chrome (for web development)
# [!] Android Studio (version 2023.1)
# [!] VS Code (version 1.90+)
```

> **Примечание:** Если `flutter doctor` показывает ошибки для Android toolchain, откройте Android Studio → SDK Manager и установите Android SDK Platform 34 и Android SDK Build-Tools 34.

---

## 3. Сборка APK (Android) — для проверки ревьюером

Это основной способ получить установочный файл для Android-устройства.

### 3.1. Очистка предыдущей сборки (рекомендуется)

```bash
flutter clean
```

### 3.2. Установка зависимостей

```bash
flutter pub get
```

### 3.3. Сборка APK

```bash
flutter build apk --release
```

**Результат:** APK-файл будет создан по пути:

```
build/app/outputs/flutter-apk/app-release.apk
```

### 3.4. Передача на устройство

1. Подключите Android-устройство по USB (включите «Отладку по USB» в настройках разработчика).
2. Установите APK командой:

```bash
flutter install
```

**Или вручную:**
- Скопируйте `app-release.apk` на устройство через USB, Google Диск, Telegram и т.д.
- Откройте файл на устройстве и подтвердите установку (может потребоваться разрешение на установку из неизвестных источников).

### 3.5. Сборка App Bundle (для Google Play)

```bash
flutter build appbundle --release
```

**Результат:** `build/app/outputs/bundle/release/app-release.aab`

---

## 4. Сборка для iOS (требуется macOS + Xcode)

> **Важно:** Сборка iOS возможна **только на macOS** с установленным Xcode.

### 4.1. Установка CocoaPods

```bash
cd ios
pod install
cd ..
```

### 4.2. Сборка IPA

```bash
flutter build ios --release
```

**Результат:** Xcode проект готов к архивации. Откройте `ios/Runner.xcworkspace` в Xcode:
1. Product → Archive
2. Distribute App → Development (для тестирования на устройствах)

### 4.3. Запуск на подключённом iPhone/iPad

```bash
flutter run --release
```

---

## 5. Запуск на эмуляторе/симуляторе

### Android Emulator

```bash
# Запустить эмулятор (если не запущен)
flutter emulators --launch <emulator_id>

# Запустить приложение
flutter run
```

### iOS Simulator (только macOS)

```bash
# Открыть симулятор
open -a Simulator

# Запустить приложение
flutter run
```

---

## 6. Запуск в Chrome (Web) — для быстрой проверки

```bash
flutter run -d chrome
```

Приложение откроется в браузере по адресу `http://localhost:####`.

---

## 7. Запуск тестов

```bash
# Запустить все тесты
flutter test

# Запустить с покрытием
flutter test --coverage
```

---

## 8. Структура проекта (ключевые файлы)

```
lib/
├── main.dart                          # Точка входа
├── models/
│   ├── master.dart                    # Модель мастера
│   ├── slot.dart                      # Модель слота (занятия)
│   ├── booking.dart                   # Модель брони
│   └── models.dart                    # barrel export
├── services/
│   ├── mock_api_service.dart          # Mock API (хардкодные данные)
│   └── services.dart                  # barrel export
├── viewmodels/
│   ├── schedule_viewmodel.dart        # ViewModel расписания
│   └── booking_viewmodel.dart         # ViewModel бронирования
└── ui/
    ├── common/
    │   └── empty_state.dart           # Пустое состояние / ошибка
    ├── screens/
    │   ├── schedule_screen.dart       # Экран расписания
    │   └── booking_success_screen.dart # Экран успешной записи
    └── widgets/
        ├── slot_card.dart             # Карточка занятия
        └── booking_sheet.dart         # Bottom sheet бронирования
```

---

## 9. Тестовые данные (MockApiService)

| Слот | Статус | Свободно мест | Особенность |
|------|--------|---------------|-------------|
| s1 | available | 3/6 | Обычный слот |
| s2 | fullyBooked | 0/10 | Полностью заполнен |
| s6 | available | 1/10 | Осталось 1 место |
| s12 | cancelledByWorkshop | 0/10 | Отменён (поломка печи) |

**Client ID (хардкод):** `client_001`

---

## 10. Возможные проблемы

### 10.1. `flutter doctor` показывает ошибку Android SDK

```bash
# Установить Android SDK командой (если sdkmanager доступен)
sdkmanager "platforms;android-34" "build-tools;34.0.0"
```

### 10.2. Ошибка Gradle при сборке APK

```bash
# Очистить кеш Gradle
cd android
./gradlew clean
cd ..
flutter build apk --release
```

### 10.3. APK не устанавливается на устройство

- Убедитесь, что «Отладка по USB» включена (Настройки → Для разработчиков).
- Убедитесь, что разрешена установка из неизвестных источников.
- Попробуйте: `flutter install` вместо ручной установки.

### 10.4. iOS сборка не работает на Windows

Сборка iOS **невозможна** на Windows. Используйте:
- **macOS** с Xcode для iOS-сборки
- **Android APK** для проверки на Android-устройстве
- **Chrome** для быстрой проверки функциональности