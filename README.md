# TincoffCalculator
Калькулятор написанный по курсу Tinkoff.

## Импользуемые технологии
* Основной фреймворк UIKit.
* Верстка - InterfaceBuilder(Strotyboard)
* Работа с даными: UserDefaults, JSON, Enum, Codable
* Анимация - Core Animation

## Описание экранов
### Основной Экран
* Функционал вычисление выражений, переход на экран с историей.
* Аниамция кнопк калькулятора

### Экран истории
* Функционал загрузка истории из UserDefaults
* Возможность очистить историю

## Сложности при разработке 
* Основная сложность была в правилином кодирования выражений в JSON и его декодирование. Проблема решалась с использованием JSONEncoder, JSONDecoder
