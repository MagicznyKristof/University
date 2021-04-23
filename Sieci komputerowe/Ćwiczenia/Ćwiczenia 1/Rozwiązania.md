# Sieci ćwiczenia 1

###### tags: `SK`
## Zadanie 1
1. 10.1.2.3/8 - jest to adres komputera.
    Adres sieci: 10.0.0.0/8
    Adres rozgłoszeniowy: 10.255.255.255/8
    Inny adres IP w sieci: 10.1.2.4/8
2. 156.17.0.0/16 - jest to adres sieci.
    Adres rozgłoszeniowy: 156.17.255.255/16
    Adres jakiegoś komputera w tej sieci: 156.17.0.1/16
3. 99.99.99.99/27 - jest to adres komputera.
    Adres sieci: 99.99.99.99/27 (0b01100011.01100011.01100011.01100000)
    Adres rozgłoszeniowy: 99.99.99.127/27
    Inny adres IP w sieci: 99.99.99.100/27
4. 156.17.64.4/30 - adres sieci
    Adres rozgłoszeniowy: 156.17.64.7/30
    Adres jakiegoś komputera w tej sieci: 156.17.64.5/30
5. 123.123.123.123/32 - adres sieci o jednym adresie więc adres sieci jest równocześnie adresem rozgłoszeniowym. 

## Zadanie 2
Podzielimy sieć 10.10.0.0/16 na 5 podsieci:
1. 10.10.0.0/20 (jest to najmniejsza sieć jaką możemy uzyskać)
2. 10.10.16.0/20
3. 10.10.32.0/19
4. 10.10.64.0/18
5. 10.10.128.0/17

W oryginalnej sieci mieliśmy $2^{16} - 2$ adresów możliwych do użycia przy adresowaniu komputerów ($2^{16}$ adresów - adres sieci - adres rozgłoszeniowy). Teraz leczba adresów zmniejszy nam się o 10 - $2^{16}$ adresów - 5 par adres sieci i rozgłoszeniowy.

## Zadanie 3
0.0.0.0/0 → do routera A
10.0.0.0/23 → do routera B
10.0.1.0/24 → do routera C
10.0.1.0/27 → do routera B
10.0.1.0/29 → do routera C

## Zadanie 4
0.0.0.0/0 → do routera A
10.0.0.0/8 → do routera B
10.3.0.128/25 → do routera C
10.3.0.0/27 → do routera C

## Zadanie 5
Aby zasada najlepszego dopasowania odpowiadała wyborowi "pierwszy pasujący", należy posortować wpisy w tablicy po rozmiarach sieci rosnąco (tzn. największa sieć na końcu, np. 0.0.0.0/0 byłoby ostatnią siecią w tablicy). 

#### Dowód:
Niech $w.x.y.z$ jakimś adresem IP a $w_1.x_1.y_1.z_1/t_1$ i $w_2.x_2.y_2.z_2/t_2$ dwoma pasującymi do $w.x.y.z$ wpisami w tablicy routingu, takimi, że $t_1 > t_2$. Załóżmy niewprost, że tablica routingu dopasowała wyborem "pierwszy pasujący" $w_2.x_2.y_2.z_2/t_2$ do $w.x.y.z$. Ale ponieważ wiemy, że oba wpisy pasują do $w.x.y.z$ i $t_1 > t_2$ a tablica routingu posortowana jest po rozmiarach sieci rosnąco, to znaczy, że $w_1.x_1.y_1.z_1/t_1$ jest w tablicy przed $w_2.x_2.y_2.z_2/t_2$, więc metoda "pierwszy pasujący" nie mogła dopasować $w_2.x_2.y_2.z_2/t_2$ do $w.x.y.z$. Mamy więc sprzeczność.

## Zadanie 6


| Krok 0     | A | B | C | D | E | F |
|:----------:|:-:|:-:|:-:|:-:|:-:|:-:|
| droga do A | - | 1 |   |   |   |   |
| droga do B | 1 | - | 1 |   |   |   |
| droga do C |   | 1 | - |   | 1 | 1 |
| droga do D |   |   |   | - | 1 |   |
| droga do E |   |   | 1 | 1 | - | 1 |
| droga do F |   |   | 1 |   | 1 | - |
| droga do S | 1 | 1 |   |   |   |   |

| Krok 1     |     A     |     B     |     C     |     D     |     E     |     F     |
|:----------:|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|
| droga do A |     -     |     1     | 2 (via B) |           |           |           |
| droga do B |     1     |     -     |     1     |           | 2 (via C) | 2 (via C) |
| droga do C | 2 (via B) |     1     |     -     | 2 (via E) |     1     |     1     |
| droga do D |           |           | 2 (via E) |     -     |     1     | 2 (via E) |
| droga do E |           | 2 (via C) |     1     |     1     |     -     |     1     |
| droga do F |           | 2 (via C) |     1     | 2 (via E) |     1     |     -     |
| droga do S |     1     |     1     | 2 (via B) |           |           |           |

| Krok 2     |     A     |     B     |     C     |     D     |     E     |     F     |
|:----------:|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|
| droga do A |     -     |     1     | 2 (via B) |           | 3 (via C) | 3 (via C) |
| droga do B |     1     |     -     |     1     | 3 (via E) | 2 (via C) | 2 (via C) |
| droga do C | 2 (via B) |     1     |     -     | 2 (via E) |     1     |     1     |
| droga do D |           | 3 (via C) | 2 (via E) |     -     |     1     | 2 (via E) |
| droga do E | 3 (via B) | 2 (via C) |     1     |     1     |     -     |     1     |
| droga do F | 3 (via B) | 2 (via C) |     1     | 2 (via E) |     1     |     -     |
| droga do S |     1     |     1     | 2 (via B) |           | 3 (via C) | 3 (via C) |

| Krok 3     |     A     |     B     |     C     |     D     |     E     |     F     |
|:----------:|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|
| droga do A |     -     |     1     | 2 (via B) | 4 (via E) | 3 (via C) | 3 (via C) |
| droga do B |     1     |     -     |     1     | 3 (via E) | 2 (via C) | 2 (via C) |
| droga do C | 2 (via B) |     1     |     -     | 2 (via E) |     1     |     1     |
| droga do D | 4 (via B) | 3 (via C) | 2 (via E) |     -     |     1     | 2 (via E) |
| droga do E | 3 (via B) | 2 (via C) |     1     |     1     |     -     |     1     |
| droga do F | 3 (via B) | 2 (via C) |     1     | 2 (via E) |     1     |     -     |
| droga do S |     1     |     1     | 2 (via B) | 4 (via E) | 3 (via C) | 3 (via C) |

Stan stabilny osiagniemy w kroku 3.

## Zadanie 7

Mamy tabelę z poprzedniego zadania, ale dodajemy połączenie A-D

| Krok 0     |     A     |     B     |     C     |     D     |     E     |     F     |
|:----------:|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|
| droga do A |     -     |     1     | 2 (via B) |     1     | 3 (via C) | 3 (via C) |
| droga do B |     1     |     -     |     1     | 3 (via E) | 2 (via C) | 2 (via C) |
| droga do C | 2 (via B) |     1     |     -     | 2 (via E) |     1     |     1     |
| droga do D |     1     | 3 (via C) | 2 (via E) |     -     |     1     | 2 (via E) |
| droga do E | 3 (via B) | 2 (via C) |     1     |     1     |     -     |     1     |
| droga do F | 3 (via B) | 2 (via C) |     1     | 2 (via E) |     1     |     -     |
| droga do S |     1     |     1     | 2 (via B) | 4 (via E) | 3 (via C) | 3 (via C) |

| Krok 1     |     A     |     B     |     C     |     D     |     E     |     F     |
|:----------:|:---------:|:---------:|:---------:|:---------:|:---------:|:---------:|
| droga do A |     -     |     1     | 2 (via B) |     1     | 2 (via D) | 3 (via C) |
| droga do B |     1     |     -     |     1     | 2 (via A) | 2 (via C) | 2 (via C) |
| droga do C | 2 (via B) |     1     |     -     | 2 (via E) |     1     |     1     |
| droga do D |     1     | 2 (via A) | 2 (via E) |     -     |     1     | 2 (via E) |
| droga do E | 2 (via D) | 2 (via C) |     1     |     1     |     -     |     1     |
| droga do F | 3 (via B) | 2 (via C) |     1     | 2 (via E) |     1     |     -     |
| droga do S |     1     |     1     | 2 (via B) | 2 (via A) | 3 (via C) | 3 (via C) |

Nic więcej się nie zmieni, ponieważ kolejne sygnały nie będą lepsze od tego, co jest w tablicy.

## Zadanie 8

1. Połączenie między D i E ulega awarii. D zauważa to i zmienia odległość do E na $\infty$.
2. Zanim D zdąży wysłać wiadomość o awarii do B, dostaje komunikat z B, który mówi, że najkrótsza ścieżka z B do E to 2. Updatuje odległość do E na 3 (via B).
3. D wysyła swoją tablicę routingu do C. Ponieważ najkrótsza odległosć z C do E, prowadzi przez D, to C updatuje swoją odległość do E na 4 (via D).
5. C wysyła swoją tablicę routingu do A. Ponieważ najkrótsza odległość z A do E prowadzi przez C*, A updatuje swoją odległość do E na 5 (via C).
6. D wysyła swoją tablicę routingu do B. Ponieważ najkrótsza odległosć z B do E prowadzi przez D, B updatuje swoją odległość do E na 4 (via D).
7. Routery kontynuują przesyłanie sobie tablic routingu, myśląc, że każdy potrafi połączyć się z E. Z biegiem czasu "odległość" do E rośnie a pakiet wysłany do E będzie krążył w cyklu między A, B, C i D

*przyjmujemy, że w tablicy routingu A najkrótsza ścieżka do E jest via C. Jeśli tak nie jest (tzn. jest via B) to w ogólności nic się nie zmienia.

## Zadanie 9
Mamy sieć jak na obrazku:
![](https://i.imgur.com/Ta746DD.png)

Połączenie z A do B ulega awarii. A chce wysłać pakiet o B przez C, bo to jedyna droga jaką widzi. C otrzymało już informację o uszkodzeniu połączenia A-B, ale D jeszcze nie (na potrzeby zadania przyjmijmy, że w tablicy routingu D najkrótsza ścieżka do B prowadzi przez C i A). D wciąż myśli, że najkrótsza droga do B prowadzi przez C i A, więc odsyła pakiet tam, skąd przyszedł. Dopóki D nie dostanie informacji o zerwaniu połączenia, pakiet nie dotrze do B i będzie krążył w cyklu.
