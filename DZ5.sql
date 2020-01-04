create database DZ5

use DZ5

-- create table
--======================================================================
create table Faculties(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique
)


create table Departments(
Id int identity not null primary key,
Finansing money not null check(Finansing>0) default 0,
Name nvarchar(100) not null check(Name!='') unique,
FacultiID int not null references Faculties(Id)
)

create table Groups(
Id int identity not null primary key,
Name nvarchar(10) not null check(Name!='') unique,
Year int not null check(Year>0 And Year<6),
DepartmentId int  not null references Departments(Id)
)

create table Subjects(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique,
)

create table Teachers(
Id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Salary money not null check(Salary>=0),
Surname nvarchar(max) not null check(Surname!='')
)


create table Lectures(
Id int identity not null primary key,
DayOfWeek int not null check(DayOfWeek>=1 and DayOfWeek<=7),
LectureRoom nvarchar(max) not null check(LectureRoom!=''),
SubjectId int not null references Subjects(Id),
TeacherId int not null references Teachers(Id)
)

Create table GroupsLectures(
Id int identity not null primary key,
GroupId int not null references Groups(Id),
LecturedId int not null references Lectures(Id)
)

----------------------

Alter table Groups
ADD QuantityStudents int check(QuantityStudents>15 And QuantityStudents<30) not null

UPDATE dbo.Groups SET QuantityStudents  = 20
----------------------

--1.Вывести количество преподавателей кафедры “Software Development”.
select count(Teachers.Name) from Teachers
join Lectures on Lectures.TeacherId = Teachers.Id
join GroupsLectures on GroupsLectures.LecturedId = Lectures.Id
join Groups on GroupsLectures.GroupId = Groups.Id
join Departments on Departments.Id = Groups.DepartmentId and Departments.Name like '%a%'
group by Teachers.Name

--2. Вывести количество лекций, которые читает преподаватель “Dave McQueen”.
select count(Lectures.Id) from Lectures
join Teachers on Lectures.TeacherId = Teachers.Id and Teachers.Name like '%a%'
group by Lectures.Id

--3. Вывести количество занятий, проводимых в аудитории “D201”.
select count(Subjects.Id) from Subjects
join Lectures on Subjects.Id = Lectures.SubjectId and Lectures.LectureRoom like '%a%'
group by Subjects.Id

--4. Вывести названия аудиторий и количество лекций, проводимых в них.
select Lectures.LectureRoom as Room,count(Subjects.Id) as Subjects  from Subjects
join Lectures on Subjects.Id = Lectures.SubjectId
group by Subjects.Id, Lectures.LectureRoom

--5. Вывести количество студентов, посещающих лекции преподавателя “Jack Underhill”.
select Teachers.Name+' '+Teachers.Surname as Teacher,QuantityStudents from Groups, GroupsLectures, Lectures, Teachers
	where GroupId=Groups.Id and LecturedId=Lectures.Id and TeacherId=Teachers.Id
		and Teachers.Name+' '+Teachers.Surname='Juan Torres'

--6. Вывести среднюю ставку преподавателей факультета “Computer Science”.
select  AVG(Salary) 
	from Departments,Groups,GroupsLectures,Lectures,Teachers
	where GroupId=Groups.Id and LecturedId=Lectures.Id and DepartmentId=Departments.Id and TeacherId=Teachers.Id
		and Departments.Name like'A%'

--7. Вывести минимальное и максимальное количество студентов среди всех групп.
Select Min(QuantityStudents) as 'Quantity', 'Minimum' as 'Group' from Groups 
union 
select Max(QuantityStudents) as 'Quantity', 'Maximum' as 'Group' from Groups 

--8. Вывести средний фонд финансирования кафедр.
select AVG(Finansing) from Departments

--9. Вывести полные имена преподавателей и количество читаемых ими дисциплин.
select CONCAT(Teachers.Name,' ',Teachers.Surname) as Teacher, count(SubjectId) as CountSubject  from Teachers,Lectures
	where TeacherId=Teachers.Id
	group by Teachers.Name, Teachers.Surname

--10. Вывести количество лекций в каждый день недели.
select DayOfWeek as DayWeek, Count(Id) as CountLectures
from Lectures
group by DayOfWeek

--11. Вывести номера аудиторий и количество кафедр, чьи лекции в них читаются.
Select LectureRoom as Room, count(Departments.Name) as CountDepartments 
	from Lectures, GroupsLectures, Departments, Groups
		where LecturedId=Lectures.Id and GroupId=Groups.Id and DepartmentId=Departments.Id
	group by LectureRoom

--12.Вывести названия факультетов и количество дисциплин, которые на них читаются.
select Faculties.Name as Facultet, SubjectId --Count(SubjectId)
	from Lectures, GroupsLectures, Departments, Groups, Faculties
		where LecturedId=Lectures.Id and GroupId=Groups.Id 
		and DepartmentId=Departments.Id and FacultiID=Faculties.Id 
	group by Faculties.Name

--13. Вывести количество лекций для каждой пары преподаватель-аудитория. 
select Concat(SUBSTRING(LectureRoom, 1,5), ' ', Teachers.Name,' ', Teachers.Surname) as Room_Teachers, count(Lectures.Id) as CountLectures
	from Lectures, Teachers
		where TeacherId=Teachers.Id
		group by Teachers.Name, Teachers.Surname, LectureRoom
