DROP PROCEDURE IF EXISTS ex_3
GO

DROP TYPE IF EXISTS Reader_IDs
GO

CREATE TYPE Reader_IDs AS TABLE (reader_id INT)
GO

CREATE PROCEDURE ex_3 @readers Reader_IDs READONLY AS
BEGIN
		SELECT 
			readers.reader_id AS reader_id, SUM(Wypozyczenie.Liczba_dni) AS sum_of_days
		FROM
			@readers AS readers JOIN
			Czytelnik ON Czytelnik.Czytelnik_ID = readers.reader_id JOIN
			Wypozyczenie ON Czytelnik.Czytelnik_ID = Wypozyczenie.Czytelnik_ID
		GROUP BY
			readers.reader_id
END
GO

DECLARE @reader_ids Reader_IDs
INSERT INTO @reader_ids VALUES(1)
INSERT INTO @reader_ids VALUES(2)
EXEC ex_3 @reader_ids
GO