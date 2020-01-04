--Тема: Хранимые процедуры

--Задание 1. Для базы данных «Спортивный магазин» из
--практического задания модуля «Триггеры, хранимые процедуры и пользовательские функции» создайте следующие
--хранимые процедуры:
use SportShop

--1. Хранимая процедура отображает полную информацию о всех товарах
Create proc FullInfo_Goods
as
select * from Goods

exec FullInfo_Goods
--2. Хранимая процедура показывает полную информацию
--о товаре конкретного вида. Вид товара передаётся в качестве параметра. Например, если в качестве параметра
--указана обувь, нужно показать всю обувь, которая есть в наличии
create proc Info_Goods_by_Kind
@kind nvarchar(max)
as
select * from Goods
Where Kind = @kind

exec Info_Goods_by_Kind 'Kind2'
--3. Хранимая процедура показывает топ-3 самых старых клиентов. Топ-3 определяется по дате регистрации
create proc Top3_Clients
as
select top 3 * from Clients
join History on History.ClientId = Clients.Id
order by DateOfSelling desc

exec Top3_Clients
--4. Хранимая процедура показывает информацию о самом успешном продавце. Успешность определяется по общей
--сумме продаж за всё время
Create proc Top1_Employee
as
select top 1 * from Employees
join History on History.EmployeeId = Employees.Id
where History.Amount >= (select max(History.Amount) from History)

exec Top1_Employee
--5. Хранимая процедура проверяет есть ли хоть один товар
--указанного производителя в наличии. Название производителя передаётся в качестве параметра. По итогам работы
--хранимая процедура должна вернуть yes в том случае, если товар есть, и no, если товара нет
create proc Info_Goods_by_Manuf
@manuf nvarchar(max),
@avail nvarchar(3) output
as
if not exists (select * from Goods Where Manufacturer = @manuf)
set @avail = 'no'
else 
set @avail = 'yes'

declare @avail_man nvarchar(3)
exec Info_Goods_by_Manuf 'Manuf3',@avail_man output
print @avail_man
--6. Хранимая процедура отображает информацию о самом популярном производителе среди покупателей. Популярность
--среди покупателей определяется по общей сумме продаж
create proc Top_Manuf_by_Client
as
select Manufacturer from Goods
join History on History.GoodId = Goods.Id
Where History.Amount >= (select max(History.Amount) from History) 

exec Top_Manuf_by_Client
--7. Хранимая процедура удаляет всех клиентов, зарегистрированных после указанной даты. Дата передаётся в качестве
--параметра. Процедура возвращает количество удаленных записей.
create proc Delete_Clients
@date date,
as
delete Clients Where Clients.Id = (select ClientId from History Where DateOfSelling >= @date)
return @@ROWCOUNT
	
declare	@quantity_del int
exec @quantity_del = Delete_Clients 'date'
print @quantity_del
--Задание 2. Для базы данных «Музыкальная коллекция» из
--практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие хранимые
--процедуры:
use MusicCollection

--1. Хранимая процедура показывает полную информацию о музыкальных дисках
create proc FullInfo_Discs
as
select * from Discs

exec FullInfo_Discs
--2. Хранимая процедура показывает полную информацию о всех музыкальных дисках конкретного издателя. Название издателя передаётся в качестве параметра
create proc FullInfo_Discs_by_Publisher
@publ nvarchar(max)
as
select * from Discs
join Publishers on Discs.PublisherId = Publishers.Id
Where Publishers.Name = @publ


exec FullInfo_Discs_by_Publisher 'Publisher2'
--3. Хранимая процедура показывает название самого популярного стиля
--4. Популярность стиля определяется по количеству дисков в коллекции
create proc Top_Style
as
select Styles.Name from Styles
join Discs on Discs.StyleId = Styles.Id
group by Discs.StyleId, Styles.Name
Having Discs.StyleId >= (select max(Discs.StyleId) from Discs)

exec Top_Style

--5. Хранимая процедура отображает информацию о диске конкретного стиля с наибольшим количеством песен. Название
--стиля передаётся в качестве параметра, если передано слово all, анализ идёт по всем стилям
create proc Info_Disc_and_Song
@style nvarchar(max)
as
if @style != 'all'
	select * from Discs
	join Songs on Songs.DiscId = Discs.Id
	join Styles on Styles.Id = Songs.StyleId
	Where Styles.Name = @style
else
	select * from Discs
	join Songs on Songs.DiscId = Discs.Id
	join Styles on Styles.Id = Songs.StyleId

exec Info_Disc_and_Song 'Style1'
--6. Хранимая процедура удаляет все диски заданного стиля.
--Название стиля передаётся в качестве параметра. Процедура возвращает количество удаленных альбомов
create proc Delete_Disc_by_Style
@style nvarchar(max)
as
delete Discs Where StyleId = (select Styles.Id from Styles Where Styles.Name ='Style1')
return @@ROWCOUNT

declare	@quantity_del int
exec @quantity_del = Delete_Disc_by_Style 'Style1'
print @quantity_del
--7. Хранимая процедура отображает информацию о самом «старом» альбом и самом «молодом». Старость и молодость
--определяются по дате выпуска
create proc Young_and_Old_Albom
as
select * from Discs
where ReleaseDate >= (select max(ReleaseDate) from Discs)
or ReleaseDate <= (select min(ReleaseDate) from Discs)

exec Young_and_Old_Albom
--8. Хранимая процедура удаляет все диски в названии которых есть заданное слово. Слово передаётся в качестве
--параметра. Процедура возвращает количество удаленных альбомов.
create proc Delete_Disc_by_Word
@word nvarchar(max)
as
delete Discs Where Id = (select Discs.Id from Discs Where Discs.Name like @word)
return @@ROWCOUNT

declare	@quantity_del int
exec @quantity_del = Delete_Disc_by_Word 'Word'
print @quantity_del