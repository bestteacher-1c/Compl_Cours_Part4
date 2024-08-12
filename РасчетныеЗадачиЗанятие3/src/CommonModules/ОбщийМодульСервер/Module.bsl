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
	Источник.Движения.ПлановыеОсновныеНачисления.Записывать = Истина;
	Источник.Движения.ПлановыеДополнительныеНачисления.Записывать = Истина;
	Источник.Движения.ПлановыеУдержания.Записывать = Истина;
	Источник.Движения.Записать();

	ЗаполнитьНаборЗаписей_Сотрудники(Источник);

	ЗаполнитьНаборЗаписей_ПлановыеОсновныеНачисления(Источник);
	ЗаполнитьНаборЗаписей_ПлановыеДополнительныеНачисления(Источник);
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

Процедура ЗаполнитьНаборЗаписей_ПлановыеОсновныеНачисления(Источник)

	Источник.Движения.ПлановыеОсновныеНачисления.Записывать = Истина;

	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении") Тогда

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлановыеОсновныеНачисленияСрезПоследних.ВидРасчета
		|ИЗ
		|	РегистрСведений.ПлановыеОсновныеНачисления.СрезПоследних(&ДатаСобытия, ФизическоеЛицо = &ФизическоеЛицо) КАК
		|		ПлановыеОсновныеНачисленияСрезПоследних
		|ГДЕ
		|	ПлановыеОсновныеНачисленияСрезПоследних.Размер > 0";

		Запрос.УстановитьПараметр("ДатаСобытия", Источник.ДатаСобытия);
		Запрос.УстановитьПараметр("ФизическоеЛицо", Источник.ФизическоеЛицо);

		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Движение = Источник.Движения.ПлановыеОсновныеНачисления.Добавить();

			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
			Движение.Размер = 0;

		КонецЦикла;

	Иначе

		Для Каждого ТекСтрокаОсновныеНачисления Из Источник.ОсновныеНачисления Цикл

			Движение = Источник.Движения.ПлановыеОсновныеНачисления.Добавить();

			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ТекСтрокаОсновныеНачисления.ВидРасчета;
			Движение.Размер = ТекСтрокаОсновныеНачисления.Размер;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_ПлановыеДополнительныеНачисления(Источник)

	Источник.Движения.ПлановыеДополнительныеНачисления.Записывать = Истина;

	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении") Тогда

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлановыеДополнительныеНачисленияСрезПоследних.ВидРасчета
		|ИЗ
		|	РегистрСведений.ПлановыеДополнительныеНачисления.СрезПоследних(&ДатаСобытия, ФизическоеЛицо = &ФизическоеЛицо) КАК ПлановыеДополнительныеНачисленияСрезПоследних
		|ГДЕ
		|	ПлановыеДополнительныеНачисленияСрезПоследних.Размер > 0";

		Запрос.УстановитьПараметр("ДатаСобытия", Источник.ДатаСобытия);
		Запрос.УстановитьПараметр("ФизическоеЛицо", Источник.ФизическоеЛицо);

		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Движение = Источник.Движения.ПлановыеДополнительныеНачисления.Добавить();

			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ВыборкаДетальныеЗаписи.ВидРасчета;
			Движение.Размер = 0;

		КонецЦикла;

	Иначе

		Для Каждого ТекСтрокаДополнительныеНачисления Из Источник.ДополнительныеНачисления Цикл
		// регистр ПлановыеДополнительныеНачисления 
			Движение = Источник.Движения.ПлановыеДополнительныеНачисления.Добавить();
			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ТекСтрокаДополнительныеНачисления.ВидРасчета;
			Движение.Размер = ТекСтрокаДополнительныеНачисления.Размер;
		КонецЦикла;

	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_ПлановыеУдержания(Источник)

	Источник.Движения.ПлановыеУдержания.Записывать = Истина;

	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении") Тогда

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПлановыеУдержанияСрезПоследних.ВидРасчета
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
			Движение.Размер = 0;

		КонецЦикла;

	Иначе

		Для Каждого ТекСтрокаУдержания Из Источник.Удержания Цикл
		// регистр ПлановыеУдержания 
			Движение = Источник.Движения.ПлановыеУдержания.Добавить();
			Движение.Период = Источник.ДатаСобытия;
			Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
			Движение.ВидРасчета = ТекСтрокаУдержания.ВидРасчета;
			Движение.Размер = ТекСтрокаУдержания.Размер;
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры
#КонецОбласти

Процедура ПроверитьНаличиеОдногоНачисленияЗачетОтработанногоВремени(Приказ, Отказ) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПриказОПриемеОсновныеНачисления.ВидРасчета
	|ПОМЕСТИТЬ ВТОсновныеНачисления
	|ИЗ
	|	Документ.ПриказОПриеме.ОсновныеНачисления КАК ПриказОПриемеОсновныеНачисления
	|Где
	|	Ссылка = &Приказ
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ВТОсновныеНачисления.ВидРасчета) КАК ВидРасчета
	|ИЗ
	|	ВТОсновныеНачисления КАК ВТОсновныеНачисления
	|ГДЕ
	|	ВТОсновныеНачисления.ВидРасчета.ЗачетОтработанногоВремени = ИСТИНА";

	Запрос.УстановитьПараметр("Приказ", Приказ);

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