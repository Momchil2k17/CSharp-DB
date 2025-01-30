-- 01 
CREATE TABLE Persons (
	PersonID INT NOT NULL,
	FirstName VARCHAR(64),
	Salary MONEY,
	PassportID INT
)

CREATE TABLE Passports (
	PassportID INT,
	PassportNumber VARCHAR(64) UNIQUE
)

INSERT INTO Passports
	VALUES (101, 'N34FG21B'), 
			 (102, 'K65LO4R7'), 
			 (103, 'ZE657QP2')


INSERT INTO Persons 
	VALUES (1, 'Roberto', 43300, 102),
			 (2, 'Tom', 56100, 103), 
			 (3, 'Yana', 60200, 101)

ALTER TABLE Persons
ALTER COLUMN PersonID INT NOT NULL

ALTER TABLE Persons
ADD CONSTRAINT PK_Persons_PersonID PRIMARY KEY(PersonID)

ALTER TABLE Passports
ALTER COLUMN PassportID INT NOT NULL

ALTER TABLE Passports
ADD CONSTRAINT PK_Passports_PassportID PRIMARY KEY(PassportID)


ALTER TABLE Persons
ADD CONSTRAINT FK_Persons_Passports_PassportID 
	FOREIGN KEY(PassportID) REFERENCES Passports(PassportID)

-- 
ALTER TABLE Persons
ADD CONSTRAINT UQ_Person_PassportID UNIQUE(PassportID)

--2

CREATE TABLE Manufacturers
(
	[ManufacturerID] INT PRIMARY KEY,
	[Name] NVARCHAR(40) NOT NULL,
	[EstablishedOn] DATE
)
CREATE TABLE Models
(
	[ModelId] INT PRIMARY KEY,
	[Name] NVARCHAR(40) NOT NULL,
	[ManufacturerID] INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers VALUES
			(1,'BMW','07/03/1916')
			,(2,'Tesla','01/01/2003')
			,(3,'Lada','01/05/1966')
INSERT INTO Models VALUES
			(101,'X1',1)
			,(102,'i6',1)
			,(103,'Model S',2)
			,(104,'Model X',2)
			,(105,'Model 3',2)
			,(106,'Nova',3)

--3
CREATE TABLE Students (
	StudentID INT NOT NULL PRIMARY KEY,
	Name NVARCHAR(64),
)

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY NOT NULL,
	Name  NVARCHAR(64)
)

INSERT INTO Students VALUES
		(1,'Mila')
		,(2,'Toni')
		,(3,'Ron')
INSERT INTO Exams VALUES
		(101,'SpringMVC')
		,(102,'Neo4j')
		,(103,'Oracle 11g')

CREATE TABLE StudentsExams
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID),
	CONSTRAINT PK_StudentsExams PRIMARY KEY(StudentID, ExamID)
)

--4
CREATE TABLE Teachers(
		TeacherID INT PRIMARY KEY,
		Name NVARCHAR(64),
		ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)
ALTER TABLE Teachers
ALTER Column Name NVARCHAR(64) NOT NULL

INSERT INTO Teachers VALUES
		(101,'John',NULL)
		,(102,'Maya',106)
		,(103,'Silvia',106)
		,(104,'Ted',105)
		,(105,'Mark',101)
		,(106,'Greta',101)

		SELECT * FROM Teachers


--5
CREATE TABLE ItemTypes(
		ItemTypeID INT PRIMARY KEY,
		Name NVARCHAR(50) NOT NULL
)

CREATE TABLE Items(
		ItemID INT PRIMARY KEY,
		Name NVARCHAR(50) NOT NULL,
		ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE Cities(
		CityID INT PRIMARY KEY,
		Name NVARCHAR(50) NOT NULL
)

CREATE TABLE Customers(
		CustomerID INT PRIMARY KEY,
		Name NVARCHAR(50) NOT NULL,
		Birthday DATE,
		CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders(
		OrderID INT PRIMARY KEY,
		CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE OrderItems(
		OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
		ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
		CONSTRAINT PK_OrderItems PRIMARY KEY(OrderID, ItemID)
)	


CREATE TABLE Majors
(
		MajorID INT PRIMARY KEY,
		NAME NVARCHAR(100) NOT NULL,
)
CREATE TABLE Students(
		StudentID INT PRIMARY KEY,
		StudentNumber INT NOT NULL,
		StudentName NVARCHAR(100) NOT NULL,
		MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Payments(
		PaymentID INT PRIMARY KEY,
		PaymentDate DATETIME2 NOT NULL,
		PaymentAmount MONEY NOT NULL,
		StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects(
		SubjectID INT PRIMARY KEY,
		SubjectName NVARCHAR(100) NOT NULL,
)

CREATE TABLE Agenda(
		StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
		SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID)
		CONSTRAINT PK_StudentsSubjects PRIMARY KEY(StudentID, SubjectID)
)

SELECT * FROM Mountains
SELECT * FROM Peaks


--9
SELECT m.MountainRange,p.PeakName,p.Elevation FROM Mountains as m
JOIN Peaks as p ON m.Id=p.MountainId
WHERE m.MountainRange='Rila'
ORDER BY p.Elevation DESC