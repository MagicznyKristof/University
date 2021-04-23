# BD SQL Lista 2
###### tags: `BD`

## Zadanie 1
```=sql
SELECT DISTINCT imie, nazwisko FROM uzytkownik
JOIN grupa ON grupa.kod_uz = uzytkownik.kod_uz
WHERE grupa.rodzaj_zajec = 'w'
AND grupa.kod_uz NOT IN
    (SELECT kod_uz FROM grupa
    JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
    JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
    WHERE przedmiot.rodzaj = 's');
```

```=sql
SELECT DISTINCT imie, nazwisko FROM uzytkownik
JOIN grupa g1 ON g1.kod_uz = uzytkownik.kod_uz
LEFT JOIN (SELECT g2.kod_uz FROM grupa g2
    JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem =    g2.kod_przed_sem
    JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
    WHERE przedmiot.rodzaj = 's') AA ON AA.kod_uz = g1.kod_uz
WHERE g1.rodzaj_zajec = 'w' AND AA.kod_uz IS NULL;
```

## Zadanie 2
```=sql
SELECT przedmiot.nazwa, COUNT(DISTINCT wybor.kod_uz) FROM przedmiot
LEFT JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed = przedmiot.kod_przed
LEFT JOIN grupa ON grupa.kod_przed_sem = przedmiot_semestr.kod_przed_sem
LEFT JOIN wybor ON wybor.kod_grupy = grupa.kod_grupy
WHERE przedmiot.rodzaj = 'k'
GROUP BY przedmiot.kod_przed, przedmiot.nazwa;
```

## Zadanie 3
```=sql
SELECT DISTINCT uzytkownik.kod_uz, imie, nazwisko FROM uzytkownik
JOIN grupa ON grupa.kod_uz = uzytkownik.kod_uz
JOIN wybor ON wybor.kod_grupy = grupa.kod_grupy
GROUP BY grupa.kod_grupy, grupa.max_osoby, imie, nazwisko, uzytkownik.kod_uz
HAVING COUNT(wybor.kod_uz) > grupa.max_osoby;
```

## Zadanie 4
```=sql
SELECT DISTINCT imie, nazwisko FROM uzytkownik
JOIN wybor ON wybor.kod_uz = uzytkownik.kod_uz
JOIN grupa ON grupa.kod_grupy = wybor.kod_grupy
JOIN przedmiot_semestr ps1 ON ps1.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = ps1.kod_przed
WHERE przedmiot.nazwa LIKE 'Algorytmy i struktury danych%' AND uzytkownik.kod_uz IN (SELECT wybor.kod_uz FROM wybor
    JOIN grupa ON grupa.kod_grupy = wybor.kod_grupy
    JOIN przedmiot_semestr ps2 ON ps2.kod_przed_sem = grupa.kod_przed_sem
    JOIN przedmiot ON przedmiot.kod_przed = ps2.kod_przed
    WHERE przedmiot.nazwa LIKE 'Matematyka dyskretna%' 
    AND ps2.semestr_id > ps1.semestr_id);
```

## Zadanie 5
```=sql
SELECT przedmiot.nazwa FROM przedmiot
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed = przedmiot.kod_przed
JOIN grupa ON grupa.kod_przed_sem = przedmiot_semestr.kod_przed_sem
JOIN wybor ON wybor.kod_grupy = grupa.kod_grupy
WHERE przedmiot.rodzaj = 'p' AND grupa.rodzaj_zajec = 'w'
GROUP BY przedmiot.nazwa, przedmiot.kod_przed
HAVING COUNT(DISTINCT wybor.kod_uz) >= ALL
    (SELECT COUNT(DISTINCT wybor.kod_uz) count FROM przedmiot
    JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed = przedmiot.kod_przed
    JOIN grupa ON grupa.kod_przed_sem = przedmiot_semestr.kod_przed_sem
    JOIN wybor ON wybor.kod_grupy = grupa.kod_grupy
    WHERE przedmiot.rodzaj = 'p' AND grupa.rodzaj_zajec = 'w'
    GROUP BY przedmiot.nazwa, przedmiot.kod_przed);
```

## Zadanie 6
```=sql
SELECT DISTINCT nazwisko, TMP.semestr_id FROM uzytkownik
JOIN wybor ON wybor.kod_uz = uzytkownik.kod_uz
JOIN (SELECT semestr.semestr_id, MIN(wybor.data) FROM semestr
    JOIN przedmiot_semestr ON przedmiot_semestr.semestr_id = semestr.semestr_id
    JOIN grupa ON grupa.kod_przed_sem = przedmiot_semestr.kod_przed_sem
    JOIN wybor ON wybor.kod_grupy = grupa.kod_grupy
    WHERE semestr.nazwa LIKE '%letni%'
    GROUP BY semestr.semestr_id) TMP ON wybor.data = TMP.min
ORDER BY semestr_id, nazwisko ASC;
```

## Zadanie 7
```=sql
SELECT AVG(TMP.liczba) FROM 
    (SELECT COUNT(wybor.kod_uz) AS "liczba" FROM semestr
    JOIN przedmiot_semestr ON przedmiot_semestr.semestr_id = semestr.semestr_id
    JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
    JOIN grupa ON grupa.kod_przed_sem = przedmiot_semestr.kod_przed_sem
    JOIN wybor ON wybor.kod_grupy = grupa.kod_grupy
    WHERE semestr.nazwa = 'Semestr letni 2016/2017'
    AND grupa.rodzaj_zajec = 'w'
    GROUP BY grupa.kod_grupy) TMP;
```

## Zadanie 8
```=sql
SELECT DISTINCT imie, nazwisko FROM uzytkownik
JOIN grupa g1 ON g1.kod_uz = uzytkownik.kod_uz
JOIN grupa g2 ON g2.kod_uz = uzytkownik.kod_uz
JOIN grupa g3 ON g3.kod_uz = uzytkownik.kod_uz
WHERE g1.rodzaj_zajec = 'w'
AND g2.rodzaj_zajec != 'w'
AND g3.rodzaj_zajec != 'w'
AND g2.kod_przed_sem = g1.kod_przed_sem
AND g3.kod_przed_sem = g1.kod_przed_sem
AND g2.kod_grupy != g3.kod_grupy;
```

## Zadanie 9
```=sql
WITH BD AS (SELECT DISTINCT uzytkownik.kod_uz FROM uzytkownik
    JOIN wybor ON wybor.kod_uz = uzytkownik.kod_uz
    JOIN grupa ON grupa.kod_grupy = wybor.kod_grupy
    JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
    JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
    JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
    WHERE przedmiot.nazwa = 'Bazy danych'
    AND semestr.nazwa = 'Semestr letni 2016/2017'),
SK AS (SELECT DISTINCT uzytkownik.kod_uz FROM uzytkownik
    JOIN wybor ON wybor.kod_uz = uzytkownik.kod_uz
    JOIN grupa ON grupa.kod_grupy = wybor.kod_grupy
    JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
    JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
    JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
    WHERE przedmiot.nazwa = 'Sieci komputerowe'
    AND semestr.nazwa = 'Semestr letni 2016/2017')
(SELECT * FROM BD WHERE kod_uz NOT IN (SELECT * FROM SK)) UNION
(SELECT * FROM SK WHERE kod_uz NOT IN (SELECT * FROM BD));
```







