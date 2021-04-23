# BD Lista 1

###### tags: `BD`

## Zadanie 1
Nie da się wyrazić operatora $\backslash$ za pomocą wyrażeń algebry relacji z operatorami $\pi, \sigma, \rho, \times, \cup$.

Jak powiedziano na wykładzie, operator $\backslash$ jest jedynym z tych operatorów, który nie jest monotoniczny, tzn. jeśli do relacji na które nakładamy wyrażenie z operatorami $\pi, \sigma, \rho, \times, \cup$ dodamy krotki, to w wyniku być może pojawi się więcej krotek a być może ich liczba się nie zmieni, natomiast nigdy nie będzie tak, że ich liczba się zmniejszy.

Natomiast jeśli do relacji z prawej strony wyrażenia $\backslash$ dodamy krotki, to może się zdarzyć tak, że w wyniku dostaniemy mniej krotek.

## Zadanie 2
Zapytanie jest niepoprawne - jeśli jeden ze zbiorów $Y$ lub $Z$ będzie pusty, to cały iloczyn kartezjański będzie pusty.

Zauważmy, że $X \cap (Y \cup Z) \equiv X \backslash ((X \backslash Y) \cap (X \backslash Z))$ (dowód mogę przedstawić w formie rysunkowej)

$X \backslash (\pi_{A} (\sigma_{X.A=X1.A1} ((X \backslash Y) \times \rho_{X1(A_{1})} (X \backslash Z))))$ to właściwe zapytanie




## Zadanie 3
#### a)
$G_{count_{sok}(bar)}(\pi_{bar, sok}(B \Join P))$ - zwraca pary $(bar, n)$, takie, że w barze $bar$ podawane jest $n$ soków.

$\pi_{bar, sok}(B \Join P)$ zwróci relację par $(bar, sok)$ która pokazuje soki podawane w barach. Następnie pełna formuła użyje funkcji agregującej do policzenia ile soków podawanych jest w każdym barze.
#### b)
$(\pi_{osoba, bar, sok}(P \Join L))$ zwróci krotki $(osoba, sok, bar)$, które mówią kto lubi jakie soki podawane w jakim barze - tzn. jedna krotka to będzie "sok $sok$ podawany jest w barze $bar$ i lubi go osoba $osoba$".

$G_{count_{sok}(osoba, bar)}(\pi_{osoba, bar, sok}(P \Join L))$ zwróci krotki $(osoba, bar, n)$, takie, że osoba $osoba$ lubi $n$ soków podawanych w barze $bar$.

$\sigma_{n\geq5}(G_{count_{sok}(osoba, bar)}(\pi_{osoba, bar, sok}(P \Join L)))$ zwróci takie krotki $(osoba, bar, n)$, że $n\geq5$, czyli takie krotki, że osoba $osoba$ lubi co najmniej 5 soków podawanych w barze $bar$.

$\pi_{osoba, bar}(\sigma_{n\geq5}(G_{count_{sok}(osoba, bar)}(\pi_{osoba, bar, sok}(P \Join L))))$ - zwróci pary $(osoba, bar)$ takie, że osoba $osoba$ lubi co najmniej 5 osków podawanych w barze $bar$.
#### c)
$\pi_{osoba, sok, cena}(B \Join P)$ zwróci krotki $(osoba, sok, cena)$, które mówią jakie soki $sok$ po jakiej cenie $cena$ może kupić osoba $osoba$ w barach do których chodzi.

$G_{min_{cena}(osoba, sok)}(\pi_{osoba, sok, cena}(B \Join P))$ zwróci krotki $(osoba, sok, n)$ takie, że osoba $osoba$ może kupić sok $sok$ w barach do których chodzi najtaniej za cenę $n$ (można jeszcze przemianować $n$ na $cena$).
#### d)
$G_{min_{cena}(osoba, sok)}(\pi_{osoba, sok, cena}(B \Join P))\Join P$ zwróci krotki $(osoba, sok, n, bar, cena)$ które mówią jaka jest cena $cena$ soku $sok$ w barze $bar$ do którego chodzi osoba $osoba$ podczas gdy minimalna cena za którą osoba $osoba$ może kupić sok $sok$ w jakimkolwiek barze do którego chodzi wynosi $n$

$\sigma_{n = cena}(G_{min_{cena}(osoba, sok)}(\pi_{osoba, sok, cena}(B \Join P))\Join P)$ zwróci krotki takie, że osoba $osoba$ może kupić w barze $bar$ sok $sok$ po cenie $cena$, która jest równa najmniejszej cenie $n$ za jaką osoba $osoba$ może kupić sok $sok$ w jakimkolwiek barze do którego uczęszcza (który to bar oczywiście jest również barem $bar$).

$\pi_{osoba, sok, bar}(\sigma_{n = cena}(G_{min_{cena}(osoba, sok)}(\pi_{osoba, sok, cena}(B \Join P))\Join P))$ zwróci krotki które mówią, że osoba $osoba$ może kupić sok $sok$ w barze $bar$ najtaniej spośród wszystkich barów do których uczęszcza.
## Zadanie 4

#### a)
π name,year,last_name,genre (σ year<1960 (ρ movie_id←id (movies) ⨝ movies_directors) ⨝ ρ director_id←id (directors) ⨝ movies_genres)

#### b)
π first_name, last_name (actors) - π first_name, last_name (ρ actor_id←id (actors) ⨝ roles ⨝ ρ movie_id←id (movies) ⨝ movies_directors ⨝ σ director_last_name='Tarantino' (ρdirector_id←id, director_first_name←first_name, director_last_name←last_name (directors)))
#### c)
π first_name, last_name (actors - (ρactor_id←id (actors) ⨝ π actor_id (σ movie_id ≠ movie_id2 (roles ⨝ ρ movie_id2 ← movie_id, role2 ← role (roles)))))
#### d)
π name (ρ movie_id←id (movies) ⨝ π movie_id σ genre='Drama' movies_genres ⨝ π movie_id σ genre='Sci-Fi' movies_genres)
#### e)
π name (movies ⨝ (π id, rank (movies) - π id, rank (σ rank < rank2 (π id, rank (movies) ⨝ π id2, rank2 (ρ id2 ← id, rank2 ← rank (movies))))))
#### f)
π first_name,last_name (ρ actor_id←id (actors) ⨝ π actor_id σ role = role2 ∧ movie_id≠movie_id2 (roles ⨝ ρ movie_id2 ← movie_id, role2 ← role (roles)))
#### g)
π last_name (directors - π id, first_name, last_name (directors ⨝ σ genre = 'Horror' ρ id ← director_id (directors_genres)))
#### h)
π last_name (ρ director_id ← id (directors) ⨝ π director_id (movies_directors ⨝ (π movie_id (ρ movie_id ← id (movies)) - π movie_id (σ gender = 'F' (ρ actor_id ← id (actors)) ⨝ roles ⨝ ρ movie_id ← id (movies)))))
