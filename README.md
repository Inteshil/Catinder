# Catinder 🐱

Мобильное приложение для знакомства с котиками! Свайпайте вправо, если котик понравился, и влево, если нет.

## Установка

### Скачать APK

[![Download APK](https://img.shields.io/badge/Download-APK-green.svg)](releases/latest/catinder.apk)

### Собрать из исходников

```bash
git clone https://github.com/Inteshil/catinder.git
cd catinder
flutter pub get
flutter run
```

## Особенности приложения

- 🐱 Просмотр случайных котиков разных пород
- 👆 Удобные свайпы для оценки котиков
- ❤️ Подсчет количества понравившихся котиков
- 🖼️ Кэширование изображений для быстрой загрузки
- 🔍 Детальная информация о каждой породе

## Скриншоты

<table>
  <tr>
    <td><img src="screenshots/home.png" width="200"/></td>
    <td><img src="screenshots/details.png" width="200"/></td>
  </tr>
</table>

## Технологии

- Flutter & Dart
- The Cat API для получения данных о котиках
- Dio для работы с сетью
- CachedNetworkImage для кэширования изображений

## Разработка

Проект использует:
- Статический анализ кода с помощью `flutter_lints`
- Форматирование кода с `dart format`
- Анализ кода с `flutter analyze`