CREATE DATABASE BookShop
GO
USE BookShop

CREATE TABLE Countries(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(50) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE Themes(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE Authors(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  Surname nvarchar(max) NOT NULL CHECK(Surname != ''),
  CountryId int NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Books(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  Pages int NOT NULL CHECK(Pages > 0),
  Price money NOT NULL CHECK(Price !< 0),
  PublishDate date NOT NULL CHECK(PublishDate !> GETDATE()),
  AuthorId int NOT NULL FOREIGN KEY REFERENCES Authors(Id),
  ThemeId int NOT NULL FOREIGN KEY REFERENCES Themes(Id)
)

CREATE TABLE Shops(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  CountryId int NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Sales(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Price money NOT NULL CHECK(Price !< 0),
  Quantity int NOT NULL CHECK(Quantity > 0),
  SaleDate date NOT NULL CHECK(SaleDate !> GETDATE()) DEFAULT GETDATE(),
  BookId int NOT NULL FOREIGN KEY REFERENCES Books(Id),
  ShopId int NOT NULL FOREIGN KEY REFERENCES Shops(Id)
)

--1. Показать все книги, количество страниц в которых больше 500, но меньше 650.
Select * From Books Where Pages > 200000 and Pages < 400000


---2. Показать все книги, в которых первая буква названия либо «А», либо «З».
Select Books.Name, Authors.Surname + ' ' + Authors.Name As Authors From Books 
join Authors on Books.AuthorId = Authors.Id
Where Books.Name like 'A%' or Books.Name like 'Z%'

--3. Показать все книги жанра «Детектив», количество проданных книг более 30 экземпляров.
Select Books.Name as Book, Sales.Quantity as Quantity, Themes.Name as Them from Books
join Themes on Books.ThemeId = Themes.Id
join Sales on Sales.BookId = Books.Id
Where Themes.Name = 'H' and Sales.Quantity > 300000

--4. Показать все книги, в названии которых есть слово «Microsoft», но нет слова «Windows».
Select Books.Name, Authors.Surname + ' ' + Authors.Name As Authors From Books 
join Authors on Books.AuthorId = Authors.Id
Where Books.Name like '%A%' and Books.Name not like '%R%'

--5. Показать все книги (название, тематика, полное имя автора в одной ячейке), цена одной страницы которых меньше 65 копеек.
Select Books.Name, Authors.Surname + ' ' + Authors.Name As Authors, Themes.Name as Them From Books 
join Authors on Books.AuthorId = Authors.Id
join Themes on Books.ThemeId = Themes.Id
Where Price/Pages < 10000000

--6. Показать все книги, название которых состоит из 4 слов 
Select * From Books Where Name like '% % % %'

--7. Показать информацию о продажах в следующем виде:
--▷ Название книги, но, чтобы оно не содержало букву «А».
--▷ Тематика, но, чтобы не «Программирование».
--▷ Автор, но, чтобы не «Герберт Шилдт».
--▷ Цена, но, чтобы в диапазоне от 10 до 20 гривен.
--▷ Количество продаж, но не менее 8 книг.
--▷ Название магазина, который продал книгу, но он не
--должен быть в Украине или России.

select Books.Name as Book, Themes.Name As Them, Authors.Name + ' ' + Authors.Surname as Author, Sales.Price as Price, Sales.Quantity as Quantity, Shops.Name as Shop From Books
join Sales on Sales.BookId = Books.Id and Books.Name not like '%A%' and (Sales.Price > 88103110523942 or Sales.Price < 188103110523942) and Sales.Quantity > 500000
join Themes on Books.ThemeId = Themes.Id and Themes.Name not like '%A%'
join Authors on Authors.Id = Books.AuthorId and Authors.Name + ' ' + Authors.Surname != 'Ken Roberts'
join Shops on Shops.Id = Sales.ShopId
join Countries on Countries.Id = Shops.CountryId and (Countries.Name != 'LVFTWARCWW' or Countries.Name != 'NUBEDITPIWSJAMNIY')

--8. Показать следующую информацию в два столбца (числа
--в правом столбце приведены в качестве примера):
--▷ Количество авторов: 14
--▷ Количество книг: 47
--▷ Средняя цена продажи: 85.43 грн.
--▷ Среднее количество страниц: 650.6.
select 'Количество авторов' as Sumory, COUNT(*) as Value from Authors 
Union
select 'Количество книг', Count(*) from Books
--union
--select 'Средняя цена продажи', avg(Books.Price) from Books
union
select 'Среднее количество страниц' , avg(Books.Pages) from Books


--9. Показать тематики книг и сумму страниц всех книг по каждой из них.
select Themes.Name as Them, Sum(Books.Pages) as [Total Pages] From Books
join Themes on Themes.Id = Books.ThemeId
Group by Themes.Name


--10. Показать количество всех книг и сумму страниц этих книг по каждому из авторов.
select COUNT (*) as Quantity, SUM(Books.Pages) as Pages, Authors.Name + ' ' + Authors.Surname as Author FROM Books
JOIN Authors ON Authors.Id = Books.AuthorId
group by Authors.Name, Authors.Surname

--11. Показать книгу тематики «Программирование» с наибольшим количеством страниц.
select top 1 Books.Name From Books
join Themes on Themes.id = Books.ThemeId
Where Themes.Name like '%A%' order by Books.Pages Desc

--12. Показать среднее количество страниц по каждой тематике, которое не превышает 400.
select avg(Books.Pages) as Pages, Themes.Name as Themes From Books
join Themes on Themes.Id = Books.ThemeId
group by Themes.Name
having avg(Books.Pages) < 400000 

--13. Показать сумму страниц по каждой тематике, учитывая только книги с количеством страниц более 400, и чтобы
--тематики были «Программирование», «Администрирование» и «Дизайн».
select sum(Books.Pages) as Pages, Themes.Name as Themes From Books
join Themes on Themes.Id = Books.ThemeId
where Books.Pages > 900000 and (Themes.Name like '%A%' or Themes.Name like '%R%' or Themes.Name like '%j%')
group by Themes.Name

--14. Показать информацию о работе магазинов: что, где, кем, когда и в каком количестве было продано.
select Books.Name as Books, Countries.Name as Country, Shops.Name as Shops, Sales.SaleDate as Date, Sales.Quantity as Quantity from Sales
join Shops on Sales.ShopId = Shops.Id
join Books on Books.Id = Sales.BookId
join Countries on Shops.CountryId = Countries.Id

--15. Показать самый прибыльный магазин.
Select top 1 Shops.Name, Sum(Cast(Sales.Price as decimal) - Sales.Quantity) as Summ from Shops
join Sales on Sales.ShopId = Shops.Id
group by Shops.Name
order by Sum(Cast(Sales.Price as decimal) - Sales.Quantity) desc