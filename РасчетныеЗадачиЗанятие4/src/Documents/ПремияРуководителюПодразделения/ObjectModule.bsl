
Процедура ОбработкаПроведения(Отказ, Режим)

	ЗаполнитьНаборЗаписей_Начисления();
	
	Движения.Начисления.Записывать = Истина;
	Движения.Записать();
	
	РассчитатьРесурсы_Начисления();

КонецПроцедуры

Процедура ЗаполнитьНаборЗаписей_Начисления()
    
    Движение = Движения.Начисления.Добавить();
	
	Движение.Сторно = Ложь;
    Движение.ВидРасчета = ВидРасчета;
    
    Движение.ПериодРегистрации = ПериодРегистрации;
    
    Движение.БазовыйПериодНачало = ДобавитьМесяц(ПериодРегистрации,-1);
    Движение.БазовыйПериодКонец = ПериодРегистрации -1;
    
    Движение.ФизическоеЛицо = ФизическоеЛицо;
    Движение.Подразделение = Подразделение;
    Движение.Должность = Должность;
    Движение.Результат = 0;
    Движение.Размер = РазмерПремии;
   	Движение.Показатель = ВидРасчета.Показатель;
    
КонецПроцедуры

Процедура РассчитатьРесурсы_Начисления()
	
	НаборЗаписей = Движения.ОсновныеНачисления;

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
	|	ВТДвиженияСПриоритетом.ВидРасчета.ЗачетОтработанногоВремени КАК ЗачетОтработанногоВремени
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
			
			Если ВыборкаДетальныеЗаписи.СпособРасчета = Перечисления.СпособыРасчета.Процентом Тогда
				
				РезультатБаза = 9999;

				Процент = Запись.Размер;

				Запись.Результат = РезультатБаза * Процент / 100;
				
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписей.Записать(,Истина);
		
	КонецЦикла;
	
	

КонецПроцедуры
