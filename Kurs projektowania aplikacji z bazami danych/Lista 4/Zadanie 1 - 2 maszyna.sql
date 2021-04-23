SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

--Dirty read
SELECT * FROM Zad_1

--Non-repeatable read i phantom read
BEGIN TRAN
SELECT * FROM Zad_1
WAITFOR DELAY '00:00:10'
SELECT * FROM Zad_1
ROLLBACK TRANSACTION