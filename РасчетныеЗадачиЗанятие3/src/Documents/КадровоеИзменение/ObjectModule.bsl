
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриказОПриеме") Тогда

		ДокументОснование = ДанныеЗаполнения;
		ГрафикРаботы = ДанныеЗаполнения.ГрафикРаботы;
		Должность = ДанныеЗаполнения.Должность;
		Подразделение = ДанныеЗаполнения.Подразделение;
		ФизическоеЛицо = ДанныеЗаполнения.ФизическоеЛицо;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.КадровоеИзменение") Тогда

		ДокументОснование = ДанныеЗаполнения;
		ГрафикРаботы = ДанныеЗаполнения.ГрафикРаботы;
		Должность = ДанныеЗаполнения.Должность;
		Подразделение = ДанныеЗаполнения.Подразделение;
		ФизическоеЛицо = ДанныеЗаполнения.ФизическоеЛицо;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	//ОбщийМодульСервер.ПроверитьНаличиеОдногоНачисленияЗачетОтработанногоВремени(Ссылка, Отказ)

КонецПроцедуры


