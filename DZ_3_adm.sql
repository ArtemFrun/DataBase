--����: �������� ���������

--������� 1. ��� ���� ������ ����������� ������� ��
--������������� ������� ������ ���������, �������� ��������� � ���������������� ������� �������� ���������
--�������� ���������:
use SportShop

--1. �������� ��������� ���������� ������ ���������� � ���� �������
Create proc FullInfo_Goods
as
select * from Goods

exec FullInfo_Goods
--2. �������� ��������� ���������� ������ ����������
--� ������ ����������� ����. ��� ������ ��������� � �������� ���������. ��������, ���� � �������� ���������
--������� �����, ����� �������� ��� �����, ������� ���� � �������
create proc Info_Goods_by_Kind
@kind nvarchar(max)
as
select * from Goods
Where Kind = @kind

exec Info_Goods_by_Kind 'Kind2'
--3. �������� ��������� ���������� ���-3 ����� ������ ��������. ���-3 ������������ �� ���� �����������
create proc Top3_Clients
as
select top 3 * from Clients
join History on History.ClientId = Clients.Id
order by DateOfSelling desc

exec Top3_Clients
--4. �������� ��������� ���������� ���������� � ����� �������� ��������. ���������� ������������ �� �����
--����� ������ �� �� �����
Create proc Top1_Employee
as
select top 1 * from Employees
join History on History.EmployeeId = Employees.Id
where History.Amount >= (select max(History.Amount) from History)

exec Top1_Employee
--5. �������� ��������� ��������� ���� �� ���� ���� �����
--���������� ������������� � �������. �������� ������������� ��������� � �������� ���������. �� ������ ������
--�������� ��������� ������ ������� yes � ��� ������, ���� ����� ����, � no, ���� ������ ���
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
--6. �������� ��������� ���������� ���������� � ����� ���������� ������������� ����� �����������. ������������
--����� ����������� ������������ �� ����� ����� ������
create proc Top_Manuf_by_Client
as
select Manufacturer from Goods
join History on History.GoodId = Goods.Id
Where History.Amount >= (select max(History.Amount) from History) 

exec Top_Manuf_by_Client
--7. �������� ��������� ������� ���� ��������, ������������������ ����� ��������� ����. ���� ��������� � ��������
--���������. ��������� ���������� ���������� ��������� �������.
create proc Delete_Clients
@date date,
as
delete Clients Where Clients.Id = (select ClientId from History Where DateOfSelling >= @date)
return @@ROWCOUNT
	
declare	@quantity_del int
exec @quantity_del = Delete_Clients 'date'
print @quantity_del
--������� 2. ��� ���� ������ ������������ ���������� ��
--������������� ������� ������ ������� � ��������� � ��������������� � MS SQL Server� �������� ��������� ��������
--���������:
use MusicCollection

--1. �������� ��������� ���������� ������ ���������� � ����������� ������
create proc FullInfo_Discs
as
select * from Discs

exec FullInfo_Discs
--2. �������� ��������� ���������� ������ ���������� � ���� ����������� ������ ����������� ��������. �������� �������� ��������� � �������� ���������
create proc FullInfo_Discs_by_Publisher
@publ nvarchar(max)
as
select * from Discs
join Publishers on Discs.PublisherId = Publishers.Id
Where Publishers.Name = @publ


exec FullInfo_Discs_by_Publisher 'Publisher2'
--3. �������� ��������� ���������� �������� ������ ����������� �����
--4. ������������ ����� ������������ �� ���������� ������ � ���������
create proc Top_Style
as
select Styles.Name from Styles
join Discs on Discs.StyleId = Styles.Id
group by Discs.StyleId, Styles.Name
Having Discs.StyleId >= (select max(Discs.StyleId) from Discs)

exec Top_Style

--5. �������� ��������� ���������� ���������� � ����� ����������� ����� � ���������� ����������� �����. ��������
--����� ��������� � �������� ���������, ���� �������� ����� all, ������ ��� �� ���� ������
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
--6. �������� ��������� ������� ��� ����� ��������� �����.
--�������� ����� ��������� � �������� ���������. ��������� ���������� ���������� ��������� ��������
create proc Delete_Disc_by_Style
@style nvarchar(max)
as
delete Discs Where StyleId = (select Styles.Id from Styles Where Styles.Name ='Style1')
return @@ROWCOUNT

declare	@quantity_del int
exec @quantity_del = Delete_Disc_by_Style 'Style1'
print @quantity_del
--7. �������� ��������� ���������� ���������� � ����� ������� ������ � ����� ��������. �������� � ���������
--������������ �� ���� �������
create proc Young_and_Old_Albom
as
select * from Discs
where ReleaseDate >= (select max(ReleaseDate) from Discs)
or ReleaseDate <= (select min(ReleaseDate) from Discs)

exec Young_and_Old_Albom
--8. �������� ��������� ������� ��� ����� � �������� ������� ���� �������� �����. ����� ��������� � ��������
--���������. ��������� ���������� ���������� ��������� ��������.
create proc Delete_Disc_by_Word
@word nvarchar(max)
as
delete Discs Where Id = (select Discs.Id from Discs Where Discs.Name like @word)
return @@ROWCOUNT

declare	@quantity_del int
exec @quantity_del = Delete_Disc_by_Word 'Word'
print @quantity_del