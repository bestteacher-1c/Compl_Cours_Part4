#Область РассчитатьРесурсыПоКоманде

Процедура РассчитатьРесурсы() Экспорт

	НачатьТранзакцию();

	ЗаполнитьНаборЗаписей_Начисления("Расчет");

	Движения.Записать();

	РассчитатьРесурсы_Начисления();

	ПерезаполнитьТабличнуюЧасть_Начисления();

	ОчиститьНаборыЗаписейПослеРасчета();

	ЗафиксироватьТранзакцию();

КонецПроцедуры

Процедура ПерезаполнитьТабличнуюЧасть_Начисления()

	Начисления.Очистить();

	Для Каждого Движение Из Движения.Начисления Цикл

		НоваяСтрока = Начисления.Добавить();

		ЗаполнитьЗначенияСвойств(НоваяСтрока, Движение);

	КонецЦикла;

КонецПроцедуры

Процедура ОчиститьНаборыЗаписейПослеРасчета()

	Движения.Начисления.Очистить();
	;
	Движения.Начисления.Записать();

КонецПроцедуры


#КонецОбласти

Процедура ОбработкаПроведения(Отказ, Режим)

	ЗаполнитьСостояниеСотрудников();
	
	ЗаполнитьНаборЗаписей_Начисления("Запись");

	Движения.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_Начисления(Режим)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Начисления.Показатель
		|ИЗ
		|	ПланВидовРасчета.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.СпособРасчета = &СпособРасчета";
	
	Запрос.УстановитьПараметр("СпособРасчета", Перечисления.СпособыРасчета.ОплатаБольничного);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий(); 

	Показатель = ВыборкаДетальныеЗаписи.Показатель;


	Если Режим = "Расчет" Тогда

		Начисления.Очистить();
		
		Движение = Движения.Начисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.Размер = ПолучитьПроцентВыплатыЧислом(ПроцентВыплаты);
		Движение.Показатель = Показатель;
		Движение.ГрафикРаботы = Справочники.ВидыГрафиковРаботы.КалендарныеДни;

		Движение.ВидРасчета = ВидРасчета;

		Движение.ПериодДействияНачало = ДатаНачала;
		Движение.ПериодДействияКонец = КонецДня(ДатаОкончания);

		Движение.ПериодРегистрации = ПериодРегистрации;

		ПервоеЧислоМесяцаЗаболел = НачалоМесяца(ДатаНачала);

		Движение.БазовыйПериодНачало = ДобавитьМесяц(ПервоеЧислоМесяцаЗаболел, -3);
		Движение.БазовыйПериодКонец = ПервоеЧислоМесяцаЗаболел - 1;

		Движение.ФизическоеЛицо = ФизическоеЛицо;
		Движение.Подразделение = Подразделение;
		Движение.Должность = Должность;

		Движение.Результат = 0;
		Движение.ОтработаноДней = 0;


	ИначеЕсли Режим = "Запись" Тогда

		Для Каждого ТекСтрокаНачисления Из Начисления Цикл

			Движение = Движения.Начисления.Добавить();

			Движение.Сторно = ТекСтрокаНачисления.Сторно;
			Движение.ВидРасчета = ТекСтрокаНачисления.ВидРасчета;
			Движение.Размер = ТекСтрокаНачисления.Размер;
			Движение.Показатель = ТекСтрокаНачисления.Показатель;
			Движение.ГрафикРаботы = ТекСтрокаНачисления.ГрафикРаботы;

			Движение.ПериодДействияНачало = ТекСтрокаНачисления.ПериодДействияНачало;
			Движение.ПериодДействияКонец = ТекСтрокаНачисления.ПериодДействияКонец;

			Движение.ПериодРегистрации = ПериодРегистрации;

			Движение.БазовыйПериодНачало = ТекСтрокаНачисления.БазовыйПериодНачало;
			Движение.БазовыйПериодКонец = ТекСтрокаНачисления.БазовыйПериодКонец;

			Движение.ФизическоеЛицо = ТекСтрокаНачисления.ФизическоеЛицо;
			Движение.Подразделение = ТекСтрокаНачисления.Подразделение;
			Движение.Должность = ТекСтрокаНачисления.Должность;

			Движение.Результат = ТекСтрокаНачисления.Результат;
			Движение.ОтработаноДней = ТекСтрокаНачисления.ОтработаноДней;

		КонецЦикла;

	КонецЕсли;
	
	Движения.Начисления.Записывать = Истина;

КонецПроцедуры

Функция ПолучитьПроцентВыплатыЧислом(ПроцентСсылка) Экспорт

	Соответствие = Новый Соответствие;
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._100, 100);
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._60, 60);
	Соответствие.Вставить(Перечисления.ПроцентыВыплатыБольничного._80, 80);

	Возврат Соответствие.Получить(ПроцентСсылка);
	
КонецФункции // ПолучитьПроцентВыплатыЧислом()

#Область РасчетРесурсов

Процедура РассчитатьРесурсы_Начисления()

	НаборЗаписей = Движения.Начисления;

	Менеджер = Новый МенеджерВременныхТаблиц;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Начисления.НомерСтроки КАК НомерСтроки,
	|	Начисления.ВидРасчета КАК ВидРасчета,
	|	Начисления.ПериодРегистрации КАК ПериодРегистрации,
	|	Начисления.Регистратор КАК Регистратор,
	|	Начисления.ПериодДействия КАК ПериодДействия,
	|	Начисления.ПериодДействияНачало КАК ПериодДействияНачало,
	|	Начисления.ПериодДействияКонец КАК ПериодДействияКонец,
	|	Начисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	Начисления.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	Начисления.Активность КАК Активность,
	|	Начисления.Сторно КАК Сторно,
	|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Начисления.Подразделение КАК Подразделение,
	|	Начисления.Должность КАК Должность,
	|	Начисления.Результат КАК Результат,
	|	Начисления.ОтработаноДней КАК ОтработаноДней,
	|	Начисления.Размер КАК Размер,
	|	Начисления.ГрафикРаботы КАК ГрафикРаботы,
	|	Начисления.Показатель
	|ПОМЕСТИТЬ ВТДвижения
	|ИЗ
	|	РегистрРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТДвижения.ВидРасчета
	|ПОМЕСТИТЬ ВТВидыРасчетаДокумента
	|ИЗ
	|	ВТДвижения КАК ВТДвижения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВидыРасчетаДокумента.ВидРасчета,
	|	НачисленияВедущиеВидыРасчета.ВидРасчета КАК ВедущийВидРасчета
	|ПОМЕСТИТЬ ВТВедущиеВидыРасчета
	|ИЗ
	|	ВТВидыРасчетаДокумента КАК ВТВидыРасчетаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления.ВедущиеВидыРасчета КАК НачисленияВедущиеВидыРасчета
	|		ПО ВТВидыРасчетаДокумента.ВидРасчета = НачисленияВедущиеВидыРасчета.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВедущиеВидыРасчета.ВидРасчета,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТВидыРасчетаДокумента.ВидРасчета) КАК Приоритет
	|ПОМЕСТИТЬ ВТПриоритетыВидовРасчета
	|ИЗ
	|	ВТВедущиеВидыРасчета КАК ВТВедущиеВидыРасчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВидыРасчетаДокумента КАК ВТВидыРасчетаДокумента
	|		ПО ВТВедущиеВидыРасчета.ВедущийВидРасчета = ВТВидыРасчетаДокумента.ВидРасчета
	|СГРУППИРОВАТЬ ПО
	|	ВТВедущиеВидыРасчета.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДвижения.НомерСтроки КАК НомерСтроки,
	|	ВТДвижения.ВидРасчета КАК ВидРасчета,
	|	ВТДвижения.ПериодРегистрации КАК ПериодРегистрации,
	|	ВТДвижения.Регистратор КАК Регистратор,
	|	ВТДвижения.ПериодДействия КАК ПериодДействия,
	|	ВТДвижения.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ВТДвижения.ПериодДействияКонец КАК ПериодДействияКонец,
	|	ВТДвижения.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	ВТДвижения.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	ВТДвижения.Активность КАК Активность,
	|	ВТДвижения.Сторно КАК Сторно,
	|	ВТДвижения.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТДвижения.Подразделение КАК Подразделение,
	|	ВТДвижения.Должность КАК Должность,
	|	ВТДвижения.Результат КАК Результат,
	|	ВТДвижения.ОтработаноДней КАК ОтработаноДней,
	|	ВТДвижения.Размер КАК Размер,
	|	ВТДвижения.ГрафикРаботы КАК ГрафикРаботы,
	|	ВТПриоритетыВидовРасчета.Приоритет КАК Приоритет,
	|	ВТДвижения.Показатель
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
	|	ВТДвиженияСПриоритетом.Приоритет КАК Приоритет,
	|	ВТДвиженияСПриоритетом.ВидРасчета.СпособРасчета КАК СпособРасчета,
	|	ВТДвиженияСПриоритетом.ВидРасчета.Формула КАК Формула,
	|	ВТДвиженияСПриоритетом.Показатель,
	|	ВТДвиженияСПриоритетом.Размер,
	|	ВТДвиженияСПриоритетом.ВидРасчета.ЗачетОтработанногоВремени КАК ЗачетОтработанногоВремени,
	|	ВТДвиженияСПриоритетом.Показатель.Идентификатор КАК Идентификатор
	|ИЗ
	|	ВТДвиженияСПриоритетом КАК ВТДвиженияСПриоритетом
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	НомерСтроки
	|ИТОГИ
	|ПО
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
	
	//Внешний цикл по Приоритету
	Пока ВыборкаПриоритет.Следующий() Цикл
		
		//Вложенный цикл по записям текущей категории
		ВыборкаДетальныеЗаписи = ВыборкаПриоритет.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Запись = НаборЗаписей.Получить(ВыборкаДетальныеЗаписи.НомерСтроки - 1);

			Если ВыборкаДетальныеЗаписи.СпособРасчета = Перечисления.СпособыРасчета.ОплатаБольничного Тогда
				
				НормаДней = 20;
				
				ФактДней = 7; //Дней Болел(а)
				
				ОтработаноДнейБаза = 60; //Отработал(а) за три месяца
				
				РезультатБаза = 300000; //Заработал(а) за три месяца
				
				Если ОтработаноДнейБаза = 0 Тогда
				
				//У нас социальное государство. Ст. 7 Конституции РФ.
				//Вы не работали до заболевания и нет базы для расчета среднего заработка.
				//Значит больничный платиться из расчтета по МРОТ (для примера взят МРОТ на 01.01.2024 г.)

					Запись.Результат = 19242 / 30 * ФактДней; 
				
				//Кстати. Ст. 29 Каждому гарантируется свобода мысли и слова.
				
				//Ст. 31. Граждане Российской Федерации имеют право собираться мирно,
				//без оружия, проводить собрания, митинги и демонстрации, шествия и пикетирование.

					Продолжить;
				КонецЕсли;			
					
				ПроцентВыплатаПоБЛ = ВыборкаДетальныеЗаписи.Размер;
					
				
				Выполнить("Запись.Результат = " + ВыборкаДетальныеЗаписи.Формула);
				
			КонецЕсли;

		КонецЦикла;
		
		НаборЗаписей.Записать( , Истина);

	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьСостояниеСотрудников()
	
	Движения.СостояниеСотрудников.Записывать = Истина;
	
	Движение = Движения.СостояниеСотрудников.Добавить();
	Движение.Период = ДатаНачала;
	Движение.ФизическоеЛицо = ФизическоеЛицо;
	Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Болеет;
	Движение.ГрафикРаботы = ГрафикРаботы;
	Движение.Должность = Должность;
	Движение.Подразделение = Подразделение;
	Движение.Комментарий = "Начало периода болезни";
	
	Движение = Движения.СостояниеСотрудников.Добавить();
	Движение.Период = ДатаОкончания;
	Движение.ФизическоеЛицо = ФизическоеЛицо;
	Движение.Состояние = Перечисления.СостоянияФизическогоЛица.Работает;
	Движение.ГрафикРаботы = ГрафикРаботы;
	Движение.Должность = Должность;
	Движение.Подразделение = Подразделение;
	Движение.Комментарий = "Окончание периода болезни";
	
КонецПроцедуры