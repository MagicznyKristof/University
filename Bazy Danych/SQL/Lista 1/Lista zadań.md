# BD SQL Lista 1
###### tags: `BD`

## Zadanie 1
```=sql
SELECT nazwisko FROM uzytkownik
JOIN grupa ON grupa.kod_uz = uzytkownik.kod_uz
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE semestr.nazwa = 'Semestr zimowy 2017/2018'
AND przedmiot.nazwa = 'Matematyka dyskretna (M)' AND grupa.rodzaj_zajec='c';
```

## Zadanie 2

```=sql
SELECT imie, nazwisko FROM uzytkownik
JOIN wybor ON wybor.kod_uz = uzytkownik.kod_uz
JOIN grupa ON grupa.kod_grupy = wybor.kod_grupy
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE przedmiot.nazwa = 'Matematyka dyskretna (M)' AND grupa.rodzaj_zajec = 'w' AND semestr.nazwa = 'Semestr zimowy 2017/2018'
ORDER BY wybor.data ASC
FETCH FIRST 1 ROWS ONLY;
```

## Zadanie 3

```=sql
SELECT w2.data-w1.data FROM uzytkownik
JOIN wybor w1 ON w1.kod_uz = uzytkownik.kod_uz
JOIN wybor w2 ON w2.kod_grupy = w1.kod_grupy
JOIN grupa ON grupa.kod_grupy = w1.kod_grupy
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE przedmiot.nazwa = 'Matematyka dyskretna (M)' AND grupa.rodzaj_zajec = 'w'
AND semestr.nazwa = 'Semestr zimowy 2017/2018'
ORDER BY w1.data ASC, w2.data DESC
FETCH FIRST 1 ROWS ONLY;
```

## Zadanie 4
```=sql
SELECT COUNT(DISTINCT przedmiot.nazwa) FROM przedmiot
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed = przedmiot.kod_przed
JOIN grupa ON grupa.kod_przed_sem = przedmiot_semestr.kod_przed_sem
WHERE przedmiot.rodzaj = 'o' AND grupa.rodzaj_zajec = 'e';
```

## Zadanie 5
```=sql
SELECT COUNT(DISTINCT uzytkownik.kod_uz) FROM uzytkownik
JOIN grupa ON uzytkownik.kod_uz = grupa.kod_uz
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE semestr.nazwa LIKE '%zimowy%'
AND przedmiot.rodzaj = 'o' AND grupa.rodzaj_zajec='c';
```

## Zadanie 6
```=sql
SELECT przedmiot.nazwa FROM uzytkownik
JOIN grupa ON uzytkownik.kod_uz = grupa.kod_uz
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE uzytkownik.nazwisko = 'Urban' 
ORDER BY przedmiot.nazwa ASC;
```

## Zadanie 7
```=sql
SELECT COUNT(*) FROM uzytkownik WHERE uzytkownik.nazwisko LIKE 'Kabacki%';
```

## Zadanie 8
```=sql
SELECT COUNT(DISTINCT uzytkownik.kod_uz) FROM uzytkownik
JOIN wybor w1 ON w1.kod_uz = uzytkownik.kod_uz
JOIN grupa g1 ON g1.kod_grupy = w1.kod_grupy
JOIN przedmiot_semestr ps1 ON ps1.kod_przed_sem = g1.kod_przed_sem
JOIN przedmiot p1 ON p1.kod_przed = ps1.kod_przed
JOIN wybor w2 ON w2.kod_uz = uzytkownik.kod_uz
JOIN grupa g2 ON g2.kod_grupy = w2.kod_grupy
JOIN przedmiot_semestr ps2 ON ps2.kod_przed_sem = g2.kod_przed_sem
JOIN przedmiot p2 ON p2.kod_przed = ps2.kod_przed
WHERE p1.nazwa = 'Algorytmy i struktury danych (M)'
AND p2.nazwa = 'Algorytmy i struktury danych (M)'
AND ps1.semestr_id != ps2.semestr_id;
```

## Zadanie 9
```=sql
SELECT semestr.nazwa FROM semestr
JOIN przedmiot_semestr ON przedmiot_semestr.semestr_id = semestr.semestr_id
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
WHERE przedmiot.rodzaj = 'o'
GROUP BY semestr.nazwa
HAVING COUNT(przedmiot.kod_przed) > 0
ORDER BY COUNT(przedmiot.kod_przed) ASC
FETCH FIRST 1 ROWS ONLY;
```

## Zadanie 10
```=sql
SELECT COUNT(*) FROM semestr
JOIN przedmiot_semestr ON przedmiot_semestr.semestr_id = semestr.semestr_id
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN grupa ON grupa.kod_przed_sem = przedmiot_semestr.kod_przed_sem
WHERE przedmiot.nazwa = 'Logika dla informatyków' AND semestr.nazwa = 'Semestr zimowy 2017/2018'
AND (grupa.rodzaj_zajec = 'c' OR grupa.rodzaj_zajec = 'C');
```

## Zadanie 11
```=sql
SELECT semestr.nazwa FROM semestr
JOIN przedmiot_semestr ON przedmiot_semestr.semestr_id = semestr.semestr_id
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
WHERE przedmiot.rodzaj = 'o'
GROUP BY semestr.nazwa
HAVING COUNT(przedmiot.kod_przed) > 0
ORDER BY COUNT(przedmiot.kod_przed) DESC
FETCH FIRST 1 ROWS ONLY;
```

## Zadanie 12
```=sql
SELECT COUNT(*) FROM przedmiot WHERE nazwa LIKE '%(ang.)';
```

## Zadanie 13
```=sql
SELECT w1.data, w2.data FROM uzytkownik
JOIN wybor w1 ON w1.kod_uz = uzytkownik.kod_uz
JOIN wybor w2 ON w2.kod_grupy = w1.kod_grupy
JOIN grupa ON grupa.kod_grupy = w1.kod_grupy
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE semestr.nazwa = 'Semestr zimowy 2016/2017'
ORDER BY w1.data ASC, w2.data DESC
FETCH FIRST 1 ROWS ONLY;
```

## Zadanie 14
```=sql
SELECT COUNT(*) FROM przedmiot
LEFT JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed = przedmiot.kod_przed
WHERE przedmiot.rodzaj='k' AND przedmiot_semestr.kod_przed IS NULL;
```

## Zadanie 15
```=sql
SELECT COUNT(*) FROM uzytkownik
JOIN grupa ON grupa.kod_uz = uzytkownik.kod_uz
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE uzytkownik.imie = 'Przemysława' AND uzytkownik.nazwisko = 'Kanarek' AND
(grupa.rodzaj_zajec='r' OR grupa.rodzaj_zajec='R');
```

## Zadanie 16
```=sql
SELECT COUNT(*) FROM uzytkownik
JOIN grupa ON grupa.kod_uz = uzytkownik.kod_uz
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
JOIN przedmiot ON przedmiot.kod_przed = przedmiot_semestr.kod_przed
JOIN semestr ON semestr.semestr_id = przedmiot_semestr.semestr_id
WHERE uzytkownik.imie LIKE 'W%' AND uzytkownik.nazwisko = 'Charatonik' AND
przedmiot.nazwa LIKE 'Logika dla informatyków%';
```

## Zadanie 17
```=sql
SELECT COUNT(DISTINCT uzytkownik.kod_uz) FROM uzytkownik
JOIN wybor w1 ON w1.kod_uz = uzytkownik.kod_uz
JOIN grupa g1 ON g1.kod_grupy = w1.kod_grupy
JOIN przedmiot_semestr ps1 ON ps1.kod_przed_sem = g1.kod_przed_sem
JOIN przedmiot p1 ON p1.kod_przed = ps1.kod_przed
JOIN wybor w2 ON w2.kod_uz = uzytkownik.kod_uz
JOIN grupa g2 ON g2.kod_grupy = w2.kod_grupy
JOIN przedmiot_semestr ps2 ON ps2.kod_przed_sem = g2.kod_przed_sem
JOIN przedmiot p2 ON p2.kod_przed = ps2.kod_przed
WHERE p1.nazwa = 'Bazy danych'
AND p2.nazwa = 'Bazy danych'
AND ps1.semestr_id < ps2.semestr_id;
```

## Zadanie 18
```=sql
SELECT uzytkownik.kod_uz, COUNT(DISTINCT przedmiot_semestr.semestr_id) FROM uzytkownik 
JOIN wybor ON wybor.kod_uz = uzytkownik.kod_uz
JOIN grupa ON grupa.kod_grupy = wybor.kod_grupy
JOIN przedmiot_semestr ON przedmiot_semestr.kod_przed_sem = grupa.kod_przed_sem
GROUP BY uzytkownik.kod_uz
HAVING COUNT(DISTINCT przedmiot_semestr.semestr_id) = (SELECT COUNT(*) FROM semestr);
```
