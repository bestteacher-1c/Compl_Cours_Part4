Процедура ОбработкаПроведения(Отказ, Режим)

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