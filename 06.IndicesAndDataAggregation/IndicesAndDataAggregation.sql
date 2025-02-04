--1
SELECT COUNT(*) AS [Count] FROM WizzardDeposits

--2
SELECT DepositGroup,MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits

--3
SELECT DepositGroup,MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits
GROUP BY DepositGroup

--4
SELECT DepositGroup FROM(
SELECT DepositGroup,DENSE_RANK() OVER (ORDER BY AVG(MagicWandSize)) AS R FROM WizzardDeposits
GROUP BY DepositGroup) as rr
WHERE R=1

--5
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
GROUP BY DepositGroup

--6
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup

--7
SELECT DepositGroup,SUM(DepositAmount) AS [TotalSum] FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount)<150000
ORDER BY [TotalSum] DESC

--8
SELECT DepositGroup,MagicWandCreator,MIN(DepositCharge) AS [TotalSum] FROM WizzardDeposits
GROUP BY DepositGroup,MagicWandCreator
ORDER BY MagicWandCreator,DepositGroup

--9
SELECT AgeRange,COUNT(AgeRange) FROM(
SELECT CASE 
	WHEN Age>10 AND AGE<21 THEN '[11-20]'
	WHEN Age>20 AND AGE<31 THEN '[21-30]'
	WHEN Age>30 AND AGE<41 THEN '[31-40]'
	WHEN Age>40 AND AGE<51 THEN '[41-50]'
	WHEN Age>50 AND AGE<61 THEN '[51-60]'
	ELSE '[61+]'
	END AS AgeRange FROM WizzardDeposits) as r
	GROUP BY AgeRange

--10
SELECT LEFT(FirstName,1) FROM WizzardDeposits
WHERE DepositGroup='Troll Chest'
GROUP BY LEFT(FirstName,1)
ORDER BY LEFT(FirstName,1)

--11
SELECT DepositGroup,IsDepositExpired,AVG(DepositInterest) AS [AverageInterest] FROM WizzardDeposits
WHERE DepositStartDate>'1985/1/1'
GROUP BY DepositGroup,IsDepositExpired
ORDER BY DepositGroup DESC,IsDepositExpired

--12
SELECT SUM(Difference) AS [SumDifference] FROM(
SELECT *, [Host Wizard Deposit]- [Guest Wizard Deposit] AS [Difference] FROM (
SELECT 
	w1.FirstName AS [Host Wizard]
	,w1.DepositAmount AS [Host Wizard Deposit]
	,w2.FirstName AS [Guest Wizard]
	,w2.DepositAmount AS [Guest Wizard Deposit]
	FROM WizzardDeposits as w1
JOIN WizzardDeposits as w2 ON w2.Id=w1.Id+1 ) as t1) as t2

--13
USE SoftUni
GO
SELECT DepartmentID,SUM(Salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14
SELECT DepartmentID,MIN(Salary) AS TotalSalary FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate>'2000/1/1'
GROUP BY DepartmentID
ORDER BY DepartmentID

--15

SELECT * INTO [HigherSalaryThan30000]  FROM Employees
WHERE Salary>30000
DELETE FROM HigherSalaryThan30000
WHERE ManagerID=42
UPDATE HigherSalaryThan30000
SET Salary+=5000
WHERE DepartmentID=1
SELECT DepartmentID,AVG(Salary) AS TotalSalary FROM [HigherSalaryThan30000]
GROUP BY DepartmentID
ORDER BY DepartmentID

--16
SELECT DepartmentID,MAX(Salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 and 70000
ORDER BY DepartmentID

--17
SELECT COUNT(*) AS [Count] FROM Employees
WHERE ManagerID IS NULL
--18
SELECT DISTINCT DepartmentID,Salary FROM(
SELECT DepartmentID,Salary,DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS R FROM Employees) as f
WHERE R=3
ORDER BY DepartmentID

--19
SELECT TOP 10 FirstName,LastName,DepartmentID FROM(
SELECT FirstName,LastName,DepartmentID,Salary,AVG(Salary) OVER(Partition BY DepartmentID) AS AvgSal FROM Employees) as t1
WHERE Salary>AvgSal
ORDER BY DepartmentID
