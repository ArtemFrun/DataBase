Create Table Departments
(
Id int IDENTITY Primary key NOT NULL,
Financing money Check (Financing > 0 ) Default 0 NOT NULL,
Name nvarchar(100) UNIQUE Check(Name != '') NOT NULL
)

Create Table Faculties
(
Id int IDENTITY Primary key NOT NULL,
Dean nvarchar(max) Check(Dean != '') NOT NULL,
Name nvarchar(100) Unique check(Name != '') NOT NULL
)

create table Groups
(
Id int identity primary key not null,
Name nvarchar(10) unique check(Name != '' ) not null,
Rating int check (Rating >= 0 and Rating < 6) not null,
Year int check(Year > 0 and Year < 6) not null,
)

create table Teachers
(
Id int identity primary key not null,
EmploymentDate date check(EmploymentDate > '01.01.1990') not null,
IsAssistant bit default 0 not null,
IsProfessor bit default 0 not null,
Name nvarchar(max) check(Name != '') not null,
Position nvarchar(max) check(Position != '') not null,
Premium money default 0 check(Premium >= 0) not null,
Salary money check (Salary > 0) not null,
Surname nvarchar(max) check(Surname != '') not null
)
