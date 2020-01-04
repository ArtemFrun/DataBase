--Тема: Триггеры


--Задание 1. К базе данных «Спортивный магазин» из практического задания к этому модулю создайте следующие триггеры:
use SportShop

--1. При добавлении нового товара триггер проверяет его наличие на складе, если такой товар есть и новые данные о
--товаре совпадают с уже существующими данными, вместо добавления происходит обновление информации о количестве товара
if OBJECT_ID('TR_Goods_ADD', 'TR') is not null
begin
  drop trigger TR_Goods_ADD;
end;
go

create trigger TR_Goods_ADD
on [Goods] 
instead of insert
as
if not exists (select * from Goods join inserted on Goods.Name = inserted.Name
	and Goods.Manufacturer = inserted.Manufacturer and Goods.Kind = inserted.Kind)
	INSERT into [Goods]([Name], [Amount], [CostPrice], [Kind], [Manufacturer], [SellPrice])
select [Name], [Amount], [CostPrice], [Kind], [Manufacturer], [SellPrice] from inserted
else
	UPDATE Goods
	set Amount = Goods.Amount + inserted.Amount
	from Goods 
	join inserted on Goods.Name = inserted.Name

INSERT into [Goods]([Name], [Amount], [CostPrice], [Kind], [Manufacturer], [SellPrice]) values
(N'Good1', 15, 65, N'Kind1', N'Manuf1', 73)



--2. При увольнении сотрудника триггер переносит информацию об уволенном сотруднике в таблицу «Архив сотрудников»
Create table [Archive Employees]
(
[Id] int not null identity(1, 1) primary key,
 [Name] nvarchar(100) not null unique check ([Name] <> N''),
 [DateOfReceipt] date not null,
 [Gender] nvarchar(100) not null,
)

if OBJECT_ID('TR_Employees_Archive', 'TR') is not null
begin
  drop trigger TR_Employees_Archive;
end;
go

create trigger TR_Employees_Archive
on [Employees]
instead of delete
as
INSERT into [Archive Employees]([Name], [DateOfReceipt], [Gender]) 
select [Name], [DateOfReceipt], [Gender] from deleted
Delete [Employees] where Employees.id = (select id from deleted)


Delete Employees where Name = 'Employee1'
--3. Триггер запрещает добавлять нового продавца, если количество существующих продавцов больше 6.

if OBJECT_ID('TR_Employees_ADD', 'TR') is not null
begin
  drop trigger TR_Employees_ADD;
end;
go

create trigger TR_Employees_ADD
on [Employees]
instead of insert
as
if (select COUNT(Employees.Id) from Employees) >= 6
	print 'Max Employees'
else
	INSERT into [Employees]([Name], [DateOfReceipt], [Gender])
	select [Name], [DateOfReceipt], [Gender] from inserted

INSERT into [Employees]([Name], [DateOfReceipt], [Gender]) values
(N'Employee7', '2005-12-1', N'Male')


--Задание 2. К базе данных «Музыкальная коллекция» из
--практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие триггеры:
use MusicCollection


--1. Триггер не позволяющий добавить уже существующий в коллекции альбом
if OBJECT_ID('TR_Discs_ADD', 'TR') is not null
begin
  drop trigger TR_Discs_ADD;
end;
go

create trigger TR_Discs_ADD
on [Discs]
instead of insert
as
if not exists (select * from Discs join inserted on Discs.Name = inserted.Name)
	insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate])
	select [Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate] from inserted
else
	print 'Exist'

insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate]) values
(N'DiscA1S1', 1, 1, N'Review1', 1, SYSDATETIME())

--2. Триггер не позволяющий удалять диски группы The Beatles
if OBJECT_ID('TR_Discs_Delete', 'TR') is not null
begin
  drop trigger TR_Discs_Delete;
end;
go

create trigger TR_Discs_Delete
on [Discs]
instead of delete
as
if (select Name from deleted) = 'Beatles'
	print 'Not delete'
else
	Delete from [Discs] where Discs.Id = (select id from deleted)

Delete Discs Where Name = 'DiscA1S2'

--3. При удалении диска триггер переносит информацию об удаленном диске в таблицу «Архив»
Create table [Archive Discs]
(
 [Id] int not null identity(1, 1) primary key,
 [Name] nvarchar(100) not null unique check ([Name] <> N''),
 [ArtistId] int not null,
 [StyleId] int not null,
 [PublisherId] int not null,
 [ReleaseDate] date not null,
)

if OBJECT_ID('TR_Discs_Archive', 'TR') is not null
begin
  drop trigger TR_Discs_Archive;
end;
go

create trigger TR_Discs_Archive
on [Discs]
instead of delete
as
INSERT into [Archive Discs]([Name], [ArtistId], [StyleId], [PublisherId], [ReleaseDate]) 
select [Name], [ArtistId], [StyleId], [PublisherId], [ReleaseDate] from deleted
Delete [Discs] where Discs.id = (select id from deleted)


--4. Триггер не позволяющий добавлять в коллекцию диски музыкального стиля «Dark Power Pop».
if OBJECT_ID('TR_Discs_ADD', 'TR') is not null
begin
  drop trigger TR_Discs_ADD;
end;
go

create trigger TR_Discs_ADD
on [Discs]
instead of insert
as
if (select StyleId from inserted) = (select id from Styles Where Name = 'Dark Power Pop')
	print 'Not Insert'

--Задание 3. К базе данных «Продажи» из практического задания модуля «Работа с таблицами и представлениями в
--MS SQL Server» создайте следующие триггеры:


--1. При добавлении нового покупателя триггер проверяет наличие покупателей с такой же фамилией. При нахождении совпадения триггер записывает об этом информацию
--в специальную таблицу
--2. При удалении информации о покупателе триггер переносит его историю покупок в таблицу «История покупок»
--3. При добавлении продавца триггер проверяет есть ли он в таблице покупателей, если запись существует добавление
--нового продавца отменяется
--4. При добавлении покупателя триггер проверяет есть ли он в таблице продавцов, если запись существует добавление
--нового покупателя отменяется
--5. Триггер не позволяет вставлять информацию о продаже таких товаров: яблоки, груши, сливы, кинза.
