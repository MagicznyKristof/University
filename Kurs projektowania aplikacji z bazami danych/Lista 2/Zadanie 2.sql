DROP TABLE IF EXISTS firstnames
GO

CREATE TABLE firstnames (id INT PRIMARY KEY, firstname CHAR(20))
GO

INSERT INTO firstnames VALUES(1, 'adam')
INSERT INTO firstnames VALUES(2, 'bartosz')
INSERT INTO firstnames VALUES(3, 'celina')
INSERT INTO firstnames VALUES(4, 'dawid')
INSERT INTO firstnames VALUES(5, 'ewa')
INSERT INTO firstnames VALUES(6, 'franek')
INSERT INTO firstnames VALUES(7, 'grzegorz')
INSERT INTO firstnames VALUES(8, 'halina')
INSERT INTO firstnames VALUES(9, 'iga')
INSERT INTO firstnames VALUES(10, 'janina')
GO

DROP TABLE IF EXISTS lastnames
GO

CREATE TABLE lastnames (id INT PRIMARY KEY, lastname CHAR(20))
GO

INSERT INTO lastnames VALUES(1, 'abacki')
INSERT INTO lastnames VALUES(2, 'babacki')
INSERT INTO lastnames VALUES(3, 'cabacki')
INSERT INTO lastnames VALUES(4, 'dabacki')
INSERT INTO lastnames VALUES(5, 'eabacki')
INSERT INTO lastnames VALUES(6, 'fabacki')
INSERT INTO lastnames VALUES(7, 'gabacki')
INSERT INTO lastnames VALUES(8, 'habacki')
INSERT INTO lastnames VALUES(9, 'iabacki')
INSERT INTO lastnames VALUES(10, 'jabacki')
GO

DROP PROCEDURE IF EXISTS ex_2
GO

CREATE PROCEDURE ex_2 @n INT AS
BEGIN
	DROP TABLE IF EXISTS fldata

	CREATE TABLE fldata (firstname CHAR(20), lastname CHAR(20))

	DECLARE @firstname_count	INT
	DECLARE @lastname_count		INT
	SET @firstname_count =	(SELECT COUNT(id) FROM dbo.firstnames)
	SET @lastname_count =	(SELECT COUNT(id) FROM dbo.lastnames)

	IF(@n > @firstname_count * @lastname_count)
		THROW 50001, 'n is bigger than the number of all possible combinations', 1
	ELSE
		WHILE(@n > 0)
		BEGIN
			DECLARE @firstname	CHAR(20)
			DECLARE @lastname	CHAR(20)
			SET @firstname =	(SELECT TOP 1 firstname FROM dbo.firstnames ORDER BY NEWID())
			SET @lastname =	(SELECT TOP 1 lastname FROM dbo.lastnames ORDER BY NEWID())

			IF NOT EXISTS (SELECT * FROM fldata WHERE firstname = @firstname AND lastname = @lastname)
			BEGIN
				INSERT INTO fldata VALUES(@firstname, @lastname)
				SET @n = @n - 1
			END

		END
	SELECT * FROM fldata
END
GO

--EXEC ex_2 @n = 10
EXEC ex_2 @n = 100
--EXEC ex_2 @n = 101
GO


SELECT * FROM fldata