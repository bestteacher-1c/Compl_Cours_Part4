
Процедура ОбработкаПроведения(Отказ, Режим)

    ЗаполнитьНаборЗаписей_ДополнительныеНачисления("Проведение");
	
	Движения.Записать();
	

	Расчет.ЗаполнитьНаборЗаписей_ВзаиморасчетыСРаботниками(Движения.ВзаиморасчетыСРаботниками);

КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_ДополнительныеНачисления(КакИспользуем)

	Если КакИспользуем = "Расчет" Тогда

		Движение = Движения.ДополнительныеНачисления.Добавить();

		Движение.Сторно = Ложь;

		Движение.ВидРасчета = ПланыВидовРасчета.ДополнительныеНачисления.ПремияРуководителю;

		Движение.ПериодРегистрации = ПериодРегистрации;

		Движение.БазовыйПериодНачало = ДобавитьМесяц(ПериодРегистрации, -1);
		Движение.БазовыйПериодКонец = ПериодРегистрации - 1;

		Движение.ФизическоеЛицо = ФизическоеЛицо;
		Движение.Подразделение = Подразделение;
		Движение.Должность = Должность;

		Движение.Результат = 0;

		Движение.Размер = РазмерПремии;
	
	ИначеЕсли КакИспользуем = "Проведение" Тогда
		
		Для Каждого ТекСтрокаДополнительныеНачисления Из ДополнительныеНачисления Цикл

			Движение = Движения.ДополнительныеНачисления.Добавить();

			Движение.Сторно = ТекСтрокаДополнительныеНачисления.Сторно;
			Движение.ВидРасчета = ТекСтрокаДополнительныеНачисления.ВидРасчета;

			Движение.ПериодРегистрации = ПериодРегистрации;
			Движение.БазовыйПериодНачало = ТекСтрокаДополнительныеНачисления.БазовыйПериодНачало;
			Движение.БазовыйПериодКонец = ТекСтрокаДополнительныеНачисления.БазовыйПериодКонец;
			Движение.ФизическоеЛицо = ТекСтрокаДополнительныеНачисления.ФизическоеЛицо;
			Движение.Подразделение = ТекСтрокаДополнительныеНачисления.Подразделение;
			Движение.Должность = ТекСтрокаДополнительныеНачисления.Должность;

			Движение.Результат = ТекСтрокаДополнительныеНачисления.Результат;

			Движение.Размер = ТекСтрокаДополнительныеНачисления.Размер;

		КонецЦикла;
		
	КонецЕсли;
	
	Движения.ДополнительныеНачисления.Записывать = Истина;
	
КонецПроцедуры

#Область РассчитатьРесурсыПоКоманде

Процедура РассчитатьРесурсы() Экспорт 

	НачатьТранзакцию();
	
	ЗаполнитьНаборЗаписей_ДополнительныеНачисления("Расчет");
	
	Движения.Записать();
	
	РассчитатьРесурсы_ДополнительныеНачисления();
	
	ПерезаполнитьТабличнуюЧасть_ДополнительныеНачисления();
	
	ОчиститьНаборыЗаписейПослеРасчета();
	
	ЗафиксироватьТранзакцию();

КонецПроцедуры

Процедура РассчитатьРесурсы_ДополнительныеНачисления()
	
	НаборЗаписей = Движения.ДополнительныеНачисления;
	
	//Получаем упорядоченные по категориям данные текущего набора записей, записанные в БД
	Менеджер = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДополнительныеНачисления.НомерСтроки КАК НомерСтроки,
	|	ДополнительныеНачисления.ВидРасчета КАК ВидРасчета,
	|	ДополнительныеНачисления.ПериодРегистрации КАК ПериодРегистрации,
	|	ДополнительныеНачисления.Регистратор КАК Регистратор,
	|	ДополнительныеНачисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	ДополнительныеНачисления.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	ДополнительныеНачисления.Активность КАК Активность,
	|	ДополнительныеНачисления.Сторно КАК Сторно,
	|	ДополнительныеНачисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ДополнительныеНачисления.Подразделение КАК Подразделение,
	|	ДополнительныеНачисления.Должность КАК Должность,
	|	ДополнительныеНачисления.Результат КАК Результат,
	|	ДополнительныеНачисления.Размер КАК Размер
	|ПОМЕСТИТЬ ВТДвижения
	|ИЗ
	|	РегистрРасчета.ДополнительныеНачисления КАК ДополнительныеНачисления
	|ГДЕ
	|	ДополнительныеНачисления.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДополнительныеНачисления.ВидРасчета КАК ВидРасчета
	|ПОМЕСТИТЬ ВТВидыРасчетаДокумента
	|ИЗ
	|	ВТДвижения КАК ДополнительныеНачисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВидыРасчетаДокумента.ВидРасчета КАК ВидРасчета,
	|	ДополнительныеНачисленияВедущиеВидыРасчета.ВидРасчета КАК ВедущийВидРасчета
	|ПОМЕСТИТЬ ВТВедущиеВидыРасчета
	|ИЗ
	|	ВТВидыРасчетаДокумента КАК ВТВидыРасчетаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ДополнительныеНачисления.ВедущиеВидыРасчета КАК ДополнительныеНачисленияВедущиеВидыРасчета
	|		ПО ВТВидыРасчетаДокумента.ВидРасчета = ДополнительныеНачисленияВедущиеВидыРасчета.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВедущиеВидыРасчета.ВидРасчета КАК ВидРасчета,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТВидыРасчетаДокумента.ВидРасчета) КАК Приоритет
	|ПОМЕСТИТЬ ВТПриоритетыВидовРасчета
	|ИЗ
	|	ВТВедущиеВидыРасчета КАК ВТВедущиеВидыРасчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВидыРасчетаДокумента КАК ВТВидыРасчетаДокумента
	|		ПО ВТВедущиеВидыРасчета.ВедущийВидРасчета = ВТВидыРасчетаДокумента.ВидРасчета
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТВедущиеВидыРасчета.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТПриоритетыВидовРасчета.Приоритет КАК Приоритет,
	|	ВТДвижения.НомерСтроки КАК НомерСтроки,
	|	ВТДвижения.ВидРасчета КАК ВидРасчета,
	|	ВТДвижения.ПериодРегистрации КАК ПериодРегистрации,
	|	ВТДвижения.Регистратор КАК Регистратор,
	|	ВТДвижения.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	ВТДвижения.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	ВТДвижения.Активность КАК Активность,
	|	ВТДвижения.Сторно КАК Сторно,
	|	ВТДвижения.ФизическоеЛицо,
	|	ВТДвижения.Подразделение КАК Подразделение,
	|	ВТДвижения.Должность КАК Должность,
	|	ВТДвижения.Результат КАК Результат,
	|	ВТДвижения.Размер КАК Размер
	|ПОМЕСТИТЬ ВТДвиженияСПриоритетом
	|ИЗ
	|	ВТДвижения КАК ВТДвижения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПриоритетыВидовРасчета КАК ВТПриоритетыВидовРасчета
	|		ПО ВТДвижения.ВидРасчета = ВТПриоритетыВидовРасчета.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДвиженияСПриоритетом.НомерСтроки КАК НомерСтроки,
	|	ВТДвиженияСПриоритетом.ВидРасчета КАК ВидРасчета,
	|	ВТДвиженияСПриоритетом.ВидРасчета.СпособРасчета КАК СпособРасчета,
	|	ВТДвиженияСПриоритетом.Приоритет КАК Приоритет
	|ИЗ
	|	ВТДвиженияСПриоритетом КАК ВТДвиженияСПриоритетом
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Приоритет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДвижения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВидыРасчетаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВедущиеВидыРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТПриоритетыВидовРасчета";
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПриоритет = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	//Внешний цикл по категориям
	Пока ВыборкаПриоритет.Следующий() Цикл
	
//		Запрос = Новый Запрос;
//		Запрос.МенеджерВременныхТаблиц = Менеджер;
//		Запрос.Текст = 
//		"";
//
//		
//		ИзмеренияДляБазы = Новый СписокЗначений;
//		ИзмеренияДляБазы.Добавить("Подразделение");
//	
//		ПоляДляРазрезов = Новый СписокЗначений;
//		ПоляДляРазрезов.Добавить("ФизическоеЛицо");	
//
//		Запрос.УстановитьПараметр("ИзмеренияДляБазы", ИзмеренияДляБазы);
//		Запрос.УстановитьПараметр("ПоляДляРазрезов", ПоляДляРазрезов);
//		Запрос.УстановитьПараметр("Регистратор", Ссылка);
//		Запрос.УстановитьПараметр("Приоритет", ВыборкаПриоритет.Приоритет);
//	
//		РезультатЗапроса = Запрос.Выполнить();
//		
//		//Выборка с данными для записей текущей категории
//		Выборка_ДанныеГрафика_База = РезультатЗапроса.Выбрать();
//		
//		
		//Вложенный цикл по записям текущей категории
		ВыборкаДетальныеЗаписи = ВыборкаПриоритет.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл	
			
			Запись = НаборЗаписей.Получить(ВыборкаДетальныеЗаписи.НомерСтроки - 1);
			
//			Выборка_ДанныеГрафика_База.НайтиСледующий(ВыборкаДетальныеЗаписи.НомерСтроки, "НомерСтроки");
			
			Если ВыборкаДетальныеЗаписи.СпособРасчета = Перечисления.СпособыРасчета.Процентом Тогда
				
				База = 9999;

				ПроцентВыплаты = Запись.Размер;

				Запись.Результат = База * ПроцентВыплаты / 100;
				
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписей.Записать(,Истина);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПерезаполнитьТабличнуюЧасть_ДополнительныеНачисления() 
	
	ДополнительныеНачисления.Очистить();
	
	Для каждого Движение Из Движения.ДополнительныеНачисления Цикл
	
		НоваяСтрока = ДополнительныеНачисления.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Движение);
	
	КонецЦикла;

КонецПроцедуры

Процедура ОчиститьНаборыЗаписейПослеРасчета()

	Движения.ДополнительныеНачисления.Очистить();;
	Движения.ДополнительныеНачисления.Записать();
	
КонецПроцедуры

#КонецОбласти
