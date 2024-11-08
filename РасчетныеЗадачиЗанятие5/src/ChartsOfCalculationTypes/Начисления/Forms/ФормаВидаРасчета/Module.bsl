
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеВидимостьюЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетСбораБазыПриИзменении(Элемент)
	
	УправлениеВидимостьюЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетДанныеГрафикаПриИзменении(Элемент)
	
	УправлениеВидимостьюЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюЭлементов()

	Элементы.ГруппаБазовыеВидыРасчета.Видимость = Объект.ТребуетСбораБазы;
	Элементы.ГруппаВытесняющиеВидыРасчета.Видимость = Объект.ТребуетДанныеГрафика;
	
	Элементы.ЗачетОтработанногоВремени.Видимость = Объект.ТребуетДанныеГрафика;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВедущиеВидыРасчета(Команда)
	ПоказатьВопрос(
	Новый ОписаниеОповещения("ПоказатьВопросЗавершение", ЭтотОбъект),
		"Будет перезаполнена таблицы ведущих видов расчета. Продолжить?", РежимДиалогаВопрос.ДаНет, ,
		КодВозвратаДиалога.Да, "Внимание! Процедура необратима!");

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если (Ответ = КодВозвратаДиалога.Да) Тогда
		ЗаполнитьВедущиеВидыРасчетаНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВедущиеВидыРасчетаНаСервере()

	ПВРОбъект = РеквизитФормыВЗначение("Объект");

	ПВРОбъект.ВедущиеВидыРасчета.Очистить();

	Для Каждого ТекСтрокаБазовыеВидыРасчета Из ПВРОбъект.БазовыеВидыРасчета Цикл

		ОбщийМодульСервер.ЗаполнитьТабличнуюЧастьВедущиеВидыРасчета(ТекСтрокаБазовыеВидыРасчета.ВидРасчета, ПВРОбъект);

	КонецЦикла;

	Для Каждого ТекСтрокаВытесняющиеВидыРасчета Из ПВРОбъект.ВытесняющиеВидыРасчета Цикл

		ОбщийМодульСервер.ЗаполнитьТабличнуюЧастьВедущиеВидыРасчета(
			ТекСтрокаВытесняющиеВидыРасчета.ВидРасчета, ПВРОбъект);

	КонецЦикла;

	ЗначениеВРеквизитФормы(ПВРОбъект, "Объект");
	Модифицированность = Истина;

КонецПроцедуры


&НаКлиенте
Процедура СписокПоказателейНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекДанные = Элементы.СписокПоказателей.ТекущиеДанные;
	
	ПараметрыПеретаскивания.Значение	= ТекДанные.Идентификатор;


КонецПроцедуры

