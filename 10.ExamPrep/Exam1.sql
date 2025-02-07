CREATE Database LibraryDb


--1
CREATE TABLE Genres
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL
)
 
CREATE TABLE Contacts
(
	Id INT PRIMARY KEY IDENTITY,
	Email NVARCHAR(100),
	PhoneNumber NVARCHAR(20),
	PostAddress NVARCHAR(200),
	Website NVARCHAR(50),
)

CREATE TABLE Authors
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(100) NOT NULL,
	ContactId INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL
)

CREATE TABLE Libraries
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50) NOT NULL,
	ContactId INT FOREIGN KEY REFERENCES Contacts(Id) NOT NULL
)

CREATE TABLE Books
(
	Id INT PRIMARY KEY IDENTITY,
	Title NVARCHAR(100) NOT NULL,
	YearPublished INT NOT NULL,
	ISBN NVARCHAR(13) UNIQUE NOT NULL,
	AuthorId INT FOREIGN KEY REFERENCES Authors(Id) NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL
)

CREATE TABLE LibrariesBooks
(
	LibraryId INT FOREIGN KEY REFERENCES Libraries(Id) NOT NULL,
	BookId INT FOREIGN KEY REFERENCES Books(Id) NOT NULL,
	PRIMARY KEY(LibraryId,BookId)
)

--2
INSERT INTO Contacts VALUES
(NULL,NULL,NULL,NULL),
(NULL,NULL,NULL,NULL),
('stephen.king@example.com','+4445556666','15 Fiction Ave, Bangor, ME','www.stephenking.com'),
('suzanne.collins@example.com'	,'+7778889999'	,'10 Mockingbird Ln, NY, NY',	'www.suzannecollins.com')

INSERT INTO Authors VALUES
('George Orwell',21),
('Aldous Huxley',	22),
('Stephen King'	,23),
('Suzanne Collins',	24)

INSERT INTO Books VALUES
('1984',	1949,	'9780451524935',	16,	2),
('Animal Farm',	1945,	'9780451526342'	,	16,	2),
('Brave New World',	1932,	'9780060850524',	17,	2),
('The Doors of Perception',	1954,	'9780060850531',	17,	2),
('The Shining',	1977,	'9780307743657',	18,	9),
('It',	1986,	'9781501142970',	18,	9),
('The Hunger Games',	2008,	'9780439023481',	19,	7),
('Catching Fire',	2009,	'9780439023498',	19,	7),
('Mockingjay',	2010,	'9780439023511',	19,	7)

INSERT INTO LibrariesBooks VALUES
(1,	36),
(1,	37),
(2,38),
(2,39),
(3,40),
(3,41),
(4,42),
(4,43),
(5,44)

--3
UPDATE Contacts
SET Website= 'www.'+LOWER(REPLACE(a.Name,' ',''))+'.com' FROM Contacts as c
JOIN Authors as a ON a.ContactId=c.Id
WHERE c.Website IS NULL

SELECT * FROM Contacts

--4
SELECT Id FROM Authors WHERE
Name='Alex Michaelides' 
SELECT Id FROM Books
WHERE AuthorId IN (SELECT Id FROM Authors WHERE
Name='Alex Michaelides' )
--DELETING FROM LB
DELETE FROM LibrariesBooks
WHERE BookId IN (SELECT Id FROM Books
WHERE AuthorId IN (SELECT Id FROM Authors WHERE
Name='Alex Michaelides' ))

DELETE FROM Books
WHERE AuthorId IN (SELECT Id FROM Authors WHERE
Name='Alex Michaelides')

DELETE FROM Authors 
WHERE Name='Alex Michaelides'

DROP DATABASE LibraryDb
--5
SELECT Title as [Book Title],ISBN,YearPublished AS [YearReleased] FROM Books
ORDER BY YearPublished DESC,Title

--6
SELECT b.Id,b.Title,b.ISBN,g.Name AS [Genre] FROM Books as b
JOIN Genres as g ON b.GenreId=g.Id
WHERE g.Name IN ('Biography','Historical Fiction' )
ORDER BY g.Name,b.Title

--7
SELECT DISTINCT Library,Email FROM(
SELECT DISTINCT l.Name AS [Library],c.Email,g.Name FROM Libraries as l
JOIN LibrariesBooks as lb ON l.Id=lb.LibraryId
JOIN Books as b ON b.Id=lb.BookId
JOIN Genres as g ON b.GenreId=g.Id
JOIN Contacts as c ON c.Id=l.ContactId
GROUP BY l.Name,c.Email,g.Name) as f
WHERE Name!='Mystery' AND [Library] NOT IN (SELECT DISTINCT l.Name AS [Library]FROM Libraries as l
JOIN LibrariesBooks as lb ON l.Id=lb.LibraryId
JOIN Books as b ON b.Id=lb.BookId
JOIN Genres as g ON b.GenreId=g.Id
JOIN Contacts as c ON c.Id=l.ContactId
WHERE g.Name='Mystery')
ORDER BY Library

--8
SELECT TOP(3) Title,YearPublished AS [Year],g.Name as [Genre] FROM Books as b
JOIN Genres as g ON g.Id=b.GenreId
WHERE (b.YearPublished>2000 AND b.Title LIKE '%a%') OR (b.YearPublished<1950 AND g.Name LIKE '%Fantasy%')
ORDER BY Title,YearPublished DESC

--9
SELECT a.Name as [Author],c.Email,c.PostAddress as [Address] FROM Authors as a
JOIN Contacts as c
ON a.ContactId=c.Id
WHERE C.PostAddress LIKE '%, UK'
ORDER BY Author

--10
SELECT a.Name as [Author],b.Title,l.Name AS [Library],c.PostAddress as [Library Address] FROM Libraries as l
JOIN Contacts as c ON l.ContactId=c.Id
JOIN LibrariesBooks as lb ON lb.LibraryId=l.Id
JOIN Books as b on b.Id=lb.BookId
JOIN Authors as a on a.Id=b.AuthorId
JOIN Genres as g ON g.Id=b.GenreId
WHERE c.PostAddress LIKE '%Denver%' AND G.Name='Fiction'
ORDER BY b.Title

--11
GO
CREATE OR ALTER FUNCTION udf_AuthorsWithBooks(@name NVARCHAR(100)) 
RETURNS INT AS
BEGIN
DECLARE @Count INT
SET @Count=(SELECT COUNT(b.Id) FROM Books as b
JOIN Authors as a ON a.Id=b.AuthorId
JOIN LibrariesBooks as lb on lb.BookId=b.Id
JOIN Libraries as l on l.Id=lb.LibraryId
WHERE a.Name=@name
GROUP BY a.Name)
RETURN @Count
END
GO

SELECT  dbo.udf_AuthorsWithBooks('J.K. Rowling')

--12
GO 
CREATE OR ALTER PROC usp_SearchByGenre(@genreName NVARCHAR(30))
AS
	SELECT b.Title,b.YearPublished AS [Year],b.ISBN,a.Name AS [Author],g.Name AS [Genre] FROM Books as b
	JOIN Genres as g on g.Id=b.GenreId
	JOIN Authors as a ON a.Id=b.AuthorId
	WHERE g.Name=@genreName
	ORDER BY b.Title

--13

GO
CREATE OR ALTER FUNCTION udf_GenreFilter(@genre NVARCHAR(30)) 
RETURNS TABLE AS
RETURN
SELECT b.Id AS [BookId],b.Title,b.YearPublished AS [Year],b.ISBN,a.Name AS [Author],l.Name AS [Library] FROM Books as b
	JOIN Genres as g on g.Id=b.GenreId
	JOIN Authors as a ON a.Id=b.AuthorId
	JOIN LibrariesBooks as lb ON lb.BookId=b.Id
	JOIN Libraries as l on lb.LibraryId=l.Id
	WHERE g.Name=@genre

GO
SELECT * FROM dbo.udf_GenreFilter('Fiction')
