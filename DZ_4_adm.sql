--����: ���������������� �������

--�������� ���� ��������, ��� ��� ���������� ��� ������, ������, �������� � ������ �������� ���������� �������������� ������������ �� ���������� �������� � �����
--������. ������������ �������� � �������� ���� ������ ��� ���������� ������������ ������.

--������� 1. ��� ���� ������ ����������� ������� ��
--������������� ������� ������ ���������, �������� ��������� � ���������������� ������� �������� ���������
--���������������� �������:
use SportShop

--1. ���������������� ������� ���������� ���������� ���������� �����������
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
--2. ���������������� ������� ���������� ������� ���� ������ ����������� ����. ��� ������ ��������� � ��������
--���������. ��������, ������� ���� �����
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
--3. ���������������� ������� ���������� ������� ���� ������� �� ������ ����, ����� �������������� �������
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
--4. ���������������� ������� ���������� ���������� � ��������� ��������� ������. �������� ����������� ���������� ���������� ������: ���� �������
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
--5. ���������������� ������� ���������� ���������� � ������ ��������� ������. �������� ����������� �������
--���������� ������: ���� �������
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
--6. ���������������� ������� ���������� ���������� � �������� ���� ������� ����������� �������������. ���
--������ � �������� ������������� ���������� � �������� ����������
go
create function fun6(@kind as nvarchar(max), @man as nvarchar(max))
returns table
as
return
(
select * from Goods Where Kind = @kind and Manufacturer = @man
)

select * from dbo.fun6('Kind1', 'Manuf1')
--7. ���������������� ������� ���������� ���������� � �����������, ������� � ���� ���� ���������� 45 ���


--������� 2. ��� ���� ������ ������������ ���������� ��
--������������� ������� ������ ������� � ��������� � ��������������� � MS SQL Server� �������� ��������� ���������������� �������:
use MusicCollection

--1. ���������������� ������� ���������� ��� ����� ��������� ����. ��� ��������� � �������� ���������
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
--2. ���������������� ������� ���������� ���������� � ������ � ���������� ��������� �������, �� �������
--�������������

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
returns table 
as
return
(
select count(Artists.Name) , [Discs Test].Name from [Discs Test], Artists where ArtistId=Artists.Id group by [Discs Test].Name Having COUNT(Artists.Name) > 1
)


select * from dbo.fun2()


--3. ���������������� ������� ���������� ���������� � ���� ������ � ���� �������� ����������� �������� �����. �����
--��������� � �������� ���������
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
--4. ���������������� ������� ���������� ���������� �������� � ������ hard rock � heavy metal
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
--5. ���������������� ������� ���������� ���������� � ������� ������������ ����� ��������� �����������. ��������
--����������� ��������� � �������� ���������
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
--6. ���������������� ������� ���������� ���������� � ����� ������ � ����� �������� �����
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
--7. ���������������� ������� ���������� ���������� �� ������������, ������� ������� ������� � ���� � �����
--������.
go
create function fun7()
returns table
as
return
(
select Artists.Name, Discs.StyleId from Artists
join Discs on Discs.ArtistId = Artists.Id
group by Artists.Name, Discs.StyleId
Having COUNT(Discs.StyleId) >=2
)

select * from dbo.fun7()
