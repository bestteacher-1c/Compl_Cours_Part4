
Процедура Объект_ЗаполнитьТЧ() Экспорт
	
	Начисления.Очистить();
	Удержания.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо,
		|	СотрудникиСрезПоследних.Подразделение КАК Подразделение,
		|	СотрудникиСрезПоследних.Должность КАК Должность,
		|	СотрудникиСрезПоследних.ГрафикРаботы КАК ГрафикРаботы,
		|	&НачалоМесяца КАК Период,
		|	СотрудникиСрезПоследних.Состояние КАК Состояние
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	РегистрСведений.СостояниеСотрудников.СрезПоследних(&НачалоМесяца,) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.Состояние <> &СостояниеУволен
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Сотрудники.ФизическоеЛицо,
		|	Сотрудники.Подразделение,
		|	Сотрудники.Должность,
		|	Сотрудники.ГрафикРаботы,
		|	Сотрудники.Период,
		|	Сотрудники.Состояние
		|ИЗ
		|	РегистрСведений.СостояниеСотрудников КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Период МЕЖДУ &НачалоМесяца И &КонецМесяца
		|	И Сотрудники.Состояние <> &СостояниеБолеет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлановыеНачисленияСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПлановыеНачисленияСрезПоследних.ВидРасчета КАК ВидРасчета,
		|	ПлановыеНачисленияСрезПоследних.Размер КАК Размер,
		|	&НачалоМесяца КАК Период,
		|	ПлановыеНачисленияСрезПоследних.ВидРасчета.ТребуетСбораБазы КАК ТребуетСбораБазы,
		|	ПлановыеНачисленияСрезПоследних.Показатель
		|ПОМЕСТИТЬ ВТПлановыеНачисления
		|ИЗ
		|	РегистрСведений.ПлановыеНачисления.СрезПоследних(&НачалоМесяца,) КАК ПлановыеНачисленияСрезПоследних
		|ГДЕ
		|	ПлановыеНачисленияСрезПоследних.Размер > 0
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПлановыеНачисления.ФизическоеЛицо,
		|	ПлановыеНачисления.ВидРасчета,
		|	ПлановыеНачисления.Размер,
		|	ПлановыеНачисления.Период,
		|	ПлановыеНачисления.ВидРасчета.ТребуетСбораБазы,
		|	ПлановыеНачисления.Показатель
		|ИЗ
		|	РегистрСведений.ПлановыеНачисления КАК ПлановыеНачисления
		|ГДЕ
		|	ПлановыеНачисления.Период МЕЖДУ &НачалоМесяца И &КонецМесяца
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПлановыеУдержанияСрезПоследних.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ПлановыеУдержанияСрезПоследних.ВидРасчета КАК ВидРасчета,
		|	ПлановыеУдержанияСрезПоследних.Размер КАК Размер,
		|	ПлановыеУдержанияСрезПоследних.Показатель КАК Показатель,
		|	&НачалоМесяца КАК Период
		|ПОМЕСТИТЬ ВТПлановыеУдержания
		|ИЗ
		|	РегистрСведений.ПлановыеУдержания.СрезПоследних(&НачалоМесяца,) КАК ПлановыеУдержанияСрезПоследних
		|ГДЕ
		|	ПлановыеУдержанияСрезПоследних.Размер > 0
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПлановыеУдержания.ФизическоеЛицо,
		|	ПлановыеУдержания.ВидРасчета,
		|	ПлановыеУдержания.Размер,
		|	ПлановыеУдержания.Показатель,
		|	ПлановыеУдержания.Период
		|ИЗ
		|	РегистрСведений.ПлановыеУдержания КАК ПлановыеУдержания
		|ГДЕ
		|	ПлановыеУдержания.Период МЕЖДУ &НачалоМесяца И &КонецМесяца
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТПлановыеНачисления.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТСотрудники.Подразделение КАК Подразделение,
		|	ВТСотрудники.Должность КАК Должность,
		|	ВТПлановыеНачисления.ВидРасчета КАК ВидРасчета,
		|	ВТПлановыеНачисления.Размер КАК Размер,
		|	ВТПлановыеНачисления.Период КАК Период,
		|	ВТСотрудники.ГрафикРаботы КАК ГрафикРаботы,
		|	ВТСотрудники.Состояние КАК Состояние,
		|	ВТПлановыеНачисления.ТребуетСбораБазы КАК ТребуетСбораБазы,
		|	ВТПлановыеНачисления.Показатель
		|ИЗ
		|	ВТСотрудники КАК ВТСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПлановыеНачисления КАК ВТПлановыеНачисления
		|		ПО (ВТПлановыеНачисления.ФизическоеЛицо = ВТСотрудники.ФизическоеЛицо)
		|		И (ВТПлановыеНачисления.Период = ВТСотрудники.Период)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ
		|ИТОГИ
		|ПО
		|	ФизическоеЛицо,
		|	ВидРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТПлановыеУдержания.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ВТСотрудники.Подразделение КАК Подразделение,
		|	ВТСотрудники.Должность КАК Должность,
		|	ВТПлановыеУдержания.ВидРасчета КАК ВидРасчета,
		|	ВТПлановыеУдержания.Размер КАК Размер,
		|	ВТПлановыеУдержания.Период КАК Период,
		|	ВТСотрудники.ГрафикРаботы КАК ГрафикРаботы,
		|	ВТСотрудники.Состояние КАК Состояние,
		|	ВТПлановыеУдержания.ВидРасчета.ТребуетСбораБазы КАК ТребуетСбораБазы,
		|	ВТПлановыеУдержания.Показатель КАК Показатель
		|ИЗ
		|	ВТСотрудники КАК ВТСотрудники
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПлановыеУдержания КАК ВТПлановыеУдержания
		|		ПО (ВТПлановыеУдержания.ФизическоеЛицо = ВТСотрудники.ФизическоеЛицо)
		|		И (ВТПлановыеУдержания.Период = ВТСотрудники.Период)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ
		|ИТОГИ
		|ПО
		|	ФизическоеЛицо,
		|	ВидРасчета";
	
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("НачалоМесяца", ПериодРегистрации);
	Запрос.УстановитьПараметр("СостояниеУволен", Перечисления.СостоянияФизическогоЛица.Уволен);
	Запрос.УстановитьПараметр("СостояниеБолеет", Перечисления.СостоянияФизическогоЛица.Болеет);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатЗапроса = МассивРезультатов.Получить(3);
	
	ВыборкаФизическоеЛицо = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаФизическоеЛицо.Следующий() Цикл
		
		ВыборкаВидРасчета = ВыборкаФизическоеЛицо.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
		Пока ВыборкаВидРасчета.Следующий() Цикл
			
			ПериодДействияКонец = КонецМесяца(ПериодРегистрации);
			
			ВыборкаДетальныеЗаписи = ВыборкаВидРасчета.Выбрать();
	
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

				Если ВыборкаДетальныеЗаписи.Размер = 0 Тогда
					
					ПериодДействияКонец = КонецДня(ВыборкаДетальныеЗаписи.Период);
					Продолжить;
					
				КонецЕсли;
					
					НоваяСтрока = Начисления.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
					
					НоваяСтрока.ПериодДействияКонец = ПериодДействияКонец;
					НоваяСтрока.ПериодДействияНачало = ВыборкаДетальныеЗаписи.Период;
					
					Если ВыборкаДетальныеЗаписи.ТребуетСбораБазы Тогда
					
						НоваяСтрока.БазовыйПериодКонец = ПериодДействияКонец;
						НоваяСтрока.БазовыйПериодНачало = ВыборкаДетальныеЗаписи.Период;
					
					КонецЕсли;
					
					ПериодДействияКонец = ВыборкаДетальныеЗаписи.Период - 1;
					
				КонецЦикла;
				
		КонецЦикла;
	КонецЦикла;
	

	//----------------------
	
	РезультатЗапроса = МассивРезультатов.Получить(4);
	
	ВыборкаФизическоеЛицо = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаФизическоеЛицо.Следующий() Цикл
		
		ВыборкаВидРасчета = ВыборкаФизическоеЛицо.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
		Пока ВыборкаВидРасчета.Следующий() Цикл
			
			ПериодДействияКонец = КонецМесяца(ПериодРегистрации);
			
			ВыборкаДетальныеЗаписи = ВыборкаВидРасчета.Выбрать();
	
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

				Если ВыборкаДетальныеЗаписи.Размер = 0 Тогда
					
					ПериодДействияКонец = КонецДня(ВыборкаДетальныеЗаписи.Период);
					Продолжить;
					
				КонецЕсли;
					
					НоваяСтрока = Удержания.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
					
					Если ВыборкаДетальныеЗаписи.ТребуетСбораБазы Тогда
					
						НоваяСтрока.БазовыйПериодКонец = ПериодДействияКонец;
						НоваяСтрока.БазовыйПериодНачало = ВыборкаДетальныеЗаписи.Период;
					
					КонецЕсли;
					
					ПериодДействияКонец = ВыборкаДетальныеЗаписи.Период - 1;
					
				КонецЦикла;
				
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры


Процедура РассчитатьРесурсы() Экспорт 

	

КонецПроцедуры
