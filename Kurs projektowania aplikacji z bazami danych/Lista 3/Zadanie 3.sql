DROP TABLE IF EXISTS Cache
DROP TABLE IF EXISTS History
DROP TABLE IF EXISTS Parameters
GO

CREATE TABLE Cache(ID INT IDENTITY PRIMARY KEY, UrlAddress VARCHAR(500), LastAccess DATETIME)
CREATE TABLE History(ID INT IDENTITY PRIMARY KEY, UrlAddress VARCHAR(500), LastAccess DATETIME)
CREATE TABLE Parameters(Name VARCHAR(500), Value INT)
GO

INSERT INTO Parameters VALUES ('max_cache', 3)
GO

DROP TRIGGER IF EXISTS z3MoveToHistory
GO

CREATE TRIGGER z3MoveToHistory ON Cache INSTEAD OF INSERT
AS
BEGIN
	DECLARE row_select CURSOR FOR SELECT UrlAddress, LastAccess FROM inserted
	DECLARE @url VARCHAR(500), @lastAccess DATETIME
	OPEN row_select
	FETCH row_select INTO @url, @lastAccess
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF EXISTS (SELECT 1 FROM Cache WHERE UrlAddress = @url)
			UPDATE Cache SET LastAccess = @lastAccess WHERE UrlAddress = @url
		ELSE
		BEGIN
			IF (SELECT COUNT(*) FROM Cache) < (SELECT Value FROM Parameters WHERE Name = 'max_cache')
				INSERT INTO Cache VALUES(@url, @lastAccess)
			ELSE
			BEGIN
				DECLARE @ReplacementID INT, @ReplacementUrl VARCHAR(500), @ReplacementAccess DATETIME
				SELECT TOP 1 @ReplacementID = ID, @ReplacementUrl = UrlAddress, @ReplacementAccess = LastAccess
					FROM Cache ORDER BY LastAccess
				IF EXISTS (SELECT 1 FROM History WHERE UrlAddress = @ReplacementUrl)
					UPDATE History SET LastAccess = @ReplacementAccess WHERE UrlAddress = @ReplacementUrl
				ELSE
					INSERT INTO History VALUES (@ReplacementUrl, @ReplacementAccess)
				DELETE FROM Cache WHERE ID = @ReplacementID
				INSERT INTO Cache VALUES(@url, @lastAccess)
			END
		END
		FETCH row_select INTO @url, @lastAccess
	END
	CLOSE row_select
	DEALLOCATE row_select
END
GO

INSERT INTO Cache VALUES('google.com',			'03/29/2020 11:30:00')
INSERT INTO Cache VALUES('google.com',			'03/29/2021 12:00:00')
INSERT INTO Cache VALUES('youtube.com',			'03/29/2021 17:00:00')
INSERT INTO Cache VALUES('facebook.com',		'03/29/2021 15:00:00')
INSERT INTO Cache VALUES('github.com',			'03/29/2021 13:30:00')
INSERT INTO Cache VALUES('google.com',			'03/29/2021 14:00:00')
GO

SELECT * FROM History
SELECT * FROM Cache
GO