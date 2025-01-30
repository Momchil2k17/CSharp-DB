--1
SELECT FirstName,LastName FROM Employees
WHERE FirstName LIKE 'Sa%'

--2
SELECT FirstName,LastName FROM Employees
WHERE LastName LIKE '%ei%'

--3
SELECT FirstName FROM Employees
WHERE DepartmentID IN (3,10) AND YEAR(HireDate) BETWEEN 1995 AND 2005

--4
SELECT FirstName,LastName FROM Employees
WHERE JobTitle NOT LIKE  '%engineer%'

--5
SELECT Name FROM Towns
WHERE LEN(Name) IN (5,6)
ORDER BY Name 

--6
SELECT * FROM Towns
WHERE Name LIKE '[MKBE]%'
ORDER By Name

--7
SELECT * FROM Towns
WHERE Name LIKE '[^RBD]%'
ORDER By Name


--8
GO
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName FROM Employees
WHERE YEAR(HireDate)>2000
GO
--9
SELECT FirstName,LastName FROM Employees
WHERE LEN(LastName)=5

--10
SELECT EmployeeID,FirstName,LastName,Salary,
		DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--11
WITH Ranked AS
	(SELECT EmployeeID,FirstName,LastName,Salary,
			DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000)
SELECT * FROM Ranked where rank=2ORDER BY Salary DESC


--12
SELECT CountryName,IsoCode
FROM Countries
WHERE LEN(CountryName) - LEN(REPLACE(LOWER(CountryName), 'a', ''))>=3
ORDER BY IsoCode

--13
SELECT PeakName,RiverName,LOWER(LEFT(PeakName,LEN(PeakName)-1)+RIGHT(RiverName,LEN(RiverName))) AS Mix FROM Peaks as p
JOIN Rivers as r
ON RIGHT(PeakName,1)=LEFT(RiverName,1)
ORDER BY Mix

--14

SELECT TOP(50) Name,FORMAT(Start,'yyyy-MM-dd') as [Start] FROM Games
WHERE YEAR(Start) IN (2011,2012)
ORDER BY Start,Name

--15
SELECT Username,SUBSTRING(Email,CHARINDEX('@',Email)+1,LEN(Email)-CHARINDEX('@',Email)) AS [Email Provider] FROM Users
ORDER BY [Email Provider],Username

--16
SELECT Username,IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--17
SELECT Name,
CASE 
	WHEN DATEPART(HOUR, Start)<12 THEN 'Morning' 
	WHEN DATEPART(HOUR, Start)>=12 AND DATEPART(HOUR, Start)<18 THEN 'Afternoon' 
	ELSE 'Evening'
END AS [Part of the Day],
CASE 
	WHEN Duration<=3 THEN 'Extra Short'
	WHEN Duration>3 AND Duration<=6 THEN 'Short'
	WHEN Duration>6 THEN 'Long'
	ELSE 'Extra Long'
END AS Duration
FROM Games
ORDER BY Name,Duration,[Part of the Day]

SELECT * FROM Games ORDER BY Name
--18
SELECT ProductName,OrderDate,DATEADD(DAY,3,OrderDate) AS [Pay Due],DATEADD(MONTH,1,OrderDate) AS [Deliver Due] FROM Orders