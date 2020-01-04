--����: ��������


--������� 1. � ���� ������ ����������� ������� �� ������������� ������� � ����� ������ �������� ��������� ��������:
use SportShop

--1. ��� ���������� ������ ������ ������� ��������� ��� ������� �� ������, ���� ����� ����� ���� � ����� ������ �
--������ ��������� � ��� ������������� �������, ������ ���������� ���������� ���������� ���������� � ���������� ������
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



--2. ��� ���������� ���������� ������� ��������� ���������� �� ��������� ���������� � ������� ������ �����������
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
--3. ������� ��������� ��������� ������ ��������, ���� ���������� ������������ ��������� ������ 6.

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


--������� 2. � ���� ������ ������������ ���������� ��
--������������� ������� ������ ������� � ��������� � ��������������� � MS SQL Server� �������� ��������� ��������:
use MusicCollection


--1. ������� �� ����������� �������� ��� ������������ � ��������� ������
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

--2. ������� �� ����������� ������� ����� ������ The Beatles
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

--3. ��� �������� ����� ������� ��������� ���������� �� ��������� ����� � ������� ������
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


--4. ������� �� ����������� ��������� � ��������� ����� ������������ ����� �Dark Power Pop�.
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

--������� 3. � ���� ������ �������� �� ������������� ������� ������ ������� � ��������� � ��������������� �
--MS SQL Server� �������� ��������� ��������:


--1. ��� ���������� ������ ���������� ������� ��������� ������� ����������� � ����� �� ��������. ��� ���������� ���������� ������� ���������� �� ���� ����������
--� ����������� �������
--2. ��� �������� ���������� � ���������� ������� ��������� ��� ������� ������� � ������� �������� �������
--3. ��� ���������� �������� ������� ��������� ���� �� �� � ������� �����������, ���� ������ ���������� ����������
--������ �������� ����������
--4. ��� ���������� ���������� ������� ��������� ���� �� �� � ������� ���������, ���� ������ ���������� ����������
--������ ���������� ����������
--5. ������� �� ��������� ��������� ���������� � ������� ����� �������: ������, �����, �����, �����.