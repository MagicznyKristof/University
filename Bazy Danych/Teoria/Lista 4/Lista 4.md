# BD Lista 4
###### tags: `BD`

## Zadanie 2
Semantyka datalogu:
$T(x_1, ..., x_k) :- R_1(\pi_2), R_1(\pi_2), ..., R_n(\pi_n)$, gdzie wszystkie $x_i$ występują po prawej stronie. Mogą występować te same symbole realcji po prawej i po lewej stronie $:-$ (tzn. mamy rekursję).


Mamy zapytanie
$T(x, y) :- E(x, y)$.
$T(x, y) :- T(x, z), T(z, y)$.

To zapytanie zewaluuje się do
$T_0 = \emptyset$
$T^{n+1} = \{(a, b) | E(a, b) \vee \exists z(T^{n}(a, z), T^n(z, b))\}$

Chcemy pokazać, że $T^i = \{(a, b) |$ istnieje ścieżka z $a$ do $b$ o długości $\leq2^{i-1}\}$.

#### Dowód:
1. Baza indukcji. Zauważmy, że $T^0$ jest zbiorem pustym. W związku z tym, $T^1$ zawsze zewaluuje się do $E(a, b)$, ponieważ $z(\emptyset, \emptyset)$ zawsze będzie fałszem. Czyli $T^1 = \{(a, b) |$ istnieje ścieżka z $a$ do $b$ o długości $\leq 2^0\}$, zatem dla $T^1$ sie zgadza.
2. Weźmy jakieś $n > 1$. Załóżmy indukcyjnie, że dla każdego $i \leq n$ twierdzenie jest prawdziwe. Wtedy dla $T^{n+1}$ mamy: $T^{n+1} = \{(a, b) | E(a, b) \vee \exists z (T^n(a, z), T^n(z, b))\}$. $E(a, b)$ oczywiście spełnia nasze zapytanie, bo długość ścieżki jest wtedy równa 1. Z założenia indukcyjnego wiemy, że $T^n(x, y)$ zawiera wszystkie pary $(x, y)$ między którymi istnieje ścieżka o długości nie większej niż $2^{n-1}$. W takim razie dla każdej pary $(a, b)$ dla której $\exists z (T^n(a, z), T^n(z, b))$, istnieje ścieżka o długości co najwyżej $2^{n-1} + 2^{n-1} = 2^n$, czego należało dowieść.

## Zadanie 3
Na potrzeby zadania przyjmuję, że $E(x, y)$ oznacza, że mamy ścieżkę z wierzchołka $y$ do wierzchołka $x$
1. 
$Q() :- T(x)$
$T(x) :- E(x, n)$
$T(x) :- E(x, m)$
$T(x) :- T(y), E(x, y)$

2. 
$Q() :- T(x)$
$T(x) :- R(x), S(x)$
$S(x) :- E(n, x)$
$S(x) :- E(y, x), S(y)$
$R(x) :- E(n, x)$
$R(x) :- E(y, x), R(y)$

3. 
$Q() :- T(x, y)$
$T(x, y) :- E(x, n), E(y, n)$
$T(x, y) :- E(x, a), E(y, b), T(a, b)$

4. 
$Q() :- T(x, y)$
$R(a, n) :- E(a, b), E(b, n)$
$R(a, n) :- E(a, b), R(b, n)$
$T(x, y) :- E(x, n), R(y, n)$
$T(x, y) :- E(x, a), E(y, b), T(a, b)$

## Zadanie 4
$Q() :- ODD(x, x)$
$ODD(x,y) :- E(x,y)$
$ODD(x,y) :- E(x,z), EVEN(z,y)$
$EVEN(x,y) :- E(x,z), ODD(z,y)$

## Zadanie 5
