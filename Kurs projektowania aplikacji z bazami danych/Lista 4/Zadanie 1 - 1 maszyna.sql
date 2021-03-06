--POZIOM IZOLACJI		DIRTY READ		NONREAPEATABLE READ		PHANTOM
--READ UNCOMMITTED		TAK				TAK						TAK
--READ COMMITTED		NIE				TAK						TAK
--REPEATABLE READ		NIE				NIE						TAK
--SNAPSHOT				NIE				NIE						NIE
--SERIALIZABLE			NIE				NIE						NIE

--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
--SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

DROP TABLE IF EXISTS Zad_1
GO

CREATE TABLE Zad_1 (ID INT PRIMARY KEY, Product VARCHAR(50), Quantity INT)
INSERT INTO Zad_1 VALUES (1, 'a', 1)
INSERT INTO Zad_1 VALUES (2, 'ba', 6)
INSERT INTO Zad_1 VALUES (3, 'cba', 23)
INSERT INTO Zad_1 VALUES (4, 'dcba', 1265453)
INSERT INTO Zad_1 VALUES (5, 'edcba', 5)
INSERT INTO Zad_1 VALUES (6, 'fedcba', 16)
GO

--Dirty read
BEGIN TRAN
UPDATE Zad_1 SET Quantity = 12345 WHERE ID = 2
UPDATE Zad_1 SET Quantity = -10 WHERE ID = 5
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
SELECT * FROM Zad_1
GO

--Non-repeatable read
BEGIN TRAN
UPDATE Zad_1 SET Product = 'New name' WHERE ID = 1
UPDATE Zad_1 SET Product = 'Another new name' WHERE ID = 2
COMMIT
GO

--Phantom read
BEGIN TRAN
INSERT INTO Zad_1 VALUES (7, 'Im a phantom', 0)
COMMIT
GO

