CREATE DATABASE Hospital

GO

USE Hospital

CREATE TABLE Examinations(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE Doctors(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  Surname nvarchar(max) NOT NULL CHECK(Surname != ''),
  Salary money NOT NULL CHECK(Salary > 0)
)

CREATE TABLE Professors(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  DoctorId int NOT NULL FOREIGN KEY REFERENCES Doctors(Id)
)

CREATE TABLE Interns(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  DoctorId int NOT NULL FOREIGN KEY REFERENCES Doctors(Id)
)

CREATE TABLE Departments(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != ''),
  Building int NOT NULL CHECK(Building BETWEEN 1 AND 5),
  Financing money NOT NULL CHECK(Financing !< 0) DEFAULT 0
)

CREATE TABLE Wards(
  Id int IDENTITY NOT NULL PRIMARY KEY,
  Name nvarchar(20) NOT NULL UNIQUE CHECK(Name != ''),
  Places int NOT NULL CHECK(Places !< 1),
  DepartmentId int NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Diseases(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE DoctorsExaminations(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Date date NOT NULL CHECK(Date !> GETDATE()) DEFAULT GETDATE(),
  DiseaseId int NOT NULL FOREIGN KEY REFERENCES Diseases(Id),
  DoctorId int NOT NULL FOREIGN KEY REFERENCES Doctors(Id),
  ExaminationId int NOT NULL FOREIGN KEY REFERENCES Examinations(Id),
  WardId int NOT NULL FOREIGN KEY REFERENCES Wards(Id)
)

----------------------------------------------------------

INSERT INTO Departments VALUES
(N'General Surgery', 4, 32312),
(N'Physiotherapy', 3, 78675),
(N'Microbiology', 2, 89423),
(N'Ophthalmology', 5, 32132),
(N'Oncology', 5, 41223),
(N'Neurology', 1, 65412)

INSERT INTO Doctors VALUES
(N'Thomas', N'Gerada', 2000),
(N'Anthony', N'Davis', 1500),
(N'Joshua', N'Bell', 500),
(N'Bill', N'Brown', 3000),
(N'Ivan', N'Ivanov', 1700)

INSERT INTO Examinations VALUES
(N'Fhdjshdd'),
(N'Lhjdjshj'),
(N'Yjdkjsdk'),
(N'Jgdyudhs')

INSERT INTO Wards VALUES
(N'Seven', 40, 3),
(N'Nine', 7, 4),
(N'Three', 150, 6),
(N'Five', 12, 2)

INSERT INTO Diseases VALUES
(N'Flu'),
(N'Measles'),
(N'Diphtheria'),
(N'Diabetes'),
(N'Cancer')

INSERT INTO DoctorsExaminations VALUES
(DEFAULT, 2, 1, 4, 1),
('2018-10-29', 3, 2, 3, 3),
(DEFAULT, 1, 3, 2, 4),
('2007-07-07', 4, 4, 1, 2)

INSERT INTO Professors VALUES
(1),
(3)

INSERT INTO Interns VALUES
(4),
(2)

Select Wards.Name, Wards.Places From Wards
join Departments on Wards.DepartmentId = Departments.Id
Where Departments.Building = 5 and Wards.Places > 5

Select Departments.Name From DoctorsExaminations
join Wards on Wards.Id = DoctorsExaminations.WardId
join Departments on Departments.Id = Wards.DepartmentId
Where DoctorsExaminations.Date between GETDATE()-7 and GETDATE()

Select Diseases.Name From DoctorsExaminations
full join Examinations on DoctorsExaminations.ExaminationId = Examinations.Id
full join Diseases on Diseases.Id = DoctorsExaminations.DiseaseId
Where Examinations.Name is null 

Select Doctors.Name + ' ' + Doctors.Surname  From DoctorsExaminations
full join Examinations on Examinations.Id = DoctorsExaminations.ExaminationId
full join Doctors on Doctors.Id = DoctorsExaminations.DoctorId
Where Examinations.Id is null

Select Departments.Name from DoctorsExaminations
full join Wards on DoctorsExaminations.WardId = Wards.Id
full join Departments on Wards.DepartmentId = Departments.Id
Where  DoctorsExaminations.ExaminationId is null

Select Doctors.Surname from Doctors
join Interns on Interns.DoctorId = Doctors.Id

Select Doctors.Surname from Doctors
join Interns on Interns.DoctorId = Doctors.Id
Where Salary > (Select max(Salary) from Doctors 
full join Interns on Doctors.Id=Interns.DoctorId Where Interns.DoctorId is null)

Select Wards.Name From Wards
join Departments on Departments.Id = Wards.DepartmentId
Where Places > (Select MAX(Places) From Wards
join Departments on Departments.Id = Wards.DepartmentId Where Departments.Building = 3)

Select Doctors.Surname from DoctorsExaminations
full join Wards on Wards.Id = DoctorsExaminations.WardId
full join Departments on Departments.Id = Wards.DepartmentId
full join Doctors on Doctors.Id = DoctorsExaminations.DoctorId
Where DoctorsExaminations.ExaminationId is not null and (Departments.Name = 'Ophthalmology' or Departments.Name = 'Physiotherapy')

Select Departments.Name From Doctors
full join Interns on Interns.DoctorId = Doctors.Id
full join Professors on Professors.DoctorId = Doctors.Id
full join DoctorsExaminations on DoctorsExaminations.DoctorId = Doctors.Id
full join Wards on DoctorsExaminations.WardId = Wards.Id
full join Departments on Departments.Id = Wards.DepartmentId
Where Interns.Id is not null and Professors.Id is not null

Select Doctors.Surname + '' + Doctors.Name, Departments.Name From DoctorsExaminations
join Doctors on DoctorsExaminations.DoctorId = Doctors.Id
join Wards on DoctorsExaminations.WardId = Wards.Id
join Departments on Departments.Id = Wards.DepartmentId
Where Departments.Financing > 20000

Select Departments.Name From DoctorsExaminations
join Doctors on DoctorsExaminations.DoctorId = Doctors.Id
join Wards on DoctorsExaminations.WardId = Wards.Id
join Departments on Departments.Id = Wards.DepartmentId
Where Salary >= (Select max(Salary) from Doctors)

Select Diseases.Name, count(DoctorsExaminations.ExaminationId) as CountEx From DoctorsExaminations
full join Diseases on DoctorsExaminations.DiseaseId = Diseases.Id
Where DoctorsExaminations.ExaminationId > 0
group by Diseases.Name