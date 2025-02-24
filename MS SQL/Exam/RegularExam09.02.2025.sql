CREATE DATABASE EuroLeagues

--1
CREATE TABLE Leagues
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Players
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	Position NVARCHAR(20) NOT NULL
)


CREATE TABLE PlayerStats
(
	PlayerId INT FOREIGN KEY REFERENCES Players(Id) NOT NULL,
	Goals INT NOT NULL DEFAULT 0,
	Assists INT NOT NULL DEFAULT 0,
	PRIMARY KEY(PlayerId)
)

CREATE TABLE Teams
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) UNIQUE NOT NULL,
	City NVARCHAR(50)  NOT NULL,
	LeagueId INT FOREIGN KEY REFERENCES Leagues(Id) NOT NULL
)

CREATE TABLE PlayersTeams
(
	PlayerId INT FOREIGN KEY REFERENCES Players(Id) NOT NULL,
	TeamId INT FOREIGN KEY REFERENCES Teams(Id) NOT NULL,
	PRIMARY KEY(PlayerId,TeamId)
)

CREATE TABLE TeamStats
(
	TeamId INT FOREIGN KEY REFERENCES Teams(Id) NOT NULL,
	Wins INT NOT NULL DEFAULT 0,
	Draws INT NOT NULL DEFAULT 0,
	Losses INT NOT NULL DEFAULT 0,
	PRIMARY KEY(TeamId)
)

CREATE TABLE Matches
(
	Id INT PRIMARY KEY IDENTITY,
	HomeTeamId INT FOREIGN KEY REFERENCES Teams(Id) NOT NULL,
	AwayTeamId INT FOREIGN KEY REFERENCES Teams(Id) NOT NULL,
	MatchDate DATETIME2 NOT NULL,
	HomeTeamGoals INT NOT NULL DEFAULT 0,
	AwayTeamGoals INT NOT NULL DEFAULT 0,
	LeagueId INT FOREIGN KEY REFERENCES Leagues(Id) NOT NULL
)

--2
INSERT INTO Leagues VALUES
('Eredivisie')

INSERT INTO Teams VALUES
('PSV',	'Eindhoven',	6),
('Ajax',	'Amsterdam',	6)

INSERT INTO Players VALUES
('Luuk de Jong',	'Forward'),
('Josip Sutalo',	'Defender')

INSERT INTO Matches VALUES
(98,	97,	'2024-11-02 20:45:00',	3,	2,	6)

INSERT INTO PlayersTeams VALUES
(2305,	97),
(2306,	98)

INSERT INTO PlayerStats VALUES
(2305,	2,	0),
(2306,	2,	0)

INSERT INTO TeamStats VALUES
(97,	15,	1,	3),
(98,	14,	3,	2)


--3
UPDATE PlayerStats
SET Goals=ps.Goals+1 FROM Leagues as l
JOIN Teams as t on l.Id=t.LeagueId
JOIN PlayersTeams as pt ON t.Id=pt.TeamId
JOIN Players AS p on p.Id=pt.PlayerId
JOIN PlayerStats as ps on ps.PlayerId=p.Id
WHERE l.Name='La Liga' AND p.Position='Forward'

--4
DELETE FROM PlayerStats
WHERE PlayerId IN (SELECT Id FROM Players WHERE Name IN ('Luuk de Jong','Josip Sutalo'))

DELETE FROM PlayersTeams
WHERE PlayerId IN (SELECT Id  FROM Players WHERE Name IN ('Luuk de Jong','Josip Sutalo'))

DELETE FROM Players 
WHERE Name IN ('Luuk de Jong','Josip Sutalo')

--5
SELECT * FROM(
SELECT FORMAT(MatchDate, 'yyyy-MM-dd') AS [MatchDate]
,HomeTeamGoals
,AwayTeamGoals
,HomeTeamGoals+AwayTeamGoals AS [TotalGoals] FROM Matches) as t1
WHERE TotalGoals>=5
ORDER BY TotalGoals DESC,MatchDate

--6
SELECT p.Name,t.City FROM Players as p
JOIN PlayersTeams as pt on pt.PlayerId=p.Id
JOIN Teams as t on pt.TeamId=t.Id
WHERE p.Name LIKE '%Aaron%'
ORDER BY p.Name

--7
SELECT p.Id,p.Name,p.Position FROM Players as p
JOIN PlayersTeams as pt on pt.PlayerId=p.Id
JOIN Teams as t on pt.TeamId=t.Id
WHERE t.City='London'
ORDER BY p.Name

--8
SELECT TOP 10 t1.Name AS [HomeTeamName],t2.Name AS [AwayTeamName],l.Name AS [LeagueName],FORMAT(m.MatchDate, 'yyyy-MM-dd') As [MatchDate] FROM Matches as m
JOIN Teams as t1 ON t1.Id=m.HomeTeamId
JOIN Teams as t2 ON t2.Id=m.AwayTeamId
JOIN Leagues as l on l.Id=m.LeagueId AND l.Id%2=0
WHERE m.MatchDate BETWEEN '2024/9/1' AND '2024/9/15'
ORDER BY m.MatchDate,t1.Name

--9
SELECT m.AwayTeamId,t.Name,SUM(AwayTeamGoals) AS [TotalAwayGoals] FROM Matches as m
JOIN Teams as t on m.AwayTeamId=t.Id
GROUP BY m.AwayTeamId,t.Name
HAVING SUM(AwayTeamGoals)>=6
ORDER BY SUM(AwayTeamGoals) DESC,t.Name ASC

--10
SELECT l.Name AS [LeagueName],ROUND((SUM(AwayTeamGoals)+SUM(HomeTeamGoals))/CAST(COUNT(*) as FLOAT),2) AS AvgScoringRate FROM Matches as m
JOIN Leagues as l on l.Id=m.LeagueId
GROUP BY l.Name
ORDER BY AvgScoringRate DESC

--11
GO
CREATE OR ALTER FUNCTION udf_LeagueTopScorer (@name NVARCHAR(50))
RETURNS TABLE AS
RETURN 
SELECT Name,Goals FROM(
SELECT p.Name,ps.Goals,DENSE_RANK() OVER (ORDER BY ps.Goals DESC) AS r FROM Leagues as l
JOIN Teams as t ON t.LeagueId=l.Id
JOIN PlayersTeams as pt on pt.TeamId=t.Id
JOIN Players as p ON p.Id=pt.PlayerId
JOIN PlayerStats as ps oN ps.PlayerId=p.Id
WHERE l.Name=@name)  as t1
WHERE r=1

--12
GO
CREATE OR ALTER PROC usp_SearchTeamsByCity (@name NVARCHAR(50) ) AS
SELECT t.Name,l.Name,t.City FROM Teams as t
JOIN Leagues as l on l.Id=t.LeagueId
WHERE t.City=@name
ORDER BY t.Name asc
