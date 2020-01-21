--Тема: Пользовательские функции

--Обращаем ваше внимание, что при именовании баз данных, таблиц, столбцов и других объектов необходимо придерживаться рекомендаций по именованию объектов в базах
--данных. Наименования объектов в заданиях даны только для объяснения поставленной задачи.

--Задание 1. Для базы данных «Спортивный магазин» из
--практического задания модуля «Триггеры, хранимые процедуры и пользовательские функции» создайте следующие
--пользовательские функции:
use SportShop

--1. Пользовательская функция возвращает количество уникальных покупателей
go
create function fun1()
returns table
as
return
(
select COUNT(DISTINCT Clients.Name) as [Count Clients] from Clients
group by Clients.Name
)

select * from dbo.fun1()
--2. Пользовательская функция возвращает среднюю цену товара конкретного вида. Вид товара передаётся в качестве
--параметра. Например, среднюю цену обуви
go
create function fun2(@good as nvarchar(max))
returns int
as
begin
return
(
select avg(Amount) from Goods Where Kind = @good
)
end

print dbo.fun2('Kind2')
--3. Пользовательская функция возвращает среднюю цену продажи по каждой дате, когда осуществлялись продажи
go
create function fun3()
returns table
as
return
(
select DateOfSelling as DateOfSell,avg(SellPrice) as Price from Sells
group by DateOfSelling
)

select * from dbo.fun3()
--4. Пользовательская функция возвращает информацию о последнем проданном товаре. Критерий определения последнего проданного товара: дата продажи
go
create function fun4()
returns table
as
return
(
select * from Sells
Where DateOfSelling >= (select max(DateOfSelling) from Sells)
)

select * from dbo.fun4()
--5. Пользовательская функция возвращает информацию о первом проданном товаре. Критерий определения первого
--проданного товара: дата продажи
go
create function fun5()
returns table
as
return
(
select * from Sells
Where DateOfSelling <= (select min(DateOfSelling) from Sells)
)

select * from dbo.fun5()
--6. Пользовательская функция возвращает информацию о заданном виде товаров конкретного производителя. Вид
--товара и название производителя передаются в качестве параметров
go
create function fun6(@kind as nvarchar(max), @man as nvarchar(max))
returns table
as
return
(
select * from Goods Where Kind = @kind and Manufacturer = @man
)

select * from dbo.fun6('Kind1', 'Manuf1')
--7. Пользовательская функция возвращает информацию о покупателях, которым в этом году исполнится 45 лет


--Задание 2. Для базы данных «Музыкальная коллекция» из
--практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие пользовательские функции:
use MusicCollection

--1. Пользовательская функция возвращает все диски заданного года. Год передаётся в качестве параметра
go
create function fun1(@date_val as int)
returns table
as
return
(
select * from Discs
where datepart(YEAR, ReleaseDate) = @date_val
)

select * from dbo.fun1(2019)
--2. Пользовательская функция возвращает информацию о дисках с одинаковым названием альбома, но разными
--исполнителями

create table [Discs Test]
(
  [Id] int not null identity(1, 1) primary key,
  [Name] nvarchar(100) not null check ([Name] <> N''),
  [ArtistId] int not null,
  [StyleId] int not null,
  [PublisherId] int not null,
  [ReleaseDate] date not null,
)

insert into [Discs Test]([Name], [ArtistId], [StyleId], [PublisherId], [ReleaseDate]) values
(N'DiscA1S1', 1, 1, 1, SYSDATETIME()),
(N'DiscA1S2', 1, 2, 1, SYSDATETIME()),
(N'DiscA1S3', 1, 3, 1, SYSDATETIME()),
(N'DiscA2S1', 2, 1, 2, SYSDATETIME()),
(N'DiscA1S1', 2, 2, 2, SYSDATETIME()),
(N'DiscA2S3', 2, 3, 2, SYSDATETIME()),
(N'DiscA3S1', 3, 1, 3, SYSDATETIME()),
(N'DiscA3S2', 3, 2, 3, SYSDATETIME()),
(N'DiscA1S1', 3, 3, 3, SYSDATETIME()),
(N'DiscA1S4', 1, 3, 3, SYSDATETIME())



go
create function fun2()
returns @DInfo table(
Discs nvarchar(max) not null,
Artist nvarchar(max) not null,
CountArtist int not null,
ReleaseDate date not null,
Review nvarchar(max) not null
)
as
begin

declare @tmptable table(
CountArtist int not null, 
DiscName nvarchar(max) not null
)

insert into @tmptable (CountArtist, DiscName)
select count(Artists.Name) , [Discs Test].Name from [Discs Test], Artists where ArtistId=Artists.Id group by [Discs Test].Name

insert into @DInfo (Discs, Artist, CountArtist, ReleaseDate)
select [Discs Test].Name as Disc, Artists.Name as Artist, CountArtist, ReleaseDate from [Discs Test], Artists, @tmptable where ArtistId=Artists.Id
		and [Discs Test].Name=DiscName and CountArtist>1 order by Disc

return
end;

select * from fun2()
--3. Пользовательская функция возвращает информацию о всех песнях в чьем названии встречается заданное слово. Слово
--передаётся в качестве параметра
go
create function fun3(@word as nvarchar(max))
returns table
as
return
(
select * from Songs
where Name like '%'+@word+'%'
)

select * from dbo.fun3('Song1')
--4. Пользовательская функция возвращает количество альбомов в стилях hard rock и heavy metal
go
create function fun4()
returns int
as
begin
return
(
select COUNT(Discs.Id) from Discs
join Styles on Discs.StyleId = Styles.Id 
and Styles.Name = 'Style1' or Styles.Name = 'Style2' 
)
end

print dbo.fun4()
--5. Пользовательская функция возвращает информацию о средней длительности песни заданного исполнителя. Название
--исполнителя передаётся в качестве параметра
go
create function fun5(@artist as nvarchar(max))
returns int
as
begin
return
(
select avg(Duration) from Songs
join Artists on Artists.Id = Songs.ArtistId
and Artists.Name = @artist
)
end

print dbo.fun5('Artist11')
--6. Пользовательская функция возвращает информацию о самой долгой и самой короткой песне
go
create function fun6()
returns table
as
return
(
select * from Songs
where Songs.Duration >= (select max(Duration) from Songs)
or Songs.Duration <= (select min(Duration) from Songs)
)

select * from dbo.fun6()
--7. Пользовательская функция возвращает информацию об исполнителях, которые создали альбомы в двух и более
--стилях.
go
create function fun7()
returns @AInfo table(
Discs nvarchar(max) not null,
Artist nvarchar(max) not null,
CountStyle int not null
)
as
begin

declare @tmptable table(
CountStyle int not null, 
Artist nvarchar(max) not null
)

insert into @tmptable (CountStyle, Artist)
select count(Styles.Name) , Artists.Name from Discs, Artists,Styles 
	where ArtistId=Artists.Id and StyleId=Styles.Id group by Artists.Name

insert into @AInfo (Discs, Artist, CountStyle)
select Discs.Name as Disc, Artists.Name as Artist, CountStyle from Discs, Artists, @tmptable 
		where Discs.ArtistId=Artists.Id and Artist=Artists.Name and CountStyle>1 order by Disc

return
end;

select * from fun7()