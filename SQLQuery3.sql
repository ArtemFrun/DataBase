create database DZ62

use DZ62

create table Curators
(
id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Surname nvarchar(max) not null Check(Surname!='')
)

create table Faculties(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique
)

create table Departmens(
Id int identity not null primary key,
Building int not null check(Building>1 and Building<5),
Finansing money not null check(Finansing>0) default 0,
Name nvarchar(100) not null check(Name!='') unique,
FacultiID int not null references Faculties(Id)
)

create table Groups(
Id int identity not null primary key,
Name nvarchar(10) not null check(Name!='') unique,
Year int not null check(Year>0 And Year<6),
DepartmentId int  not null references Departmens(Id)
)

Create table GroupsCurators(
Id int identity not null primary key,
CuratorId int not null references Curators(Id),
GroupId int not null references Groups(Id)
)

create table Subjects(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique,
)

create table Teachers(
Id int identity not null primary key,
IsProfessor bit not null default 0,
Name nvarchar(max) not null check(Name!=''),
Salary money not null check(Salary>=0),
Surname nvarchar(max) not null check(Surname!='')
)

create table Lectures(
Id int identity not null primary key,
SubjectId int not null references Subjects(Id),
TeacherId int not null references Teachers(Id)
)

Create table GroupsLectures(
Id int identity not null primary key,
GroupId int not null references Groups(Id),
LecturedId int not null references Lectures(Id)
)

create table Students(
Id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Rating int not null check(Rating>0 and Rating<=5),
Surname nvarchar(max) not null check(Surname!='')
)

create table GroupStudents(
Id int identity not null primary key,
GroupId int not null references Groups(Id),
StudentId int not null references Students(Id)
)

--1. Вывести номера корпусов, если суммарный фонд финансирования расположенных в них кафедр превышает 100000.
select Departmens.Building, sum(cast(Departmens.Finansing as decimal)) as Summ from Departmens
group by Departmens.Building
having sum(cast(Departmens.Finansing as decimal)) > 1496159802654852

--2. Вывести названия групп 3-го курса кафедры “Software Development”, которые имеют более 10 пар в первую неделю.
select Groups.Name from Groups
join Departmens on Departmens.Id = Groups.DepartmentId
join GroupsLectures on GroupsLectures.GroupId = Groups.Id
join Lectures on Lectures.Id = GroupsLectures.LecturedId
Where Departmens.Name = '' and 

-Declare @firstdate date --First day at 5years
set @firstdate=(select min(Date) from Groups join GroupsLectures on GroupId=Groups.Id  and Groups.Year=5
				join Lectures on LecturedId=Lectures.Id);
select Groups.Name
from Groups join Departmens on DepartmentId=Departmens.Id and Departmens.Name like '%D%'
	join GroupsLectures on GroupId=Groups.Id 
	join Lectures on LecturedId=Lectures.Id
where Lectures.Date between @firstdate and dateadd(DAY,7,@firstdate)


--3. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) больше, чем рейтинг группы
--“D221”."DOIGIRGW"==>>rating>3

SELECT Groups.Name, sum(Rating) as GroupRating 
from GroupStudents
join Groups on GroupId=Groups.Id
join Students on StudentId=Students.Id
Group by Groups.Name 
having sum(Rating)>(select sum(Rating)
					from GroupStudents
					join Groups on GroupId=Groups.Id
					join Students on StudentId=Students.Id
					where Groups.Name like 'AFCQBP')
-- rating 'AFCQBP'=3
-- how make easer===========================================

--4. Вывести фамилии и имена преподавателей, ставка которых
--выше средней ставки профессоров.

Select Concat(Teachers.Name,' ',Teachers.Surname) as Teacher, Salary
from Teachers where Salary>(select Avg(Cast(Salary as decimal)) from Teachers where IsProfessor=1)
-- avg salary proff=52037876335410

--5. Вывести названия групп, у которых больше одного куратора.

select count(CuratorId) as CountCurators, Groups.Name as GroupName
from GroupsCurators join Groups on GroupId=Groups.Id
group by Groups.Name
having count(CuratorId)>1

--6. Вывести названия групп, имеющих рейтинг 
--(средний рейтинг всех студентов группы) меньше, чем минимальный
--рейтинг групп 5-го курса.
declare @reting5yearsgroup int
set  @reting5yearsgroup=(select top 1 sum(Rating)
					from (GroupStudents join Groups on GroupId=Groups.Id
					join Students on StudentId=Students.Id)
					where Groups.Year=5
					order by SUM(Rating))
SELECT Groups.Name as na, sum(Rating) as ss
from  GroupStudents
join Groups on GroupId=Groups.Id 
join Students on StudentId=Students.Id
Group by Groups.Name  
having sum(Rating)<@reting5yearsgroup
--7. Вывести названия факультетов, суммарный фонд финансирования кафедр которых больше суммарного фонда
--финансирования кафедр факультета “Computer Science”.
select Faculties.Name from Faculties
join Departmens on Departmens.FacultiID = Faculties.Id
group by Faculties.Name
Having sum(Departmens.Finansing) < (select sum(Departmens.Finansing) from Departmens
join Faculties on Departmens.FacultiID = Faculties.Id
Where Faculties.Name = 'F')

--8. Вывести названия дисциплин и полные имена преподавателей, читающих наибольшее количество лекций по ним.
select top 10 Subjects.Name as Subjects, Teachers.Surname + '' + Teachers.Name as Teacher
from Subjects
join Lectures on Lectures.SubjectId = Subjects.Id
join Teachers on Teachers.Id = Lectures.TeacherId
join GroupsLectures on Lectures.Id = GroupsLectures.LecturedId
group by Subjects.Name, Teachers.Surname , Teachers.Name
order by COUNT(LecturedId) desc

--9. Вывести название дисциплины, по которому читается меньше всего лекций.
select top 10 Subjects.Name as Subjects
from Subjects
join Lectures on Lectures.SubjectId = Subjects.Id
join GroupsLectures on Lectures.Id = GroupsLectures.LecturedId
group by Subjects.Name
order by COUNT(LecturedId)

--10. Вывести количество студентов и читаемых дисциплин на кафедре “Software Development”.
select COUNT(StudentId), Subjects.Name as Subjects from GroupStudents
join GroupsLectures on GroupsLectures.GroupId = GroupStudents.GroupId
join Lectures on Lectures.Id = GroupsLectures.LecturedId
join Subjects on Subjects.Id = Lectures.SubjectId
join Groups on GroupStudents.GroupId = Groups.Id
join Departmens on Departmens.Id = Groups.DepartmentId and Departmens.Name like '%G%'
group by Subjects.Name
