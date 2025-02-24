--1
CREATE DATABASE ShoesApplicationDatabase

CREATE TABLE Users
(
	Id INT PRIMARY KEY IDENTITY,
	Username NVARCHAR(50) UNIQUE NOT NULL,
	FullName NVARCHAR(100) NOT NULL,
	PhoneNumber NVARCHAR(15),
	Email NVARCHAR(100) UNIQUE NOT NULL,
)

CREATE TABLE Brands
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) UNIQUE NOT NULL,
)


CREATE TABLE Shoes
(
	Id INT PRIMARY KEY IDENTITY,
	Model NVARCHAR(30) NOT NULL,
	Price DECIMAL(10,2) NOT NULL,
	BrandId INT FOREIGN KEY REFERENCES Brands(Id) NOT NULL
)

CREATE TABLE Sizes
(
	Id INT PRIMARY KEY IDENTITY,
	EU DECIMAL(5,2) NOT NULL,
	US DECIMAL(5,2) NOT NULL,
	UK DECIMAL(5,2) NOT NULL,
	CM DECIMAL(5,2) NOT NULL,
	[IN] DECIMAL(5,2) NOT NULL,
)

CREATE TABLE ShoesSizes
(
	ShoeId INT FOREIGN KEY REFERENCES Shoes(Id) NOT NULL,
	SizeId INT FOREIGN KEY REFERENCES Sizes(Id) NOT NULL,
	PRIMARY KEY(ShoeId,SizeId)
)

CREATE TABLE Orders
(
	Id INT PRIMARY KEY IDENTITY,
	ShoeId INT FOREIGN KEY REFERENCES Shoes(Id) NOT NULL,
	SizeId INT FOREIGN KEY REFERENCES Sizes(Id) NOT NULL,
	UserId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL,
)

--2
INSERT INTO Brands VALUES
('Timberland'),
('Birkenstock')

INSERT INTO Shoes VALUES
('Reaxion Pro',	150.00,	12)
,('Laurel Cort Lace-Up',	160.00,	12)
,('Perkins Row Sandal',	170.00,	12)
,('Arizona',	80.00,	13)
,('Ben Mid Dip',	85.00,	13)
,('Gizeh',	90.00,	13)

INSERT INTO ShoesSizes VALUES
(70,1)
,(70,2)
,(70,	3)
,(71,	2)
,(71,3)
,(71,4)
,(72,4)
,(72,5)
,(72,6)
,(73,1)
,(73,3)
,(73,5)
,(74,2)
,(74,4)
,(74,6)
,(75,1)
,(75,2)
,(75,3)



INSERT INTO Orders VALUES
(70	,2,	15)
,(71,	3,	17)
,(72,	6,	18)
,(73,	5,	4)
,(74,	4,	7)
,(75,	1,	11)

--3
UPDATE Shoes
SET Price*=1.15
WHERE Price IN(
SELECT Price FROM Brands as b
JOIN Shoes AS s ON s.BrandId=b.Id
WHERE b.Name='Nike')

--4
SELECT s.Id FROM Brands as b
JOIN Shoes AS s ON s.BrandId=b.Id
WHERE s.Model='Joyride Run Flyknit'

DELETE FROM Orders
WHERE ShoeId IN (SELECT s.Id FROM Brands as b
JOIN Shoes AS s ON s.BrandId=b.Id
WHERE s.Model='Joyride Run Flyknit')

DELETE FROM ShoesSizes
WHERE ShoeId IN (SELECT s.Id FROM Brands as b
JOIN Shoes AS s ON s.BrandId=b.Id
WHERE s.Model='Joyride Run Flyknit')

DELETE FROM Shoes
WHERE Id IN (SELECT s.Id FROM Brands as b
JOIN Shoes AS s ON s.BrandId=b.Id
WHERE s.Model='Joyride Run Flyknit')

--5
SELECT s.Model AS [ShoeModel],s.Price FROM Orders as o
JOIN Shoes as s ON o.ShoeId=s.Id
ORDER BY s.Price DESC,s.Model

--6
SELECT b.Name AS [BrandName],s.Model AS [ShoesCount] FROM Brands as b
JOIN Shoes as s ON s.BrandId=b.Id
ORDER BY b.Name,s.Model

--7
SELECT TOP 10 u.Id AS [UserId],u.FullName,SUM(s.Price) AS [TotalSpent] FROM Orders as o
JOIN Users as u ON o.UserId=u.Id
JOIN Shoes as s ON s.Id=o.ShoeId
GROUP BY u.Id,u.FullName
ORDER BY TotalSpent DESC,U.FullName

--8

SELECT u.Username,u.Email,CAST(AVG(s.Price) AS decimal(10,2))AS [AvgPrice] FROM Orders as o
JOIN Users as u ON o.UserId=u.Id
JOIN Shoes as s ON s.Id=o.ShoeId
GROUP BY u.Username,u.Email
HAVING (COUNT(s.Id))>2
ORDER BY [AvgPrice] DESC

--9
SELECT s.Model,COUNT(s.Model) AS [CountOfSizes],b.Name AS [BrandName] FROM Shoes as s
JOIN ShoesSizes as sz on s.Id=sz.ShoeId
JOIN Sizes as si ON si.Id=sz.SizeId
JOIN Brands as b on b.Id=s.BrandId
WHERE b.Name='Nike' AND s.Model LIKE '%Run%'
GROUP BY b.Name,s.Model
HAVING COUNT(s.Model)>5
ORDER BY s.Model DESC

--10
SELECT u.FullName,u.PhoneNumber,s.Price AS [OrderPrice],s.Id,s.BrandId,
		CONCAT(si.EU,'EU/',si.US,'US/',si.UK,'UK') AS [ShoeSize] FROM Users as u
JOIN Orders as o ON o.UserId=u.Id
JOIN Shoes as s ON s.Id=o.ShoeId
JOIN Sizes as si on si.Id=o.SizeId
WHERE u.PhoneNumber LIKE '%345%'
ORDER By s.Model

--11
GO
CREATE OR ALTER FUNCTION udf_OrdersByEmail(@email NVARCHAR(100)) 
RETURNS INT AS
BEGIN
	DECLARE @Result INT
	SET @Result= (
	SELECT COUNT(*) FROM Users as u
	JOIN Orders as o on u.Id=o.UserId
	WHERE u.Email=@email
	GROUP BY u.Email)
	IF(@Result IS NULL)
		RETURN 0
	RETURN @Result

END

GO
SELECT dbo.udf_OrdersByEmail('ohernandez@example.com')
SELECT dbo.udf_OrdersByEmail('nonexistent@example.com')

--12
GO
CREATE OR ALTER PROC usp_SearchByShoeSize(@shoeSize DECIMAL(5,2)) AS
SELECT s.Model as [ModelName]
      ,u.FullName as [UserFullName]
	  ,CASE 
			WHEN s.Price<100 THEN 'Low'
			WHEN s.Price BETWEEN 100 AND 200 THEN 'Medium'
			ELSE 'High'
		END AS [PriceLevel]
      ,B.Name AS [BrandName]
	  ,si.EU AS [SizeEU]
	  FROM Brands as b
JOIN Shoes as s ON b.Id=s.BrandId
JOIN Orders as o ON o.ShoeId=s.Id
JOIN Users as u ON o.UserId=u.Id
JOIN Sizes as si on si.Id=o.SizeId
WHERE si.EU=@shoeSize
ORDER BY b.Name,u.FullName

GO
SELECT u.Id,u.FullName FROM Sizes as si
JOIN ShoesSizes as sz ON si.EU=sz.ShoeId
JOIN Shoes as s ON s.Id=sz.ShoeId
JOIN Orders as o ON o.ShoeId=s.Id
JOIN Users AS u on o.UserId=u.Id

EXEC usp_SearchByShoeSize 40.00