Процедура ЗаполнитьТабличнуюЧастьВедущиеВидыРасчета(ВидРасчета, ПВРОбъект) Экспорт

	Если ПВРОбъект.ВедущиеВидыРасчета.Найти(ВидРасчета, "ВидРасчета") = Неопределено Тогда

		НоваяСтрока = ПВРОбъект.ВедущиеВидыРасчета.Добавить();
		НоваяСтрока.ВидРасчета = ВидРасчета;

	Иначе

		Возврат;

	КонецЕсли;

	Для Каждого ТекСтрокаБазовыеВидыРасчета Из ВидРасчета.ВедущиеВидыРасчета Цикл

		ЗаполнитьТабличнуюЧастьВедущиеВидыРасчета(
		ТекСтрокаБазовыеВидыРасчета.ВидРасчета, ПВРОбъект);

	КонецЦикла;

КонецПроцедуры


#Область ПодпискаНаСобытияОбработкаПроведенияКадровыхДокументов

Процедура ПроведениеКадровыхДокументовОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт

	Источник.Движения.Сотрудники.Записывать = Истина;
	Источник.Движения.ПлановыеНачисления.Записывать = Истина;
	Источник.Движения.ПлановыеУдержания.Записывать = Истина;
	Источник.Движения.Записать();

	ЗаполнитьНаборЗаписей_Сотрудники(Источник);

	ЗаполнитьНаборЗаписей_ПлановыеНачисления(Источник);
	ЗаполнитьНаборЗаписей_ПлановыеУдержания(Источник);

КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_Сотрудники(Источник)

	Источник.Движения.Сотрудники.Записывать = Истина;

	Движение = Источник.Движения.Сотрудники.Добавить();

	Движение.Период = Источник.ДатаСобытия;
	Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
	Движение.Подразделение = Источник.Подразделение;
	Движение.Должность = Источник.Должность;

	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении") Тогда

		Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Уволен;
		Движение.ГрафикРаботы = Справочники.ВидыГрафиковРаботы.ПустаяСсылка();

	Иначе
		Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Работает;
		Движение.ГрафикРаботы = Источник.ГрафикРаботы;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_ПлановыеНачисления(Источник)

	Источник.Движения.ПлановыеНачисления.Записывать = Истина;

	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении") Тогда

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлановыеНачисленияСрезПоследних.ВидРасчета,
		|	ПлановыеНачисленияСрезПоследних.Показатель
		|ИЗ
		|	РегистрСведений.ПлановыеНачисления.СрезПоследних(&ДатаСобытия, ФизическоеЛицо = &ФизическоеЛицо) КАК
		|		ПлановыеНачисленияСрезПоследних
		|ГДЕ
		|	ПлановыеНачисленияСрезПоследних.Размер > 0";

		Запрос.УстановитьПараметр("ДатаСобытия", Источник.ДатаСобытия);
		Запрос.УстановитьПараметр("ФизическоеЛицо", Источник.ФизическоеЛицо);

		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Движение = Источник.Движения.ПлановыеНачисления.Добавить();

			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
			Движение.Показатель = ВыборкаДетальныеЗаписи.Показатель;
			Движение.Размер = 0;

		КонецЦикла;

	Иначе

		Для Каждого ТекСтрокаНачисления Из Источник.Начисления Цикл

			Движение = Источник.Движения.ПлановыеНачисления.Добавить();

			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ТекСтрокаНачисления.ВидРасчета;
			Движение.Показатель = ТекСтрокаНачисления.Показатель;
			Движение.Размер = ТекСтрокаНачисления.Размер;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_ПлановыеУдержания(Источник)

	Источник.Движения.ПлановыеУдержания.Записывать = Истина;

	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении") Тогда

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлановыеУдержанияСрезПоследних.ВидРасчета,
		|	ПлановыеУдержанияСрезПоследних.Показатель
		|ИЗ
		|	РегистрСведений.ПлановыеУдержания.СрезПоследних(&ДатаСобытия, ФизическоеЛицо = &ФизическоеЛицо) КАК ПлановыеУдержанияСрезПоследних
		|ГДЕ
		|	ПлановыеУдержанияСрезПоследних.Размер > 0";

		Запрос.УстановитьПараметр("ДатаСобытия", Источник.ДатаСобытия);
		Запрос.УстановитьПараметр("ФизическоеЛицо", Источник.ФизическоеЛицо);

		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Движение = Источник.Движения.ПлановыеУдержания.Добавить();

			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
			Движение.Показатель = ВыборкаДетальныеЗаписи.Показатель;
			Движение.Размер = 0;

		КонецЦикла;

	Иначе

		Для Каждого ТекСтрокаУдержания Из Источник.Удержания Цикл
		// регистр ПлановыеУдержания 
			Движение = Источник.Движения.ПлановыеУдержания.Добавить();
			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ТекСтрокаУдержания.ВидРасчета;
			Движение.Показатель = ТекСтрокаУдержания.Показатель;
			Движение.Размер = ТекСтрокаУдержания.Размер;
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры
#КонецОбласти


Процедура ПроверитьНаличиеОдногоНачисленияЗачетОтработанногоВремени(Приказ, Отказ) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлановыеОсновныеНачисленияСрезПоследних.ВидРасчета
	|ПОМЕСТИТЬ ВТОсновныеНачисления
	|ИЗ
	|	РегистрСведений.ПлановыеОсновныеНачисления.СрезПоследних(&Период, ФизическоеЛицо = &ФизическоеЛицо) КАК ПлановыеОсновныеНачисленияСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ВТОсновныеНачисления.ВидРасчета) КАК ВидРасчета 
	|ИЗ
	|	ВТОсновныеНачисления КАК ВТОсновныеНачисления
	|ГДЕ
	|	ВТОсновныеНачисления.ВидРасчета.ЗачетОтработанногоВремени = ИСТИНА";

	Запрос.УстановитьПараметр("Период", Приказ.ДатаСобытия);
	Запрос.УстановитьПараметр("ФизическоеЛицо", Приказ.ФизическоеЛицо);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Если ВыборкаДетальныеЗаписи.ВидРасчета > 1 Тогда

			Отказ = Истина;

			Сообщить("Для сотрудника можно указать только одно начисления, учитывающее отработанное время!");

		ИначеЕсли ВыборкаДетальныеЗаписи.ВидРасчета = 0 Тогда

			Отказ = Истина;

			Сообщить("Для сотрудника нужно указать одно начисления, учитывающее отработанное время!");

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Функция ПолучитьПроцентВыплатыЧислом(ПроцентСсылка) Экспорт

	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._100, 100);
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._60, 60);
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._80, 80);

	Возврат Соответствие.Получить(ПроцентСсылка);
	
КонецФункции // ПолучитьПроцентВыплатыЧислом()


Процедура ЗаполнениеНовогоДокументаОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ДанныеЗаполнения = Неопределено Или ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
			
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ДатаЗапретаИзменений.ДатаЗапрета
			|ИЗ
			|	РегистрСведений.ДатаЗапретаИзменений КАК ДатаЗапретаИзменений";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Источник.ПериодРегистрации = ВыборкаДетальныеЗаписи.ДатаЗапрета;	
			Иначе
		Источник.ПериодРегистрации = Дата(1,1,1);
		КонецЕсли;
		
	
	КонецЕсли;
	
КонецПроцедуры
