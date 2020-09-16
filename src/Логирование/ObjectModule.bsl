﻿
#Область ПрограммныйИнтерфейс

#Область УстановкаНастроек

// Инициализирует объект логирования с указанными настройками.
// Параметры
//     ИмяСобытия         - Строка - имя события/лога.
Процедура Инициализировать(ИмяСобытия="Логирование") Экспорт
	
	ЭтотОбъект.Событие            = ИмяСобытия;
	ЭтотОбъект.Инициализирован    = Истина;
	ЭтотОбъект.ДанныеЖР           = Неопределено;
	ЭтотОбъект.ОбъектМетаданныхЖР = Неопределено;
	ЭтотОбъект.УровеньЛогирования = "";
	ЭтотОбъект.ФайлЛога           = Неопределено;
	ЭтотОбъект.СпособыЛогирования.Очистить();
	ЭтотОбъект.СообщенияЛога.Очистить();
	
КонецПроцедуры

// Завершает работу лога, освобождает все захваченные ресурсы и сбрасывает все настройки логирования.
Процедура Закрыть() Экспорт
	
	// Освобождение захваченных ресурсов.
	Если ЭтотОбъект.ФайлЛога <> Неопределено Тогда
		ЭтотОбъект.ФайлЛога.Закрыть();
	КонецЕсли;
	
	ЭтотОбъект.Инициализирован    = Ложь;
	ЭтотОбъект.ДанныеЖР           = Неопределено;
	ЭтотОбъект.ОбъектМетаданныхЖР = Неопределено;
	ЭтотОбъект.УровеньЛогирования = "";
	ЭтотОбъект.ФайлЛога           = Неопределено;
	ЭтотОбъект.СпособыЛогирования.Очистить();
	ЭтотОбъект.СообщенияЛога.Очистить();
	
КонецПроцедуры

// Устанавливает событие логирования.
Процедура УстановитьСобытие(ИмяСобытия) Экспорт
	ЭтотОбъект.Событие = ИмяСобытия;
КонецПроцедуры

// Устанавливает уровень логирования.
// Параметры
//     УровеньЛога - Строка - один из уровней логирования: ОТЛАДКА, ИНФОРМАЦИЯ, ПРЕДУПРЕЖДЕНИЕ, ОШИБКА.
Процедура УстановитьУровень(УровеньЛога) Экспорт
	
	Если ПолучитьУровниЛогирования().Получить(ВРег(УровеньЛога)) = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Указан недопустимый уровень логирвоания «%1». Допустимые уровни: ОТЛАДКА, ИНФОРМАЦИЯ, ПРЕДУПРЕЖДЕНИЕ, ОШИБКА.", ВРег(УровеньЛога));
	КонецЕсли;
	
	ЭтотОбъект.УровеньЛогирования = ВРег(УровеньЛога);
		
КонецПроцедуры

// Отключает логирование, базовае методы перестают записывать сообщения.
Процедура Отключить() Экспорт
	ЭтотОбъект.Отключен = Истина;
КонецПроцедуры

// Включает логирование.
Процедура Включить() Экспорт
	ЭтотОбъект.Отключен = Ложь;
КонецПроцедуры

// Формирует структуру с описанием способа логирования
// Параметры
//     СпособЛогирования  - Строка - название способа вывода: ЖурналРегистрации, Консоль, Файл.
//     УровеньЛогирования - Строка - пока не используется.
//     ШаблонСообщения    - Строка - строка шаблона сообщения. Допустимые ключевые слова:
//       * %ДАТА%      - дата сообщения в формате указанном в ФорматДаты.
//       * %СООБЩЕНИЕ% - текст выводимого сообщения
//       * %УРОВЕНЬ%   - название уровня сообщения: ИНФОРМАЦИЯ, ОШИБКА и т.д..
//     ФорматДаты         - Строка - строка с форматом даты в сообщении лога.
//     ПутьКФайлуЛогов    - Строка - пока не используется.
// 
// Возвращаемое значение:
//     Структура - структура с описанием способа логирования, в которой есть следующие поля:
//       * Имя             - Строка - имя способа логирования: ЖурналРегистрации, Консоль, Файл.
//       * Уровень         - Строка - имя уровня логирования.
//       * ШаблонСообщения - Строка - строка с описание шаблона сообщения лога.
//       * ФорматДаты      - Строка - строка с форматом даты используемой в шаблоне сообщения (%ДАТА%).
//       * ИмяФайла        - Строка - имя файла лога, задается только для логирования в файл.
Функция ПолучитьОписаниеСпособаЛогирования(Знач СпособЛогирования, 
										   Знач УровеньЛогирования=Неопределено, 
										   Знач ШаблонСообщения="%СООБЩЕНИЕ%", 
										   Знач ФорматДаты="ДФ='yyyy-MM-dd HH:mm:ss'", 
										   Знач ПутьКФайлуЛогов="") Экспорт
										   
	Описание = Новый Структура;
	Описание.Вставить("ИмяСпособа",      СпособЛогирования); 
	Описание.Вставить("Уровень",         УровеньЛогирования);
	Описание.Вставить("ШаблонСообщения", ШаблонСообщения); 
	Описание.Вставить("ФорматДаты",      ФорматДаты);
	Описание.Вставить("ИмяФайла",        ПутьКФайлуЛогов);
										   
	Возврат Описание;
	
КонецФункции

// Добавляет логирование в журнал регистрации.
// Параметры
//     ОбъектМетаданных - ОбъектМетаданных - объект метаданных, к которому будут привязаны сообщения лога в журнале регистрации.
//     ДанныеДляЖурнала - ЛюбаяСсылка - ссылка на объект, к которому будут привязаны сообщения лога в журнале регистрации.
//     ШаблонСообщения  - Строка - шаблон сообщения строки лога, если не задан, то будет использоваться шаблон по-умолчанию.
//     ФорматДаты       - Строка - формат даты, который будет использоваться при заполнении шаблона сообщения.
Процедура ДобавитьСпособЛогированияЖурналРегистрации(ОбъектМетаданных=Неопределено, ДанныеДляЖурнала=Неопределено, Знач ШаблонСообщения="", Знач ФорматДаты="") Экспорт
	
	ЭтотОбъект.ОбъектМетаданныхЖР = ОбъектМетаданных;
	ЭтотОбъект.ДанныеЖР           = ДанныеДляЖурнала;
	
	ШаблонСообщения = ?(ЗначениеЗаполнено(ШаблонСообщения), ШаблонСообщения, ШаблонПоУмолчаниюЖурналРегистрации());
	ФорматДаты      = ?(ЗначениеЗаполнено(ФорматДаты), ФорматДаты, ФорматДатыПоУмолчанию());
	
	// Проверить наличие способа логирования.
	СпособЛогирования = ЭтотОбъект.СпособыЛогирования.Найти("ЖурналРегистрации", "ИмяСпособа");
	Если СпособЛогирования <> Неопределено Тогда
		СпособЛогирования.ШаблонСообщения = ШаблонСообщения;
		СпособЛогирования.ФорматДаты      = ФорматДаты;
		Возврат;
	КонецЕсли;
	
	// Добавление способа логирования.
	ОписаниеСпособаЛогирования = ПолучитьОписаниеСпособаЛогирования("ЖурналРегистрации", , ШаблонСообщения, ФорматДаты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект.СпособыЛогирования.Добавить(), ОписаниеСпособаЛогирования);
	
КонецПроцедуры

// Добавляет логирование в консоль (окно сообщений).
// Параметры
//     ШаблонСообщения  - Строка - шаблон сообщения строки лога, если не задан, то будет использоваться шаблон по-умолчанию.
//     ФорматДаты       - Строка - формат даты, который будет использоваться при заполнении шаблона сообщения.
Процедура ДобавитьСпособЛогированияКонсоль(Знач ШаблонСообщения="", Знач ФорматДаты="") Экспорт
	
	ШаблонСообщения = ?(ЗначениеЗаполнено(ШаблонСообщения), ШаблонСообщения, ШаблонПоУмолчаниюКонсоль());
	ФорматДаты      = ?(ЗначениеЗаполнено(ФорматДаты), ФорматДаты, ФорматДатыПоУмолчанию());
	
	// Проверить наличие способа логирования.
	СпособЛогирования = ЭтотОбъект.СпособыЛогирования.Найти("Консоль", "ИмяСпособа");
	Если СпособЛогирования <> Неопределено Тогда
		СпособЛогирования.ШаблонСообщения = ШаблонСообщения;
		СпособЛогирования.ФорматДаты      = ФорматДаты;
		Возврат;
	КонецЕсли;
	
	// Добавление способа логирования.
	ОписаниеСпособаЛогирования = ПолучитьОписаниеСпособаЛогирования("Консоль", , ШаблонСообщения, ФорматДаты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект.СпособыЛогирования.Добавить(), ОписаниеСпособаЛогирования);
	
КонецПроцедуры

// Добавляет логирование в табличную часть обработки СообщенияЛога.
// Параметры
//     ШаблонСообщения  - Строка - шаблон сообщения строки лога, если не задан, то будет использоваться шаблон по-умолчанию.
//     ФорматДаты       - Строка - формат даты, который будет использоваться при заполнении шаблона сообщения.
Процедура ДобавитьСпособЛогированияПамять(Знач ШаблонСообщения="", Знач ФорматДаты="") Экспорт
	
	ШаблонСообщения = ?(ЗначениеЗаполнено(ШаблонСообщения), ШаблонСообщения, ШаблонПоУмолчаниюПамять());
	ФорматДаты      = ?(ЗначениеЗаполнено(ФорматДаты), ФорматДаты, ФорматДатыПоУмолчанию());
	
	// Проверить наличие способа логирования.
	СпособЛогирования = ЭтотОбъект.СпособыЛогирования.Найти("Память", "ИмяСпособа");
	Если СпособЛогирования <> Неопределено Тогда
		СпособЛогирования.ШаблонСообщения = ШаблонСообщения;
		СпособЛогирования.ФорматДаты      = ФорматДаты;
		Возврат;
	КонецЕсли;
	
	// Добавление способа логирования.
	ОписаниеСпособаЛогирования = ПолучитьОписаниеСпособаЛогирования("Память", , ШаблонСообщения, ФорматДаты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект.СпособыЛогирования.Добавить(), ОписаниеСпособаЛогирования);
	
КонецПроцедуры

// Добавляет логирование в указанный файл.
// Параметры
//     ПутьФайла        - Строка - полный путь до файла лога.
//     Кодировка        - Строка - кодировка в которой будет записываться лог.
//     ШаблонСообщения  - Строка - шаблон сообщения строки лога, если не задан, то будет использоваться шаблон по-умолчанию.
//     ФорматДаты       - Строка - формат даты, который будет использоваться при заполнении шаблона сообщения.
Процедура ДобавитьСпособЛогированияФайл(Знач ПутьФайла, Знач Кодировка="utf-8", Знач ШаблонСообщения="", Знач ФорматДаты="") Экспорт
	
	Если НЕ ЭтотОбъект.Инициализирован Тогда
		ВызватьИсключение "Объект не инициализирован. Выполните инициализацию с помощью метода Инициализировать().";
	КонецЕсли;
	
	ЭтотОбъект.ФайлЛога = Новый ЗаписьТекста(ПутьФайла, Кодировка, , Истина);
	ШаблонСообщения     = ?(ЗначениеЗаполнено(ШаблонСообщения), ШаблонСообщения, ШаблонПоУмолчаниюФайл());
	ФорматДаты          = ?(ЗначениеЗаполнено(ФорматДаты), ФорматДаты, ФорматДатыПоУмолчанию());
	
	// Проверить наличие способа логирования.
	СпособЛогирования = ЭтотОбъект.СпособыЛогирования.Найти("Файл", "ИмяСпособа");
	Если СпособЛогирования <> Неопределено Тогда
		СпособЛогирования.ШаблонСообщения = ШаблонСообщения;
		СпособЛогирования.ФорматДаты      = ФорматДаты;
		СпособЛогирования.ИмяФайла        = ПутьФайла;
		Возврат;
	КонецЕсли;
	
	// Добавление способа логирования.
	ОписаниеСпособаЛогирования = ПолучитьОписаниеСпособаЛогирования("Файл", , ШаблонСообщения, ФорматДаты, ПутьФайла);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект.СпособыЛогирования.Добавить(), ОписаниеСпособаЛогирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОсновныеМетоды

Процедура Отладка(Знач Сообщение) Экспорт
	
	Если ЭтотОбъект.Отключен Тогда
		Возврат;
	КонецЕсли;
	
	// Пропускаем вывод сообщения, если установлен уровень логирования больше уровня текущего метода логирования.
	Если ПолучитьПриоритетУровняЛогирования(ЭтотОбъект.УровеньЛогирования) > ПолучитьПриоритетУровняЛогирования("ОТЛАДКА") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьНастройки();
	
	Для Каждого СпособЛогирования ИЗ СпособыЛогирования Цикл
		
		Если ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Консоль") Тогда
			ОтладкаКонсоль(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("ЖурналРегистрации") Тогда
			ОтладкаЖурналРегистрации(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Память") Тогда
			ОтладкаПамять(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Файл") Тогда
			ОтладкаФайл(Сообщение, СпособЛогирования);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Информация(Знач Сообщение) Экспорт
	
	Если ЭтотОбъект.Отключен Тогда
		Возврат;
	КонецЕсли;
	
	// Пропускаем вывод сообщения, если установлен уровень логирования больше уровня текущего метода логирования.
	Если ПолучитьПриоритетУровняЛогирования(ЭтотОбъект.УровеньЛогирования) > ПолучитьПриоритетУровняЛогирования("ИНФОРМАЦИЯ") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьНастройки();
	
	Для Каждого СпособЛогирования ИЗ СпособыЛогирования Цикл
		
		Если ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Консоль") Тогда
			ИнформацияКонсоль(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("ЖурналРегистрации") Тогда
			ИнформацияЖурналРегистрации(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Память") Тогда
			ИнформацияПамять(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Файл") Тогда
			ИнформацияФайл(Сообщение, СпособЛогирования);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Инфо(Знач Сообщение)  Экспорт
	ЭтотОбъект.Информация(Сообщение);
КонецПроцедуры

Процедура _Предупреждение(Знач Сообщение) Экспорт
	
	Если ЭтотОбъект.Отключен Тогда
		Возврат;
	КонецЕсли;
	
	// Пропускаем вывод сообщения, если установлен уровень логирования больше уровня текущего метода логирования.
	Если ПолучитьПриоритетУровняЛогирования(ЭтотОбъект.УровеньЛогирования) > ПолучитьПриоритетУровняЛогирования("ПРЕДУПРЕЖДЕНИЕ") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьНастройки();
	
	Для Каждого СпособЛогирования ИЗ СпособыЛогирования Цикл
		
		Если ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Консоль") Тогда
			ПредупреждениеКонсоль(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("ЖурналРегистрации") Тогда
			ПредупреждениеЖурналРегистрации(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Память") Тогда
			ПредупреждениеПамять(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Файл") Тогда
			ПредупреждениеФайл(Сообщение, СпособЛогирования);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Предупредить(Знач Сообщение) Экспорт
	_Предупреждение(Сообщение);
КонецПроцедуры

Процедура Ошибка(Знач Сообщение) Экспорт
	
	Если ЭтотОбъект.Отключен Тогда
		Возврат;
	КонецЕсли;
	
	// Пропускаем вывод сообщения, если установлен уровень логирования больше уровня текущего метода логирования.
	Если ПолучитьПриоритетУровняЛогирования(ЭтотОбъект.УровеньЛогирования) > ПолучитьПриоритетУровняЛогирования("ОШиБКА") Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьНастройки();
	
	Для Каждого СпособЛогирования ИЗ СпособыЛогирования Цикл
		
		Если ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Консоль") Тогда
			ОшибкаКонсоль(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("ЖурналРегистрации") Тогда
			ОшибкаЖурналРегистрации(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Память") Тогда
			ОшибкаПамять(Сообщение, СпособЛогирования);
		ИначеЕсли ВРег(СпособЛогирования.ИмяСпособа) = ВРег("Файл") Тогда
			ОшибкаФайл(Сообщение, СпособЛогирования);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеМетоды

// Формирует текстовое представление для логов из памяти (сохраненных в объекте обработки).
Функция ПолучитьЛогИзПамяти() Экспорт
	
	СтрокиЛога = Новый Массив;
	Для Каждого СтрокаСообщения ИЗ ЭтотОбъект.СообщенияЛога Цикл
		
		СтрокаЛога = СтрШаблон("%1 - %2 - %3", Формат(СтрокаСообщения.Дата, ФорматДатыПоУмолчанию()), СтрокаСообщения.Уровень, СтрокаСообщения.Сообщение);
		СтрокиЛога.Добавить(СтрокаЛога);
		
	КонецЦикла;
	
	Возврат СтрСоединить(СтрокиЛога, Символы.ПС);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ЗаписьВЖурналРегистрации

Процедура ОтладкаЖурналРегистрации(Знач Сообщение, ОписаниеСпособаЛогирования)
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОТЛАДКА");
	ЗаписатьВЖурналРегистрации(Сообщение, УровеньЖурналаРегистрации.Примечание);
КонецПроцедуры

Процедура ИнформацияЖурналРегистрации(Знач Сообщение, ОписаниеСпособаЛогирования)
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ИНФОРМАЦИЯ");
	ЗаписатьВЖурналРегистрации(Сообщение, УровеньЖурналаРегистрации.Информация);
КонецПроцедуры

Процедура ПредупреждениеЖурналРегистрации(Знач Сообщение, ОписаниеСпособаЛогирования)
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ПРЕДУПРЕЖДЕНИЕ");
	ЗаписатьВЖурналРегистрации(Сообщение, УровеньЖурналаРегистрации.Предупреждение);
КонецПроцедуры

Процедура ОшибкаЖурналРегистрации(Знач Сообщение, ОписаниеСпособаЛогирования)
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОШИБКА");
	ЗаписатьВЖурналРегистрации(Сообщение, УровеньЖурналаРегистрации.Ошибка);
КонецПроцедуры

Процедура ЗаписатьВЖурналРегистрации(Знач Сообщение, Знач УровеньЖР=Неопределено)
	
	УровеньЖР = ?(УровеньЖР = Неопределено, УровеньЖурналаРегистрации.Примечание, УровеньЖР);
	
	Если ЭтотОбъект.ОбъектМетаданныхЖР <> Неопределено Тогда
		ЗаписьЖурналаРегистрации(ЭтотОбъект.Событие, УровеньЖР, ЭтотОбъект.ОбъектМетаданныхЖР, ЭтотОбъект.ДанныеЖР, Сообщение);
	Иначе
		ЗаписьЖурналаРегистрации(ЭтотОбъект.Событие, УровеньЖР, , ЭтотОбъект.ДанныеЖР, Сообщение);	
	КонецЕсли;
	
КонецПроцедуры

Функция ШаблонПоУмолчаниюЖурналРегистрации() 
	Возврат "%СООБЩЕНИЕ%";
КонецФункции

#КонецОбласти

#Область ЗаписьВКонсоль

Процедура ОтладкаКонсоль(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОТЛАДКА");
	Сообщить(Сообщение, СтатусСообщения.БезСтатуса);
	
КонецПроцедуры

Процедура ИнформацияКонсоль(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ИНФОРМАЦИЯ");
	Сообщить(Сообщение, СтатусСообщения.Информация);
	
КонецПроцедуры

Процедура ПредупреждениеКонсоль(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ПРЕДУПРЕЖДЕНИЕ");
	Сообщить(Сообщение, СтатусСообщения.Внимание);
	
КонецПроцедуры

Процедура ОшибкаКонсоль(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОШИБКА");
	Сообщить(Сообщение, СтатусСообщения.Важное);
	
КонецПроцедуры

Функция ШаблонПоУмолчаниюКонсоль()
	Возврат "%ДАТА% - %УРОВЕНЬ% - %СООБЩЕНИЕ%";
КонецФункции

#КонецОбласти

#Область ЗаписьВПамять

Процедура ОтладкаПамять(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	СтрокаЛога           = ЭтотОбъект.СообщенияЛога.Добавить();
	СтрокаЛога.Дата      = ТекущаяДата();
	СтрокаЛога.Уровень   = "ОТЛАДКА";
	СтрокаЛога.Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОТЛАДКА");
	
КонецПроцедуры

Процедура ИнформацияПамять(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	СтрокаЛога           = ЭтотОбъект.СообщенияЛога.Добавить();
	СтрокаЛога.Дата      = ТекущаяДата();
	СтрокаЛога.Уровень   = "ИНФОРМАЦИЯ";
	СтрокаЛога.Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ИНФОРМАЦИЯ");
	
КонецПроцедуры

Процедура ПредупреждениеПамять(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	СтрокаЛога           = ЭтотОбъект.СообщенияЛога.Добавить();
	СтрокаЛога.Дата      = ТекущаяДата();
	СтрокаЛога.Уровень   = "ПРЕДУПРЕЖДЕНИЕ";
	СтрокаЛога.Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ПРЕДУПРЕЖДЕНИЕ");
	
КонецПроцедуры

Процедура ОшибкаПамять(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	СтрокаЛога           = ЭтотОбъект.СообщенияЛога.Добавить();
	СтрокаЛога.Дата      = ТекущаяДата();
	СтрокаЛога.Уровень   = "ОШИБКА";
	СтрокаЛога.Сообщение = СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОШИБКА");
	
КонецПроцедуры

Функция ШаблонПоУмолчаниюПамять()
	Возврат "%СООБЩЕНИЕ%";
КонецФункции

#КонецОбласти

#Область ЗаписьВФайл

Процедура ОтладкаФайл(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	ФайлЛога.ЗаписатьСтроку(СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОТЛАДКА"));
	
КонецПроцедуры

Процедура ИнформацияФайл(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	ФайлЛога.ЗаписатьСтроку(СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ИНФОРМАЦИЯ"));
	
КонецПроцедуры

Процедура ПредупреждениеФайл(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	ФайлЛога.ЗаписатьСтроку(СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ПРЕДУПРЕЖДЕНИЕ"));
	
КонецПроцедуры

Процедура ОшибкаФайл(Знач Сообщение, ОписаниеСпособаЛогирования)
	
	ФайлЛога.ЗаписатьСтроку(СформироватьСообщениеЛога(Сообщение, ОписаниеСпособаЛогирования, "ОШИБКА"));
	
КонецПроцедуры

Функция ШаблонПоУмолчаниюФайл()
	Возврат "%ДАТА% - %УРОВЕНЬ% - %СООБЩЕНИЕ%";
КонецФункции

#КонецОбласти

#Область ЗаписьВРегистр

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

Функция Инициализирован()
	Возврат Инициализирован;
КонецФункции

Функция СформироватьСообщениеПоШаблону(Знач Сообщение, Знач Уровень, Знач ДатаСообщения) 
	
	
	
	
КонецФункции

Функция ШаблонСообщенияПоУмолчанию()
	Возврат "%ДАТА% - %УРОВЕНЬ% - %СООБЩЕНИЕ%";
КонецФункции

Функция ФорматДатыПоУмолчанию()
	Возврат "ДФ='yyyy.MM.dd HH:mm:ss'";
КонецФункции

// Проверяет корректность настроек логирования и генерирует исключение, если найдена ошибка.
Процедура ПроверитьНастройки()
	
	Если Не ЭтотОбъект.Инициализирован Тогда
		ВызватьИсключение "Не выполнена инициализация лога (см. метод Инициализировать()).";
	КонецЕсли;
	
	Если ЭтотОбъект.СпособыЛогирования.Количество() = 0 Тогда
		ВызватьИсключение "Не заданы способы логирования";
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьСообщениеЛога(Знач Сообщение, ОписаниеСпособаЛогирования, Знач УровеньЛогирования) 
	
	// Способ определения миллисекунд не точный, могут быть коллизии на границах перехода между секундами,
	// в дате сообщения может оказаться одна секунда (например 54), а в универсальной дате следующая (например, 55).
	// Для более точного определения миллисекун необходимо дату целиком извлекать из универсальной даты в мс.
	ДатаСообщения                = ТекущаяДата();
	ДатаСообщенияУниверсальнаяМС = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ДатаМиллисекунды             = ТекущаяУниверсальнаяДатаВМиллисекундах() % 1000; 
	ДатаПредставление            = Формат(ДатаСообщения, ОписаниеСпособаЛогирования.ФорматДаты);	
	ДатаПредставлениеМС          = Формат(ДатаМиллисекунды, "ЧЦ=3; ЧДЦ=0; ЧВН=; ЧГ=");
	
	СтрокаСообщения = ОписаниеСпособаЛогирования.ШаблонСообщения;
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%ДАТА%",                 ДатаПредставление);
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%ДАТАМС%",               ДатаПредставлениеМС);
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%УНИВЕРСАЛЬНАЯДАТАМС%",  Формат(ДатаСообщенияУниверсальнаяМС, "ЧГ="));
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%УРОВЕНЬ%",              УровеньЛогирования);
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%СООБЩЕНИЕ%",            Сообщение);
	СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "%СОБЫТИЕ%",              ЭтотОбъект.Событие);
		
	Возврат СтрокаСообщения;
	
КонецФункции

// Возвращает соответствие уровней логирования и их приоритет: [Уроверь => Приоритет].
Функция ПолучитьУровниЛогирования() 
	
	Уровни = Новый Соответствие;
	Уровни.Вставить("ОТЛАДКА",        0);
	Уровни.Вставить("ИНФОРМАЦИЯ",     1);
	Уровни.Вставить("ПРЕДУПРЕЖДЕНИЕ", 2);
	Уровни.Вставить("ОШИБКА",         3);
	
	Возврат Уровни;
	
КонецФункции

// Возвращает числовой приоритет переданного уровня логирования.
// Параметры
//     Уровень - Строка - имя уровеня лога.
// 
// Возвращаемое значение:
//     Число - числовой приоритет переданного уровня, если такой уровень неизвестен, будет возвращено -1 (наименьший приоритет).
Функция ПолучитьПриоритетУровняЛогирования(Знач Уровень) 
	
	Приоритет = ПолучитьУровниЛогирования().Получить(ВРег(Уровень));
	Если Приоритет = Неопределено Тогда
		Возврат -1;
	КонецЕсли;
	
	Возврат Приоритет;
	
КонецФункции

#КонецОбласти