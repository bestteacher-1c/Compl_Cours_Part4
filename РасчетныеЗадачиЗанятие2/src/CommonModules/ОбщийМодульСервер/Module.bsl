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

Процедура ПроведениеКадровыхДокументовОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт

	Источник.Движения.СостояниеСотрудников.Записывать = Истина;
	Источник.Движения.Записать();
	ЗаполнитьНаборЗаписей_Сотрудники(Источник);

КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_Сотрудники(Источник)

	Источник.Движения.СостояниеСотрудников.Записывать = Истина;

	Движение = Источник.Движения.СостояниеСотрудников.Добавить();

	Движение.Период = Источник.ДатаСобытия;
	Движение.ФизическоеЛицо = Источник.ФизическоеЛицо;
	Движение.Подразделение =Источник.Подразделение;
	Движение.Должность = Источник.Должность;
	Если (ТипЗнч(Источник) = Тип("ДокументОбъект.ПриказОбУвольнении")) Тогда
		Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Уволен;
	Иначе
		Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Работает;
		Движение.ГрафикРаботы = Источник.ГрафикРаботы;
	КонецЕсли;
КонецПроцедуры