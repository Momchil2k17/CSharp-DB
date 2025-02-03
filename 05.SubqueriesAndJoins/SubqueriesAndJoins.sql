--1
SELECT TOP 5 
		e.EmployeeID
		,e.JobTitle
		,a.AddressID
		,a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON
e.AddressID=a.AddressID
ORDER BY a.AddressID

--2
SELECT TOP 50 
	e.FirstName
	,e.LastName
	,t.[Name]
	,a.AddressText 
FROM Towns AS t
JOIN Addresses AS a 
ON a.TownID=t.TownID
JOIN Employees AS e
ON a.AddressID=e.AddressID
ORDER BY e.FirstName,e.LastName

--3
SELECT e.EmployeeID 
	  ,e.FirstName
	  ,e.LastName
	  ,d.Name
FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID=e.DepartmentID AND d.Name='Sales'
ORDER BY e.EmployeeID

--4
SELECT TOP 5 e.EmployeeID 
	  ,e.FirstName
	  ,e.Salary
	  ,d.Name
FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID=e.DepartmentID AND Salary>15000
ORDER BY d.DepartmentID

--5
SELECT TOP 3 e.EmployeeID,e.FirstName FROM EmployeesProjects AS P
Right JOIN Employees AS e
ON e.EmployeeID=p.EmployeeID 
WHERE p.ProjectID IS NULL
ORDER BY e.EmployeeID


--6
SELECT e.FirstName 
	  ,e.LastName
	  ,e.HireDate
	  ,d.Name
FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID=e.DepartmentID AND d.Name IN ('Finance','Sales') AND e.HireDate>'1999/1/1'
ORDER BY e.HireDate

--7
SELECT TOP 5 e.EmployeeID,e.FirstName,pr.Name FROM EmployeesProjects AS P
Right JOIN Employees AS e
ON e.EmployeeID=p.EmployeeID 
JOIN Projects AS pr
ON pr.ProjectID=p.ProjectID 
WHERE pr.StartDate>'2002/8/13' AND pr.EndDate IS NULL
ORDER BY e.EmployeeID

--8
SELECT e.EmployeeID
	  ,e.FirstName
	  ,
	CASE 
		WHEN pr.StartDate>='2005/1/1' THEN NULL
		ELSE pr.Name
	END AS ProjectName
FROM EmployeesProjects AS P
Right JOIN Employees AS e
ON e.EmployeeID=p.EmployeeID 
JOIN Projects AS pr
ON pr.ProjectID=p.ProjectID AND p.EmployeeID=24
ORDER BY e.EmployeeID

--9
SELECT e.EmployeeID
	  ,e.FirstName
	  ,e.ManagerID
	  ,m.FirstName AS [ManagerName]
FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID=e.DepartmentID AND e.ManagerID IN (3,7)
JOIN Employees AS m
ON e.ManagerID=m.EmployeeID
ORDER BY EmployeeID

--10
SELECT TOP 50 e.EmployeeID
	  ,CONCAT_WS(' ',e.FirstName,e.LastName) AS [EmployeeName]
	  ,CONCAT_WS(' ',m.FirstName,m.LastName) AS [ManagerName]
	  ,d.Name AS [DepartmentName]
FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID=e.DepartmentID
JOIN Employees AS m
ON e.ManagerID=m.EmployeeID
ORDER BY EmployeeID

--11
SELECT MIN(a.AverageSalary) AS MinAverageSalary
FROM
 (SELECT e.DepartmentID,
	AVG(e.Salary) AS AverageSalary
	FROM Employees AS e
	GROUP BY e.DepartmentID
 ) AS a

 --12
SELECT mc.CountryCode,m.MountainRange,p.PeakName,p.Elevation FROM MountainsCountries AS mc
JOIN Mountains AS m ON 
m.Id=mc.MountainId AND mc.CountryCode='BG'
JOIN Peaks AS p
ON p.MountainId=m.Id AND p.Elevation>2835
ORDER BY p.Elevation DESC

--13
SELECT mc.CountryCode,COUNT(m.MountainRange) AS [MountainRanges] FROM MountainsCountries AS mc
LEFT JOIN Mountains AS m
ON mc.MountainId=m.Id 
WHERE mc.CountryCode IN ('BG','RU','US')
GROUP BY mc.CountryCode

SELECT c.CountryCode,COUNT(mc.MountainId) FROM Countries AS c
LEFT JOIN MountainsCountries as mc
ON mc.CountryCode=c.CountryCode
GROUP BY c.CountryCode


--14
SELECT TOP 5 cr.CountryName,r.RiverName FROM CountriesRivers as c
RIGHT JOIN Countries as cr
ON c.CountryCode=cr.CountryCode
LEFT JOIN Rivers as r
ON r.Id=c.RiverId
JOIN Continents as co ON co.ContinentCode=cr.ContinentCode AND co.ContinentCode='AF'
ORDER BY cr.CountryName

SELECT TOP 5 c.CountryName,r.RiverName FROM Countries as c
LEFT JOIN CountriesRivers as cr
ON c.CountryCode=cr.CountryCode
LEFT JOIN Rivers as r
ON r.Id=cr.RiverId
JOIN Continents as co ON co.ContinentCode=c.ContinentCode AND co.ContinentCode='AF'
ORDER BY c.CountryName

--15
SELECT ContinentCode,CurrencyCode,CurrencyCount FROM(
	SELECT *,
		DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [CurrencyCount] DESC) as [CurrRank]
	FROM (
		SELECT co.[ContinentCode],c.CurrencyCode,COUNT(c.CurrencyCode) AS CurrencyCount 
		FROM Countries AS c
		JOIN Continents AS co
		ON co.ContinentCode = c.ContinentCode
		GROUP BY co.ContinentCode, c.CurrencyCode
		HAVING COUNT(c.CurrencyCode) > 1  
	) AS a)
	AS b
WHERE CurrRank=1
ORDER BY ContinentCode



--16
SELECT COUNT(c.CountryName) AS [Count] FROM Countries as c
LEFT JOIN MountainsCountries as mc
ON mc.CountryCode=c.CountryCode WHERE mc.MountainId IS NULL

--17
SELECT TOP 5 c.CountryName,MAX(p.Elevation) AS [HighestPeakElevation],MAX(r.Length) AS [LongestRiverLength] FROM Countries as c
LEFT JOIN CountriesRivers as cr
ON cr.CountryCode=c.CountryCode
LEFT JOIN Rivers as r
ON r.Id=cr.RiverId
LEFT JOIN MountainsCountries as mc
ON mc.CountryCode=c.CountryCode
LEFT JOIN Mountains as m
ON m.Id=mc.MountainId
LEFT JOIN Peaks as p
ON p.MountainId=m.Id
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC,[LongestRiverLength] DESC,c.CountryName

--18

SELECT TOP 5 CountryName,
	CASE 
		WHEN PeakName IS NULL THEN '(no highest peak)'
		ELSE PeakName
	END AS [Highest Peak Name],
	CASE 
		WHEN Elevation IS NULL THEN 0
		ELSE Elevation
	END AS [Highest Peak Elevation],
	CASE 
		WHEN MountainRange IS NULL THEN '(no mountain)'
		ELSE MountainRange
	END AS [Mountain]
FROM ( 
SELECT  c.CountryName,p.Elevation,p.PeakName,m.MountainRange,DENSE_RANK() OVER (PARTITION BY CountryName ORDER BY Elevation DESC) AS Ranking FROM Countries as c
LEFT JOIN MountainsCountries as mc
ON mc.CountryCode=c.CountryCode
LEFT JOIN Mountains as m
ON m.Id=mc.MountainId
LEFT JOIN Peaks as p
ON p.MountainId=m.Id
) AS r
WHERE Ranking=1
ORDER BY CountryName,[Highest Peak Name]

