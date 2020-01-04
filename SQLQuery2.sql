Select * From Departments Order by Name Desc

Select Name AS GroupName, Rating AS GroupRating From Groups

Select Surname, Salary/Premium AS SataryPrem, Salary/(Salary + Premium) AS SatarySal From Teachers

Select 'The ' + Dean + ' of ' + Name From Faculties

Select Surname From Teachers Where IsProfessor > 0 AND Salary > 1050

Select Name From Departments Where Financing < 11000 or Financing > 25000

Select Name From Faculties Where Name != 'Computer Science'

Select Surname, Position From Teachers Where IsProfessor = 0

Select Surname, Position, Salary, Premium From Teachers Where IsAssistant > 0 and Premium >= 160 and Premium <= 550

Select Surname, Salary From Teachers Where IsAssistant > 0

Select Surname, Position From Teachers Where EmploymentDate < '2000-01-01'

Select Name as 'Name of De part ment' From Departments Where Name > 'Software Development'

Select Surname From Teachers Where (Salary+Premium) < 1200

Select Name From Groups Where Year = 5 and Rating >=2 and Rating <=4

Select Surname From Teachers Where IsAssistant > 0 and (Salary < 550 or Premium < 200)
