CREATE DATABASE TouristAgency

CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Destinations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)	NOT NULL
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	DestinationId INT FOREIGN KEY REFERENCES Destinations(Id) NOT NULL
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	[Type]	VARCHAR(40) NOT NULL,
	Price DECIMAL(18,2) NOT NULL,
	BedCount INT CHECK(BedCount BETWEEN 1 AND 10)
)

CREATE TABLE HotelsRooms
(
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id) NOT NULL,
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
	PRIMARY KEY(HotelId,RoomId)
)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Email VARCHAR(80),
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)	NOT NULL
)

CREATE TABLE Bookings
(
	Id INT PRIMARY KEY IDENTITY,
	ArrivalDate DATETIME2 NOT NULL,
	DepartureDate DATETIME2 NOT NULL,
	AdultsCount INT CHECK(AdultsCount BETWEEN 1 AND 10) NOT NULL,
	ChildrenCount INT CHECK(ChildrenCount BETWEEN 0 AND 9) NOT NULL,
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id) NOT NULL,
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id) NOT NULL,
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
)

--2
INSERT INTO Tourists
VALUES
    ('John Rivers', '653-551-1555', 'john.rivers@example.com', 6),
    ('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
    ('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
    ('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
    ('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)

INSERT INTO Bookings 
VALUES
    ('2024-03-01', '2024-03-11', 1, 0, 21, 3, 5),
    ('2023-12-28', '2024-01-06', 2, 1, 22, 13, 3),
    ('2023-11-15', '2023-11-20', 1, 2, 23, 19, 7),
    ('2023-12-05', '2023-12-09', 4, 0, 24, 6, 4),
    ('2024-05-01', '2024-05-07', 6, 0, 25, 14, 6)
--3
UPDATE Bookings 
SET DepartureDate = DATEADD(DAY,1,DepartureDate) FROM Bookings
WHERE DepartureDate BETWEEN '2023/12/1' AND  '2023/12/31'

UPDATE Tourists
SET Email=NULL
WHERE Name LIKE '%ma%'

--4
SELECT Id FROM Tourists Where Name LIKE '% Smith'

DELETE FROM Bookings
WHERE TouristId IN (SELECT Id FROM Tourists Where Name LIKE '% Smith')

DELETE FROM Tourists 
WHERE Id IN (SELECT Id FROM Tourists Where Name LIKE '% Smith')

--5
SELECT FORMAT(b.ArrivalDate, 'yyyy-MM-dd') AS [ArrivalDate],b.AdultsCount,b.ChildrenCount FROM Bookings as b
JOIN Rooms as r ON r.Id=b.RoomId
ORDER BY r.Price DESC,b.ArrivalDate

--6
SELECT h.Id,h.Name FROM Hotels as h
JOIN HotelsRooms as hr ON h.Id=hr.HotelId
JOIN Rooms as r ON r.Id=hr.RoomId
JOIN Bookings as b on h.Id=b.HotelId
WHERE r.Id=8
GROUP BY h.Id,h.Name
ORDER BY COUNT(b.Id) DESC

--7
SELECT t.Id,t.Name,t.PhoneNumber FROM Tourists as t
LEFT JOIN Bookings as b ON t.Id=b.TouristId
WHERE b.Id IS NULL
ORDER BY t.Name

--8
SELECT TOP 10 h.Name as [HotelName],d.Name as [DestinationName],c.Name as [CountryName] FROM Bookings as b
JOIN Hotels as h ON h.Id=b.HotelId
JOIN Destinations as d on d.Id=h.DestinationId
JOIN Countries as c on c.Id=d.CountryId
WHERE ArrivalDate<'2023/12/31' AND h.Id%2=1
ORDER BY c.Name,b.ArrivalDate

--9
SELECT h.Name,r.Price FROM Tourists as t
JOIN Bookings as b ON b.TouristId=t.Id
JOIN Hotels as h ON b.HotelId=h.Id
JOIN Rooms as r ON b.RoomId=r.Id
WHERE t.Name NOT LIKE '%ez'
ORDER BY r.Price DESC

--10
SELECT h.Name AS [HotelName], SUM(DATEDIFF(DAY,ArrivalDate,DepartureDate)*r.Price) AS [HotelRevenue] FROM Bookings as b
JOIN Rooms as r ON r.Id=b.RoomId
JOIN Hotels as h ON h.Id=b.HotelId
GROUP BY h.Name
ORDER BY SUM(DATEDIFF(DAY,ArrivalDate,DepartureDate)*r.Price) DESC

--11
SELECT * FROM Bookings as b
JOIN Rooms as r on r.Id=b.RoomId
WHERE r.Id=2
GO
CREATE OR ALTER FUNCTION udf_RoomsWithTourists(@name NVARCHAR(50))
RETURNS INT AS
BEGIN
DECLARE @Count INT
SET @Count= (SELECT SUM(b.AdultsCount)+SUM(b.ChildrenCount) FROM Bookings as b
JOIN Rooms as r on r.Id=b.RoomId
WHERE r.Type=@name)
RETURN @Count
END

SELECT  dbo.udf_RoomsWithTourists('Double Room') 

--12
GO
CREATE OR ALTER PROC usp_SearchByCountry(@country NVARCHAR(50)) AS
SELECT t.Name,t.PhoneNumber,t.Email,COUNT(*) AS [CountOfBookings] FROM Tourists as t
JOIN Countries as c ON c.Id=t.CountryId
JOIN Bookings as b ON b.TouristId=t.Id
WHERE c.Name=@country
GROUP BY t.Name,t.Email,t.PhoneNumber