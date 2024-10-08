Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОсновныеНачисления.НомерСтроки,
		|	ОсновныеНачисления.ВидРасчета,
		|	ОсновныеНачисления.Размер
		|ПОМЕСТИТЬ ВТОсновныеНачисления
		|ИЗ
		|	&ОсновныеНачисления КАК ОсновныеНачисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ПриказОПриемеОсновныеНачисления.ВидРасчета) КАК ВидРасчета,
		|	МАКСИМУМ(ПриказОПриемеОсновныеНачисления.НомерСтроки) КАК НомерСтроки
		|ИЗ
		|	ВТОсновныеНачисления КАК ПриказОПриемеОсновныеНачисления
		|ГДЕ
		|	ПриказОПриемеОсновныеНачисления.ВидРасчета.ЗачетОтработанногоВремени = ИСТИНА";
	
	Запрос.УстановитьПараметр("ОсновныеНачисления",Начисления);
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Если ВыборкаДетальныеЗаписи.ВидРасчета > 1 Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Для сотрудника можно указать только одно начисления, учитывающее отработанное время!";
			Сообщение.Поле = "ОсновныеНачисления[" + (ВыборкаДетальныеЗаписи.НомерСтроки - 1) + "].ВидРасчета";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			
		ИначеЕсли ВыборкаДетальныеЗаписи.ВидРасчета = 0 Тогда
			
			Отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Для сотрудника нужно указать одно начисления, учитывающее отработанное время!";
			Сообщение.Поле = "ОсновныеНачисления";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
		
		КонецЕсли;
		
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
КонецПроцедуры
