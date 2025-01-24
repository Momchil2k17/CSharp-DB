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