Данный проект содержит обработку с интерфейсом логирования похожим на модуль logos.

# Зачем?
Мне потребовался простой интерфейс для логирования информации в разные приемники (журнал регистра, файлы и т.д.). Найденные решения оказались либо громоздкими, либо имело неудобный интерфейс. Наиболее подходящим показалась подсистема logos портированная из OneScript. Но к сожалению она состоит из нескольких объектов, что накладывает ряд ограничений (например, её нельзя подключить как внешний объект/обработку).

В итоге была создана обработка, в которой я постарался реализовать максимально просто программный интерфейс логирования схожий с logos.

# Использование

## Инициализация
Для начала работы с объектом логирования необходимо выполнить его инициализацию следующим образом:
```bsl
Лог = Обработки.Логирование.Создать();
Лог.Инициализировать("ОбменДанными.Тестирование");
```
Процедура Инициализировать() является обязательной, в ней производится первоначальная настройка объекта обработки и установка имени лога/события. Если имя лога не задано, то будет использоваться значение по умолчанию "Логирование".

## Логирование в консоль сообщений
Нет описания.

## Логирование в журнал регистрации
Для добавления логирования в журнал регистрации используется метод *ДобавитьСпособЛогированияЖурналРегистрации()*.
```bsl
Лог = Обработки.Логирование.Создать();
Лог.Инициализировать("ОбменДанными.Тестирование");
Лог.ДобавитьСпособЛогированияЖурналРегистрации();
```
```bsl
// Добавляет логирование в журнал регистрации.
// Параметры
//     ОбъектМетаданных - ОбъектМетаданных - объект метаданных, к которому будут привязаны сообщения лога в журнале регистрации.
//     ДанныеДляЖурнала - ЛюбаяСсылка - ссылка на объект, к которому будут привязаны сообщения лога в журнале регистрации.
//     ШаблонСообщения  - Строка - шаблон сообщения строки лога, если не задан, то будет использоваться шаблон по-умолчанию.
//     ФорматДаты       - Строка - формат даты, который будет использоваться при заполнении шаблона сообщения.
Процедура ДобавитьСпособЛогированияЖурналРегистрации(ОбъектМетаданных=Неопределено, ДанныеДляЖурнала=Неопределено, Знач ШаблонСообщения="", Знач ФорматДаты="") Экспорт
```

## Логирование в память
Нет описания.

## Логирование в файл
Для подключения логирования в файл необходимо вызвать метод ДобавитьСпособЛогированияФайл(). 
```bsl
// Добавляет логирование в указанный файл.
// Параметры
//     ПутьФайла        - Строка - полный путь до файла лога.
//     Кодировка        - Строка - кодировка в которой будет записываться лог.
//     ШаблонСообщения  - Строка - шаблон сообщения строки лога, если не задан, то будет использоваться шаблон по-умолчанию.
//     ФорматДаты       - Строка - формат даты, который будет использоваться при заполнении шаблона сообщения.
Процедура ДобавитьСпособЛогированияФайл(Знач ПутьФайла, Знач Кодировка="utf-8", Знач ШаблонСообщения="", Знач ФорматДаты="")
```
Пример использования:
```bsl
Лог = ВнешниеОбработки.Создать("D:\Projects\log1c\Логирование.epf");
Лог.Инициализировать("Логирование");
Лог.ДобавитьСпособЛогированияФайл("\\localhost\Logs\log.txt");
Лог.Информация("Тест");
Лог.Закрыть();  // освободит захваченные ресурсы и разблокирует файл лога.
```
*ВАЖНО:* при завершении логирования в файл рекомендуется освободить захваченные ресурсы используя процедуру Закрыть(). 

## Логирование в базу
Не реализовано.

# Шаблон сообщения
При установке способов вывода для них можно задать свой шаблон сообщения. В шаблонах поддерживаются следующие псевдонимы:
* **%УРОВЕНЬ%**- уровень лога которым было сформировано сообщение (например: ИНФОРМАЦИЯ).
* **%СОБЫТИЕ%**   - указанное событие логирования (имя лога).
* **%СООБЩЕНИЕ%** - текст выводимого сообщения.
* **%ДАТА%** - дата и время в формате yyyy.MM.dd HH:mm:ss (например: 2020.09.16 23:52:49), либо в пользовательском формате заданном через параметр ФорматДаты.
* **%ДАТАМС%** - количество миллисекунд текущей даты.
* **%УНИВЕРСАЛЬНАЯДАТАМС%** - универсальная дата полученная с помощью функции ТекущаяУниверсальнаяДатаВМиллисекундах().

**ВАЖНО:** псевдонимы регистрозависмые и допускается их указание только в верхнем регистре.

Пример шаблона:
```bsl
Лог = ВнешниеОбработки.Создать("D:\Projects\log1c\Логирование.epf");
Лог.Инициализировать("Логирование.Тест");
Лог.ДобавитьСпособЛогированияКонсоль("%ДАТА%.%ДАТАМС% - %УНИВЕРСАЛЬНАЯДАТАМС% - %СОБЫТИЕ% - %УРОВЕНЬ% - %СООБЩЕНИЕ%");
Лог.Предупредить("Предупредительное 1 сообщение");
```
```
2020.09.16 23:53:08.771 - 63735861188771 - Логирование.Тест - ПРЕДУПРЕЖДЕНИЕ - Предупредительное 1 сообщение
```


## Использование внешней обработки
Объект логирования можно создать из внешний обработки, это может быть удобным, например, при отладке правил обмена КД 2.0.
```bsl
Лог = ВнешниеОбработки.Создать("D:\Projects\log1c\Логирование.epf");
Лог.Инициализировать("Логирование");
Лог.ДобавитьСпособЛогированияКонсоль();
Лог.Информация("Информационное сообщение");
```

# Другие решения
* Модуль logos из OneScript: https://github.com/oscript-library/logos
* Подсистема логирования на базе модуля logos: https://github.com/1823244/logos-1c