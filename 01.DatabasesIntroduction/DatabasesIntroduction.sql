--1
CREATE DATABASE Minions

--2
CREATE TABLE [Minions](
	[Id] INT PRIMARY KEY NOT NULL,
	[Name] NVARCHAR(150) NOT NULL,
	[Age] INT
)

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY NOT NULL,
	[Name] NVARCHAR(100) NOT NULL
)
--3
ALTER TABLE [Minions]
ADD [TownId] INT

ALTER TABLE [Minions]
ADD CONSTRAINT [Fk_Minions_Town_Id]
FOREIGN KEY([TownId]) REFERENCES [Towns]([Id])
--4
INSERT INTO [Towns]([Id], [Name]) 
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')


INSERT INTO [Minions]([Id],[Name],[Age],[TownId])
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward',NULL,2)

--5
TRUNCATE TABLE [Minions]

--6
DROP TABLE Minions
DROP TABLE Towns

--7
CREATE TABLE [People]
(
	[Id] INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	[Height] DECIMAL(3,2),
	[Weight] DECIMAL(5,2),
	[Gender] CHAR(1) NOT NULL,
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX)
)
INSERT INTO People
VALUES ('Gosho', 'fasdfahsgdfusd', 1.70,65.50, 'm', '1992-04-30', 'fsdafjasdf'),
('Gosho', 'fasdfahsgdfusd', 1.70,65.50, 'm', '1992-04-30', 'fsdafjasdf'),
('Gosho', 'fasdfahsgdfusd', 1.70,65.50, 'm', '1992-04-30', 'fsdafjasdf'),
('Gosho', 'fasdfahsgdfusd', 1.70,65.50, 'm', '1992-04-30', 'fsdafjasdf'),
('Gosho', 'fasdfahsgdfusd', 1.70,65.50, 'm', '1992-04-30', 'fsdafjasdf')


--8
CREATE TABLE [Users]
(
	[Id] BIGINT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Username] VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARCHAR(MAX),
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT
)

INSERT INTO Users
VALUES ('Gosho11', 'paro','dgdggdfsdfg','01-01-1000', 0),
('Gosho1', 'parolka','dgdggdfsdfg','01-01-1000', 0),
('Gosho2', 'paro','dgdggdfsdfg','01-01-1000', 0),
('Gosho', 'parolka','dgdggdfsdfg','01-01-1000', 0),
('Gosho', 'parolka','dgdggdfsdfg','01-01-1000', 0)
DROP TABLE Users

--9
ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC0724F508B3

ALTER TABLE Users
ADD CONSTRAINT PK_Id_Username_Constraint PRIMARY KEY ([Id],[Username]);

--10
ALTER TABLE Users
ADD CONSTRAINT CHK_PasswordLength CHECK (LEN([Password])>=5)

--11
ALTER TABLE Users
ADD CONSTRAINT Default_LoginTime
DEFAULT GETDATE() FOR LastLoginTime

--13
CREATE DATABASE [Movies]

CREATE TABLE [Directors]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[DirectorName] NVARCHAR(150) NOT NULL,
	[Notes] NVARCHAR(500)
)

CREATE TABLE [Genres]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[GenreName] NVARCHAR(70) NOT NULL,
	[Notes] NVARCHAR(300)
)

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[CategoryName] NVARCHAR(70) NOT NULL,
	[Notes] NVARCHAR(300)
)

CREATE TABLE [Movies]
(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Title] NVARCHAR(100) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]),
	[CopyrightYear] INT NOT NULL,
	[Length] TIME NOT NULL,
	[GenreId] INT FOREIGN KEY REFERENCES Genres(Id),
	[CategoryId] INT FOREIGN KEY REFERENCES Categories(Id),
	[Rating] DECIMAL(3,2) NOT NULL,
	[Notes] NVARCHAR(100)
)

INSERT INTO Directors
VALUES ('Purvi Direktor', 'dsfasdgasdgdsa'),
('Vtori Direktor', 'dsfasdgasdgdsa'),
('Treti Direktor', 'dsfasdgasdgdsa'),
('Chetvurti Direktor', 'dsfasdgasdgdsa'),
('Peti Direktor', 'dsfasdgasdgdsa')

INSERT INTO Genres
VALUES ('Purvi Janr', 'dsfasdgasdgdsa'),
('Vtori Janr', 'dsfasdgasdgdsa'),
('Treti Janr', 'dsfasdgasdgdsa'),
('Chetvurti Janr', 'dsfasdgasdgdsa'),
('Peti Janr', 'dsfasdgasdgdsa')

INSERT INTO Categories
VALUES ('Purva Kategoriq', 'dsfasdgasdgdsa'),
('Vtora Kategoriq', 'dsfasdgasdgdsa'),
('Treta Kategoriq', 'dsfasdgasdgdsa'),
('Chetvurta Kategoriq', 'dsfasdgasdgdsa'),
('Peta Kategoriq', 'dsfasdgasdgdsa')

INSERT INTO Movies
VALUES ('Titanic1', 1, 1997, '03:15:00', 2, 3, 7.80, 'dsfasduifgasdufgg'),
('Titanic2', 2, 1997, '03:15:00', 3, 4, 7.80, 'dsfasduifgasdufgg'),
('Titanic3', 3, 1997, '03:15:00', 4, 5, 7.80, 'dsfasduifgasdufgg'),
('Titanic4', 4, 1997, '03:15:00', 5, 1, 7.80, 'dsfasduifgasdufgg'),
('Titanic5', 5, 1997, '03:15:00', 1, 2, 7.80, 'dsfasduifgasdufgg')

--14
CREATE DATABASE CarRental 
USE CarRental

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY,
CategoryName NVARCHAR(30) NOT NULL,
DailyRate DECIMAL(3,1) NOT NULL,
WeeklyRate DECIMAL(3,1) NOT NULL,
MonthlyRate DECIMAL(3,1) NOT NULL,
WeekendRate DECIMAL(3,1) NOT NULL
)

CREATE TABLE Cars
(
Id INT PRIMARY KEY IDENTITY,
PlateNumber INT NOT NULL,
Manufacturer NVARCHAR(30) NOT NULL,
Model NVARCHAR(30) NOT NULL,
CarYear INT NOT NULL,
CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
Doors INT NOT NULL,
Picture NVARCHAR(MAX) NOT NULL,
Condition NVARCHAR(30) NOT NULL,
Available BIT NOT NULL
)

CREATE TABLE Employees 
(
Id INT PRIMARY KEY IDENTITY, 
FirstName NVARCHAR(30) NOT NULL,
LastName NVARCHAR(30) NOT NULL, 
Title NVARCHAR(30) NOT NULL, 
Notes NVARCHAR(30) NOT NULL
)

CREATE TABLE Customers 
(
Id INT PRIMARY KEY IDENTITY, 
DriverLicenceNumber INT NOT NULL, 
FullName NVARCHAR(30) NOT NULL, 
[Address] NVARCHAR(30) NOT NULL, 
City NVARCHAR(30) NOT NULL, 
ZIPCode INT NOT NULL, 
Notes NVARCHAR(30) NOT NULL
)

CREATE TABLE RentalOrders 
(
Id INT PRIMARY KEY IDENTITY, 
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL, 
CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL, 
CarId INT FOREIGN KEY REFERENCES Cars(Id) NOT NULL, 
TankLevel INT NOT NULL, 
KilometrageStart DECIMAL(15,3) NOT NULL, 
KilometrageEnd DECIMAL(15,3) NOT NULL,
TotalKilometrage DECIMAL(15,3) NOT NULL, 
StartDate DATE NOT NULL, 
EndDate DATE NOT NULL, 
TotalDays INT NOT NULL, 
RateApplied DECIMAL(15,3), 
TaxRate DECIMAL(15,3), 
OrderStatus NVARCHAR(30), 
Notes NVARCHAR(MAX)
)

INSERT INTO Categories
VALUES ('Speedy', 11.1, 11.1,11.1, 11.1),
('Not So Speedy', 11.1, 11.1,11.1, 11.1),
('Not Speedy At All', 11.1, 11.1,11.1, 11.1)

INSERT INTO Cars
VALUES (1010120, 'BUGATI', 'asfasf',2000,1,2,'dfgasdgsdgasda', 'perfect', 1),
(1010101, 'BMW', 'asfasf',2000,2,4,'dfgasdgsdgasda', 'very perfect', 1),
(1031010, 'TOYOTA', 'asfasf',2000,3,6,'dfgasdgsdgasda', 'most perfect', 1)

INSERT INTO Employees
VALUES ('Georgi', 'Georgiev', 'Menidjur', 'dfgsdgasdgasd'),
('Pesho', 'Pesho', 'Ne e menidjur', 'dfgsdgasdgasd'),
('Petur', 'Petrov', 'Chistach', 'dfgsdgasdgasd')

INSERT INTO Customers
VALUES (51461, 'Ani', 'adress1', 'Sofia', 1231, 'Iskamkolichka'),
(2351235, 'Mimi', 'adress2', 'Plovdiv', 12312, 'Iskamkola'),
(5113461, 'Gabi', 'adress3', 'Varna', 1124, 'Iskam kolishte')

INSERT INTO RentalOrders
VALUES (1, 1, 1, 123, 2, 4, 20, '02-02-2020', '03-02-2020', 1, NULL, NULL, NULL, NULL),
	   (2, 2, 2, 123, 2, 4, 20, '02-02-2020', '03-02-2020', 1, NULL, NULL, NULL, NULL),
	   (3, 3, 3, 123, 2, 4, 20, '02-02-2020', '03-02-2020', 1, NULL, NULL, NULL, NULL)

--15
CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees
(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL, 
LastName NVARCHAR(30) NOT NULL, 
Title NVARCHAR(30) NOT NULL, 
Notes NVARCHAR(MAX)
)

CREATE TABLE Customers 
(
AccountNumber INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(30) NOT NULL, 
LastName NVARCHAR(30) NOT NULL,
PhoneNumber INT NOT NULL, 
EmergencyName NVARCHAR(30) NOT NULL, 
EmergencyNumber INT NOT NULL,
Notes NVARCHAR(MAX)
)

CREATE TABLE RoomStatus 
(
RoomStatus BIT NOT NULL,
Notes NVARCHAR(30)
)

CREATE TABLE RoomTypes 
(
RoomType NVARCHAR(30) NOT NULL,
Notes NVARCHAR(30)
)

CREATE TABLE BedTypes 
(
BedType NVARCHAR(30) NOT NULL, 
Notes NVARCHAR(30)
)

CREATE TABLE Rooms 
(
RoomNumber INT PRIMARY KEY IDENTITY,
RoomType NVARCHAR(30) NOT NULL,
BedType NVARCHAR(30) NOT NULL, 
Rate DECIMAL (3,1) NOT NULL,
RoomStatus NVARCHAR(30) NOT NULL, 
Notes NVARCHAR(30)
)

CREATE TABLE Payments
(
Id INT PRIMARY KEY IDENTITY,
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
PaymentDate DATE NOT NULL, 
AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
FirstDateOccupied DATE NOT NULL,
LastDateOccupied DATE NOT NULL, 
TotalDays INT NOT NULL, 
AmountCharged DECIMAL(15,2) NOT NULL, 
TaxRate DECIMAL(15,2) NOT NULL,  
TaxAmount DECIMAL(15,2) NOT NULL, 
PaymentTotal DECIMAL(15,2) NOT NULL, 
Notes NVARCHAR(1000)
)
CREATE TABLE Occupancies 
(
Id INT PRIMARY KEY IDENTITY, 
EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
DateOccupied DATE, 
AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber),
RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber),
RateApplied DECIMAL(15,2), 
PhoneCharge DECIMAL(15,2), 
Notes NVARCHAR(1000)
)

INSERT INTO Employees
VALUES ('Georgi','Georgiev','Hotelier', NULL),
('Georgi','Georgiev','Hotelier', NULL),
('Georgi','Georgiev','Hotelier', NULL)

INSERT INTO Customers
VALUES ('Petur','Petrov', 101010,'Panika', 191919,NULL),
('Petur','Petrov', 101010,'Panika', 191919,NULL),
('Petur','Petrov', 101010,'Panika', 191919,NULL)

INSERT INTO RoomStatus
VALUES (1,NULL),
(0,NULL),
(1,NULL)

INSERT INTO RoomTypes
VALUES ('Hubava', NULL),
('Hubava', NULL),
('Hubava', NULL)

INSERT INTO BedTypes
VALUES ('dvoino', NULL),
('edinichno', NULL),
('kingsize', NULL)

INSERT INTO Rooms
VALUES ('Hubava','dvoino',1,'gotova',NULL),
('Hubava','dvoino',1,'gotova',NULL),
('Hubava','dvoino',1,'gotova',NULL)

INSERT INTO Payments
VALUES (1, '02-02-2002', 3, '02-02-2002', '02-03-2002', 1, 2, 2, 2, 2, NULL),
	   (1, '02-02-2002', 3, '02-02-2002', '02-03-2002', 1, 2, 2, 2, 2, NULL),
	   (1, '02-02-2002', 3, '02-02-2002', '02-03-2002', 1, 2, 2, 2, 2, NULL)

INSERT INTO Occupancies
VALUES (1, '02-02-2002', 1, 1, 2, 123, NULL),
	   (1, '02-02-2002', 1, 1, 2, 123, NULL),
	   (1, '02-02-2002', 1, 1, 2, 123, NULL)

--16
CREATE DATABASE [SoftUni]
USE [SoftUni]

CREATE TABLE [Towns] 
(
	[Id] INT PRIMARY KEY IDENTITY, 
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Addresses 
(
	[Id] INT PRIMARY KEY IDENTITY, 
	[AddressText] NVARCHAR(50) NOT NULL, 
	[TownId] INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)

CREATE TABLE [Departments] 
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE [Employees] 
(
	[Id] INT PRIMARY KEY IDENTITY, 
	[FirstName] NVARCHAR(30) NOT NULL, 
	[MiddleName] NVARCHAR(30), 
	[LastName] NVARCHAR(30) NOT NULL,  
	[JobTitle] NVARCHAR(30) NOT NULL, 
	[DepartmentId] INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL, 
	[HireDate] DATE NOT NULL,
	[Salary] DECIMAL (7,2) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)

INSERT INTO Towns
VALUES ('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO Departments
VALUES ('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO Addresses
VALUES ('Purva Ulica' , 1),
('Vtora Ulica' , 2),
('Treta Ulica' , 3),
('Chetvurta Ulica' , 4)

INSERT INTO Employees
VALUES ('Ivan', 'Ivanov', 'Ivanov',	'.NET Developer',4,'2013-02-01',3500.00,1),
('Petar','Petrov','Petrov','Senior Engineer',1,'2004-03-02',4000.00,2),
('Maria', 'Petrova', 'Ivanova', 'Intern',5, '2016-08-28', 525.25,3),
('Georgi','Teziev','Ivanov','CEO',2,'2007-12-09',3000.00,4),
('Peter','Pan','Pan','Intern',3,'2016-08-28',599.88,4)


--19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--20
SELECT * FROM Towns ORDER BY Name
SELECT * FROM Departments ORDER BY Name
SELECT * FROM Employees ORDER BY Salary DESC

--21
SELECT Name FROM Towns  ORDER BY Name
SELECT Name FROM Departments ORDER BY Name
SELECT FirstName,LastName,JobTitle,Salary FROM Employees ORDER BY Salary DESC

UPDATE Employees
SET Salary=Salary*1.1
SELECT Salary FROM Employees



UPDATE Payments
SET TaxRate=TaxRate*0.97
SELECT TaxRate From Payments