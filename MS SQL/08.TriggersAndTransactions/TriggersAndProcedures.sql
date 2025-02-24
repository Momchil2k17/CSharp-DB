--1
CREATE Table Logs(
	LogId INT PRIMARY KEY Identity,
	AccountId INT NOT NULL,
	OldSum MONEY,
	NewSum MONEY,
)

GO
CREATE OR ALTER Trigger tr_OnUpdatedBalanceTrigger
ON Accounts FOR UPDATE
AS
	INSERT INTO Logs(AccountId,OldSum,NewSum)
	SELECT i.Id,d.Balance,i.Balance FROM inserted as i
	JOIN deleted as d ON
	i.Id=d.Id
	WHERE i.Balance<>d.Balance
GO

UPDATE Accounts
SET Balance=300
WHERE Id=1

SELECT * FROM Logs

--2
CREATE Table NotificationEmails(
	Id INT PRIMARY KEY Identity,
	Recipient  INT NOT NULL,
	[Subject] NVARCHAR(200) NOT NULL,
	Body NVARCHAR(300) NOT NULL,
)
GO
CREATE OR ALTER Trigger tr_LogEmailTrigger
ON Logs FOR INSERT
AS
	INSERT INTO NotificationEmails(Recipient,[Subject],Body)
	SELECT i.AccountId
		,CONCAT('Balance change for account: ',i.AccountId)
		,CONCAT('On ',GETDATE(),' your balance was changed from ',i.OldSum,' to ',i.NewSum,'.') FROM inserted as i
GO

SELECT * FROM Accounts
SELECT * FROM Logs
SELECT * FROM NotificationEmails
--3
GO
CREATE OR ALTER PROC usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(18,4)) 
AS
	IF(@MoneyAmount>0)
	BEGIN;
		UPDATE Accounts
		SET Balance+=@MoneyAmount
		WHERE Id=@AccountId
	END
GO
EXEC usp_DepositMoney 2, 10.1
select * from Accounts
WHERE id = 2

--4
GO
CREATE OR ALTER PROC usp_WithdrawMoney(@AccountId INT, @MoneyAmount DECIMAL(18,4)) 
AS
		UPDATE Accounts
		SET Balance-=@MoneyAmount
		WHERE Id=@AccountId AND Balance-@MoneyAmount>=0

EXEC usp_WithdrawMoney 2, 10.1
select * from Accounts
WHERE id = 2

--5
GO
CREATE OR ALTER PROC usp_TransferMoney(@SenderId INT,@ReceiverId INT, @MoneyAmount DECIMAL(18,4))
AS
	EXEC usp_WithdrawMoney @SenderId, @MoneyAmount
	 IF @@ROWCOUNT>0
		EXEC usp_DepositMoney @ReceiverId, @MoneyAmount
EXEC usp_TransferMoney 5, 1, 5000
SELECT * FROM Accounts WHERE Id = 1
SELECT * FROM Accounts WHERE Id = 5