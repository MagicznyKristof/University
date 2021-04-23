SET STATISTICS TIME ON

SELECT DISTINCT c.PESEL, c.Nazwisko
FROM Egzemplarz e
JOIN Ksiazka k ON e.Ksiazka_ID=k.Ksiazka_ID
JOIN Wypozyczenie w ON e.Egzemplarz_ID=w.Egzemplarz_ID
JOIN Czytelnik c ON c.Czytelnik_ID = w.Czytelnik_ID;
-- Tworzymy tabelê Egzemplarz x Ksi¹¿ka x Wypo¿yczenie x Czytelnik ³¹cz¹c po powtarzaj¹cych siê kluczach
-- na koniec wybieramy unikalne wiersze z dwóch kolumn

SELECT c.PESEL, c.Nazwisko
FROM Czytelnik c WHERE c.Czytelnik_ID IN
(SELECT w.Czytelnik_ID FROM Wypozyczenie w
JOIN Egzemplarz e ON e.Egzemplarz_ID=w.Egzemplarz_ID
JOIN Ksiazka k ON e.Ksiazka_ID=k.Ksiazka_ID)
-- Wybieramy pesele i nazwiska, gdzie ID czytelnika pokrywa siê z wynikiem podzapytania

SELECT c.PESEL, c.Nazwisko
FROM Czytelnik c WHERE c.Czytelnik_ID IN
	(SELECT w.Czytelnik_ID 
	FROM Wypozyczenie w WHERE w.Egzemplarz_ID IN
		(SELECT e.Egzemplarz_ID FROM Egzemplarz e
		JOIN Ksiazka k ON e.Ksiazka_ID=k.Ksiazka_ID))

SET STATISTICS TIME OFF