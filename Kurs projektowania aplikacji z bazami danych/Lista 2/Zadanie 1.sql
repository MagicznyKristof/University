DROP FUNCTION IF EXISTS ex_1
GO

CREATE FUNCTION ex_1(@number_of_days int) RETURNS TABLE
RETURN (SELECT
	PESEL AS PESEL, COUNT(W1.Wypozyczenie_ID) AS Specimen_number
	FROM	dbo.Wypozyczenie W1 JOIN 
			dbo.Czytelnik ON Czytelnik.Czytelnik_ID = W1.Czytelnik_ID JOIN
			dbo.Wypozyczenie W2 ON W1.Wypozyczenie_ID = W2.Wypozyczenie_ID
	WHERE	W2.Liczba_Dni >= @number_of_days
	GROUP BY PESEL)
GO

--SELECT * FROM dbo.ex_1(1)
--GO

SELECT
	*
	FROM	dbo.Wypozyczenie W1 JOIN 
			dbo.Czytelnik ON Czytelnik.Czytelnik_ID = W1.Czytelnik_ID JOIN
			dbo.Wypozyczenie W2 ON W1.Wypozyczenie_ID = W2.Wypozyczenie_ID
	WHERE	W2.Liczba_Dni >= 10
	--GROUP BY PESEL

SELECT
	*
	FROM	dbo.Wypozyczenie W1 JOIN 
			dbo.Czytelnik ON Czytelnik.Czytelnik_ID = W1.Czytelnik_ID --JOIN
			--dbo.Wypozyczenie W2 ON W1.Wypozyczenie_ID = W2.Wypozyczenie_ID
	WHERE	W1.Liczba_Dni >= 10