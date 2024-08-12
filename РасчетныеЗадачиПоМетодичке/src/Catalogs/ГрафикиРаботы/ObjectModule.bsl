
Процедура ЗаполнитьГрафик(ДатаНачала, ДатаОкончания, НомерПервогоДня) Экспорт
	Сутки = 60 * 60 * 24;
	КалендарнаяДата = НачалоДня(ДатаНачала);
	КонецПериода = НачалоДня(ДатаОкончания);
	Набор = СоздатьНаборЗаписей();
	Периодичность = ДлительностьРабочегоДня.Количество();
	ИндексДня = НомерПервогоДня - 1;
	Пока КалендарнаяДата <= КонецПериода Цикл
		НоваяЗапись = Набор.Добавить();
		НоваяЗапись.Дата = КалендарнаяДата;
		НоваяЗапись.ГрафикРаботы = Ссылка;
		НоваяЗапись.Значение = ДлительностьРабочегоДня[ИндексДня % Периодичность].Длительность;
		ИндексДня = ИндексДня + 1;
		КалендарнаяДата = КалендарнаяДата + Сутки;
	КонецЦикла;
	Набор.Записать();
КонецПроцедуры 

Процедура ОчиститьГрафик() Экспорт
	СоздатьНаборЗаписей().Записать();
КонецПроцедуры

Функция СоздатьНаборЗаписей()
	Набор = РегистрыСведений.ГрафикиРаботы.СоздатьНаборЗаписей();
	Набор.Отбор.ГрафикРаботы.Установить(Ссылка);
	Набор.Очистить();
	Возврат Набор;
КонецФункции