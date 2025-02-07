--1
SELECT *,COUNT(*) AS [Number Of Users] FROM (
SELECT SUBSTRING(Email,CHARINDEX('@',Email)+1,LEN(Email)-CHARINDEX('@',Email)) AS [Email Provider] FROM Users) as t1
GROUP BY [Email Provider]
ORDER BY [Number Of Users] DESC,[Email Provider]

--2
SELECT g.Name,gt.Name,u.Username,ug.Level,ug.Cash,c.Name FROM Games as g
LEFT JOIN UsersGames AS ug
ON g.Id=ug.GameId
LEFT Join Users as u
ON u.Id=ug.UserId
JOIN GameTypes as gt
ON gt.Id=g.GameTypeId
JOIN Characters as c
ON c.Id=ug.CharacterId
ORDER BY ug.Level DESC,u.Username,g.Name


--3
SELECT * FROM(
SELECT u.Username,g.Name,COUNT(*) AS [Items Count],SUM(i.Price) AS [Items Price]FROM Games as g
LEFT JOIN UsersGames AS ug
ON g.Id=ug.GameId
LEFT Join Users as u
ON u.Id=ug.UserId
JOIN GameTypes as gt
ON gt.Id=g.GameTypeId
JOIN Characters as c
ON c.Id=ug.CharacterId
JOIN UserGameItems as ugt
ON ugt.UserGameId=gt.Id
JOIN Items as i
ON ugt.ItemId=i.Id
GROUP BY u.Username,g.Name)
as f
WHERE [Items Count]>=10
ORDER BY [Items Count] DESC,[Items Price] DESC,Username
SELECT * FROM(
SELECT  u.Username,g.Name,COUNT(*) AS [Items Count],SUM(i.Price) AS [Items Price] FROM Users as u
JOIN UsersGames as ug
ON ug.UserId=u.Id
JOIN Games as g
ON g.Id=ug.GameId
JOIN UserGameItems as ugt
ON ugt.UserGameId=ug.Id
JOIN Items as i ON i.Id=ugt.ItemId
GROUP BY u.Username,g.Name) as f
WHERE [Items Count]>=10
ORDER BY [Items Count] DESC,[Items Price] DESC,Username