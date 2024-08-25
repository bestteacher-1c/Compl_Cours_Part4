Процедура ПередЗаписью(Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов)
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДатаЗапретаИзменений.ДатаЗапрета
		|ИЗ
		|	РегистрСведений.ДатаЗапретаИзменений КАК ДатаЗапретаИзменений";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда

		ДатаЗапрета = ВыборкаДетальныеЗаписи.ДатаЗапрета;

	Иначе
	
		ДатаЗапрета = Дата(1,1,1);
		
	КонецЕсли;
	
	//Проверяем предыдущую версию набора записей, записанную в базу данных
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Удержания.ПериодРегистрации
	|ИЗ
	|	РегистрРасчета.Удержания КАК Удержания
	|ГДЕ
	|	Удержания.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Если ВыборкаДетальныеЗаписи.ПериодРегистрации < ДатаЗапрета Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя менять данные в закрытых периодах";
			Сообщение.Сообщить();
			
			Отказ = Истина;
			Возврат;
		
		КонецЕсли;
		
	КонецЦикла;
	
	
	//Проверяем текущий набор записей

	Если Количество() > 0 Тогда
		
		Если Получить(0).ПериодРегистрации < ДатаЗапрета Тогда
		
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Нельзя записывать данные в закрытых периодах";
			Сообщение.Сообщить();
			
			Отказ = Истина;
		
		КонецЕсли;
	
	КонецЕсли;
	

КонецПроцедуры
