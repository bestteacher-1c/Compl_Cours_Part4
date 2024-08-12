
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуСписокЗаписейТребующихПерерасчета();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСписокЗаписейТребующихПерерасчета()
	
	Объект.СписокЗаписейТребующихПерерасчета.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Перерасчет.ОбъектПерерасчета,
	|	Перерасчет.ВидРасчета,
	|	Перерасчет.ФизическоеЛицо,
	|	Перерасчет.ОбъектПерерасчета.МоментВремени КАК ОбъектПерерасчетаМоментВремени
	|ИЗ
	|	РегистрРасчета.ДополнительныеНачисления.Перерасчет КАК Перерасчет
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Перерасчет.ОбъектПерерасчета,
	|	Перерасчет.ВидРасчета,
	|	Перерасчет.ФизическоеЛицо,
	|	Перерасчет.ОбъектПерерасчета.МоментВремени
	|ИЗ
	|	РегистрРасчета.ОсновныеНачисления.Перерасчет КАК Перерасчет
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Перерасчет.ОбъектПерерасчета,
	|	Перерасчет.ВидРасчета,
	|	Перерасчет.ФизическоеЛицо,
	|	Перерасчет.ОбъектПерерасчета.МоментВремени
	|ИЗ
	|	РегистрРасчета.Удержания.Перерасчет КАК Перерасчет
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОбъектПерерасчетаМоментВремени";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		 НоваяСтрока = Объект.СписокЗаписейТребующихПерерасчета.Добавить();
		 
		 ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		 
	КонецЦикла;

КонецПроцедуры


&НаКлиенте
Процедура Обновить_(Команда)

	ЗаполнитьТаблицуСписокЗаписейТребующихПерерасчета();	
	
КонецПроцедуры




#Область Перерасчет

&НаСервере
Процедура ПерерасчитатьНаСервере()

	Если Не ЗначениеЗаполнено(ДокументКПерерасчету) Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект = ДокументКПерерасчету.ПолучитьОбъект();
	
	Для каждого НаборЗаписей Из ДокументОбъект.Движения Цикл
	
		ИмяРегистра = НаборЗаписей.Метаданные().Имя;
		
		НаборЗаписей.Прочитать();
		
		Если ИмяРегистра = "ОсновныеНачисления" Тогда
			
			Расчет.ПереРассчитатьРесурсы_ОсновныеНачисления(НаборЗаписей);
			
		ИначеЕсли ИмяРегистра = "ДополнительныеНачисления" Тогда
			
			Расчет.ПереРассчитатьРесурсы_ДополнительныеНачисления(НаборЗаписей);
			
		ИначеЕсли ИмяРегистра = "Удержания" Тогда
			
			Расчет.ПереРассчитатьРесурсы_Удержания(НаборЗаписей);
		
		КонецЕсли;
	
	КонецЦикла; 
		
	ЗаполнитьТаблицуСписокЗаписейТребующихПерерасчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Перерасчитать(Команда)
	
	ПерерасчитатьНаСервере();
	
КонецПроцедуры

#КонецОбласти 



&НаКлиенте
Процедура СписокЗаписейТребующихПерерасчетаПриАктивизацииСтроки(Элемент)

	ТекДанные = Элементы.СписокЗаписейТребующихПерерасчета.ТекущиеДанные;
	
	Если ТекДанные = Неопределено Тогда
		
		ДокументКПерерасчету = Неопределено;
		
		Возврат;
	
	КонецЕсли;
	
	ДокументКПерерасчету = ТекДанные.ОбъектПерерасчета;
	
КонецПроцедуры



#Область ОчисткаТаблицПерерасчетов

&НаКлиенте
Процедура Очистить_(Команда)
	
	ТеКДанные = Элементы.СписокЗаписейТребующихПерерасчета.ТекущиеДанные;
	
	Если ТеКДанные <> Неопределено Тогда
	
		Очистить_НаСервере(ТеКДанные.ОбъектПерерасчета);
	
	КонецЕсли;
	
	ЗаполнитьТаблицуСписокЗаписейТребующихПерерасчета();	

КонецПроцедуры


&НаСервереБезКонтекста
Процедура Очистить_НаСервере(Ссылка)

	Если Ссылка.Метаданные().Движения.Содержит(Метаданные.РегистрыРасчета.ОсновныеНачисления) Тогда
	
		НаборЗаписей = РегистрыРасчета.ОсновныеНачисления.Перерасчеты.Перерасчет.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОбъектПерерасчета.Установить(Ссылка);
		
		НаборЗаписей.Записать();
	
	КонецЕсли;
	
	Если Ссылка.Метаданные().Движения.Содержит(Метаданные.РегистрыРасчета.ДополнительныеНачисления) Тогда
	
		НаборЗаписей = РегистрыРасчета.ДополнительныеНачисления.Перерасчеты.Перерасчет.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОбъектПерерасчета.Установить(Ссылка);
		
		НаборЗаписей.Записать();
	
	КонецЕсли;
	
	Если Ссылка.Метаданные().Движения.Содержит(Метаданные.РегистрыРасчета.Удержания) Тогда
	
		НаборЗаписей = РегистрыРасчета.Удержания.Перерасчеты.Перерасчет.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОбъектПерерасчета.Установить(Ссылка);
		
		НаборЗаписей.Записать();
	
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти 
