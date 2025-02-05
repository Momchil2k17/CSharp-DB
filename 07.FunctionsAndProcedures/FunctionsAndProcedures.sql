--1
CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000  AS
SELECT FirstName,LastName FROM Employees
WHERE Salary>35000

GO
--2
CREATE OR ALTER PROC usp_GetEmployeesSalaryAboveNumber(@Sal DECIMAL(18,4)) AS
SELECT FirstName,LastName FROM Employees
WHERE Salary>=@Sal
GO

--3
CREATE OR ALTER PROC usp_GetTownsStartingWith(@N NVARCHAR(20)) AS
SELECT Name FROM Towns
WHERE Name LIKE @N+'%'
GO
EXEC usp_GetTownsStartingWith 'Be'

--4
GO
CREATE OR ALTER PROC usp_GetEmployeesFromTown (@TName NVARCHAR(50)) AS
SELECT FirstName,LastName FROM Employees as E
JOIN Addresses as a ON e.AddressID=a.AddressID
JOIN Towns as t ON t.TownID=a.TownID
WHERE t.Name=@TName

GO
--5
CREATE OR ALTER Function ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(10) AS
BEGIN 
	DECLARE @Level VARCHAR(10) = 'Average'
	IF(@salary<30000) SET @Level='Low'
	IF(@salary>50000) SET @Level='High'
	RETURN @Level
END

GO
--6
CREATE OR ALTER PROC usp_EmployeesBySalaryLevel(@Level VARCHAR(10)) AS
SELECT FirstName,LastName FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary)=@Level 

GO
--7
