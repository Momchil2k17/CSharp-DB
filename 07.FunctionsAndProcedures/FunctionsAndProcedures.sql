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
--My approach:
CREATE FUNCTION ufn_IsWordComprised(
    @setOfLetters NVARCHAR(100),
    @word NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @letters TABLE (letter CHAR(1) PRIMARY KEY)
    DECLARE @wordLetters TABLE (letter CHAR(1) PRIMARY KEY)

    DECLARE @i INT = 1
    DECLARE @char CHAR(1)

    -- Insert each letter of @setOfLetters into @letters table
    WHILE @i <= LEN(@setOfLetters)
    BEGIN
        SET @char = SUBSTRING(@setOfLetters, @i, 1)
        IF NOT EXISTS (SELECT 1 FROM @letters WHERE letter = @char)
            INSERT INTO @letters VALUES (@char)
        SET @i = @i + 1
    END

    -- Reset counter for word parsing
    SET @i = 1

    -- Insert each letter of @word into @wordLetters table
    WHILE @i <= LEN(@word)
    BEGIN
        SET @char = SUBSTRING(@word, @i, 1)
        IF NOT EXISTS (SELECT 1 FROM @wordLetters WHERE letter = @char)
            INSERT INTO @wordLetters VALUES (@char)
        SET @i = @i + 1
    END

    -- Check if every letter in @wordLetters exists in @letters
    IF EXISTS (
        SELECT wl.letter
        FROM @wordLetters wl
        LEFT JOIN @letters l ON wl.letter = l.letter
        WHERE l.letter IS NULL
    )
        RETURN 0 -- Some letters from @word are missing

    RETURN 1 -- All letters from @word exist in @setOfLetters
END
GO

--Lecturer's approach:
CREATE FUNCTION ufn_IsWordComprised(
    @setOfLetters NVARCHAR(100),
    @word NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @i INT = 1
    DECLARE @char CHAR(1)

    -- Loop through each character in @word
    WHILE @i <= LEN(@word)
    BEGIN
        SET @char = SUBSTRING(@word, @i, 1)

        -- If the character is not in @setOfLetters, return FALSE
        IF CHARINDEX(@char, @setOfLetters) = 0
            RETURN 0

        SET @i = @i + 1
    END

    -- If all characters are found, return TRUE
    RETURN 1
END
GO
--8
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS

DECLARE @empIDsToBeDeleted TABLE
(
Id int
)

INSERT INTO @empIDsToBeDeleted
SELECT e.EmployeeID
FROM Employees AS e
WHERE e.DepartmentID = @departmentId

ALTER TABLE Departments
ALTER COLUMN ManagerID int NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Employees
WHERE EmployeeID IN (SELECT Id FROM @empIDsToBeDeleted)

DELETE FROM Departments
WHERE DepartmentID = @departmentId 

SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId

--9
GO
CREATE OR ALTER PROC usp_GetHoldersFullName AS 
SELECT CONCAT_WS(' ',FirstName,LastName) FROM AccountHolders


SELECT FirstName,SUM(Balance) FROM Accounts AS a
JOIN AccountHolders as h ON a.AccountHolderId=h.Id
GROUP BY AccountHolderId,FirstName,LastName
--10
GO
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan(@balance DECIMAL(18,4)) AS
SELECT FirstName,LastName FROM Accounts AS a
JOIN AccountHolders as h ON a.AccountHolderId=h.Id
GROUP BY AccountHolderId,FirstName,LastName
HAVING SUM(Balance)>@balance
ORDER BY FirstName,LastName

--11
GO
CREATE OR ALTER FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(18,4),@interest FLOAT,@years INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
  DECLARE @Result DECIMAL(18,4)
  SET @Result=@sum*POWER((1+@interest),@years)
  RETURN @Result
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

GO
--12
CREATE OR ALTER PROC usp_CalculateFutureValueForAccount(@id INT,@interest FLOAT) AS
SELECT a.Id,h.FirstName,h.LastName,a.Balance,dbo.ufn_CalculateFutureValue(Balance, @interest, 5) FROM Accounts AS a
JOIN AccountHolders as h ON a.AccountHolderId=h.Id
WHERE a.Id=@id

GO
--13

CREATE OR ALTER FUNCTION ufn_CashInUsersGames(@gname NVARCHAR(50))
RETURNS Table AS
RETURN(
SELECT SUM(Cash) AS SumCash FROM(
SELECT Cash,ROW_NUMBER() OVER(ORDER BY u.Cash DESC) AS R FROM UsersGames as u
JOIN Games as g ON g.Id=u.GameId
WHERE g.Name=@gname
) as t1
WHERE R%2=1)

