# BD Lista 2
###### tags: `BD`

## Zadanie 2
Musimy napisać zapytanie, które zwróci wszystkie elementy Z, których nie ma w A. Mamy więc:
$\{z \mid (\exists x) S(x, z) \wedge \neg (\exists b, c) R(z, b, c)\}$

## Zadanie 3
1. Szukamy największych elementów z A będących w relacji R.
Jest to zapytanie niezależne od dziedziny (no chyba że możemy zrobić np $a'$ puste?)
$\pi_{A}(R) \backslash \sigma_{R.A < R2.A2} ((\pi_{A} R) \times \rho_{R2 (A2)} (\pi_{A} R))$

2. Szukamy takich par z C, które razem są w relacji ze wszystkimi elementami B (tzn. każdy element B w relacji T jest w relacji z co najmniej jednym z tych elementów).
Jest to zapytanie zależne od dziedziny - jeśli np. $(\forall c)(T(c, a))$ to $b$ będzie mogło być czymkolwiek.

## Zadanie 4
1. Nie istnieje taki bar, że osoba do niego chodzi i nie lubi wszystkich soków w nim podawanych. - FAŁSZ - co jeśli w barze nie podają żadnego soku?
2. Nie istnieje taki bar, że osoba do niego chodzi i lubi wszystkie soki w nim podawane - FAŁSZ - oczywiste
3. Jeśli osoba chodzi do baru, to w tym barze podaje się co najmniej jeden sok, który ona lubi - PRAWDA
4. Osoba chodzi do wszystkich barów i w każdym barze istnieje sok, który ona lubi - FAŁSZ, osoba nie musi chodzić do wszystkich barów

## Zadanie 5
1. Istnieje bar $b$, do którego osoba chodzi i nie istnieje bar $b'$ do którego osoba chodzi - FAŁSZ
2. Istnieje bar do którego chodzi osoba - FAŁSZ
3. Istnieje bar, do którego chodzi osoba i nie istnieje INNY bar, do którego osoba chodzi - PRAWDA
4. To samo co 3., tylko dłuższe - PRAWDA

## Zadanie 6
1. $\{p, i, naz, nar, r \mid A(p, i, naz, nar, r) \wedge(\exists id, pos, ga) (R(p, id, pos, ga)) \wedge \neg (\exists idf1, idf2, t1, t2, rez1,$$rez2, rok1, rok2, cz1, cz2)(F(idf1, t1, rez1, rok1, cz1, pos1, pos2, ga1, ga2) \wedge F(idf2, t2, rez2,$$rok2, cz2) \wedge R(p, idf1, pos1, ga1) \wedge R(p, idf2, pos2, ga2) \wedge idf1 \neq idf2 \wedge rok1 \neq rok2)\}$
2. $\{i, t, rez, rok, cz \mid F(i, t, rez, rok, cz) \wedge \neg(\exists i2, t2, rok2, cz2)(rok2 > rok \wedge (F(i2, t2, rez, rok2, cz)\}$
3. $\{p, i, g \mid (\exists pos)R(p, i, pos, g) \wedge \neg(\exists p2, pos2, g2)(R(p2, i, pos2, g2) \wedge g2 > g)\}$
4. $\{p, i, naz, nar, r \mid A(p, i, naz, nar, r) \wedge \neg (\exists rok1, rok2, mingaza1, mingaza2)(M(p, rok1, mingaza1)$$\wedge M(p, rok2, mingaza2) \wedge (rok1 < rok2 \wedge mingaza1 > mingaza2))\}$
