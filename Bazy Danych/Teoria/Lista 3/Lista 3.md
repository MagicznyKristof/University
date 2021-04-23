# BD Lista 3
###### tags: `BD`

## Rozgrzewka
$P_{7}'(x, z) = \exists (y_{1}, y_{2})P_{2}(x, y_{1}) \wedge P_{2}(y_{1}, y_{2}) \wedge P_{3}(y_{2}, z)$

## Zadanie 1
Weźmy ścieżkę o wierzchołkach $x_{i}$, taką, jak na obrazku ($i = 1$, $i = 2$, etc.)
![](https://i.imgur.com/NjiB1sI.png)
Zapytanie $P_{5}$ będzie miało na tej ścieżce postać $P_{5}(x_{1}, x_{6}) = (\exists x_{2}, x_{3}, x_{4}, x_{5}) E(x_{1}, x_{2}) \wedge E(x_{2}, x_{3})$$\wedge E(x_{3}, x_{4}) \wedge E(x_{4}, x_{5}) \wedge E(x_{5}, x_{6})$

## Zadanie 3
1. Szukany graf $G$ wygląda tak:
![](https://i.imgur.com/CKk7xxv.png)
Niech $G'$ dowolnym grafem. Niech $V(G')$ zbiorem wierzchołków tego grafu takim, że $V(G') = \{x_{1}, x_{2}, ..., x_{n}\}$, a $E(G') = \{e_{1}, e_{2}, ..., e_{k}\}$ zbiorem krawędzi tego grafu.

Wtedy $f: \{x_{1}, x_{2}, ..., x_{n}\} → \{x\}$ taka, że $f(x_{1}) = f(x_{2}) = ... = f(x_{n}) = x$ jest homomorfizmem z $G'$ w $G$, ponieważ $(\forall e_{i} \in E(G')) f(e_{i}) = (x, x)$ a $(x, x)$ jest krawędzią $G$.
2. Rozważmy takie grafy $G$ i $H$
![](https://i.imgur.com/roIlz89.png)
Zauważmy że $f: \{0, 1, 2, 3\} → \{0, 1\}$ taka, że $f(0) = f(2) = 0$ i $f(1) = f(3) = 1$ jest homomorfizmem z $G$ w $H$.

Zauważmy, że $g: \{0, 1\} → \{0, 1, 2, 3\}$ taka, że $g(0) = 0$ i $g(1) = 1$ jest homomorfizmem z $H$ w $G$, czyli $G$ i $H$ są homomorficznie równoważne, ale nie są izomorficzne ponieważ a

## Zadanie 4

Zauważmy, że graf będący cyklem o parzystej liczbie wierzchołków jest grafem dwudzielnym. Wszystkie grafy dwudzielne są homomorficznie równoważne z grafem 
![](https://i.imgur.com/1KWzuMj.png)
czyli możemy wszystkie ich krawędzie zmapować do krawędzi $(1,2)$.

Weźmy dwa grafy $G$ i $H$ będące cyklami o parzystej liczbie wierzchołków. Niech $V(G) = \{x_{1}, x_{2}, ..., x_{2m}\}$ i $V(H) = \{y_{1}, y_{2}, ..., y_{2n}\}$ będą zbiorami wierzchołków $G$ i $H$ a $E(G) = \{e_{1}, e_{2}, ..., e_{2m}\}$ i $E(H) = \{e'_{1}, e'_{2}, ..., e'_{2n}\}$ zbiorami krawędzi $G$ i $H$ takimi, że $e_{1} = (x_{1}, x_{2}), e_{2} = (x_{2}, x_{3}), ..., e_{2m} = (x_{2m}, x_{1})$ i $e'_{1} = (y_{1}, y_{2}), ..., e'_{2n} = (y_{2n}, y_{1})$.

Teraz niech $f: V(G) → V(H)$ taka, że $f(x_{2k}) = y_{1}$ i $f(x_{2k-1}) = y_{2}$, gdzie $k \in \{1, 2, ..., m\}$. Wtedy $(\forall e_{i} \in E(G)) f(e_{i}) = e'_{1}$ czyli $f$ jest funkcją homomorficzną z $G$ w $H$.

Analogicznie tworzymy funkcję $g: V(H) → V(G)$, która będzie homomorficzna z $H$ do $G$, czyli pokażemy że dwa dowolne cykle o parzystej liczbie wierzchołków są homomorficznie równoważne $QED$
