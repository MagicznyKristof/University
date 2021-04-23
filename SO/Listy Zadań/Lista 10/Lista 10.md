# Lista 10

###### tags: `SO`

## Zadanie 2
**zakleszczenie** - sytuacja w której system ma do wykonania operacje, ale żadna z operacji nie jest w stanie zrobić postępu. Występuje np. gdy każda operacja otrzymała dzielony zasób którego wymaga inna operacja. Na skrzyżowaniu będzie to sytuacja jak niżej - kilka samochodów (procesów) korzysta z wolnych pasów (zasobów), każdy potrzebuje wolnego pasa aby pojechać dalej i blokują się nawazjem
![](https://i.imgur.com/GR725Aq.png)

**uwięzienie** - sytuacja podobna do deadlocka, ale tutaj każdy proces wykonuje bezsensowne operacje które nie zmieniają stanu rzeczy. Przykładowo każdy proces próbuje operacji *abort* i *retry*. W przypadku ruchu ulicznego mamy sytuację podobną do poprzedniej, z tym że teraz wszystkie samochody cofają a potem próbują znowu i nic się nie zmienia.
![](https://i.imgur.com/oAkcvC9.png)

**zagłodzenie** - system wykonuje postęp ale niektóre procesy nie. Nie dostają one dostępu do potrzebnych im zasobów i przez to nie mogą pójść dalej. Przykładowo kilka procesów potrzebuje dostępu do zasobu. Jeśli scheduler przydziela zasoby zgodnie z priorytetem, to może się zdarzyć tak, że procesy o wyższym priorytecie będą otrzymywały zasób cały czas i ten o najniższym priorytecie nigdy się nie wykona. Na przykładzie skrzyżowania, zielone samochody mają wyższy priorytet niż żółte.
![](https://i.imgur.com/p0M5Zqn.png)

wykrywanie i usuwanie zakleszczeń - aby wykryć zakleszczenie proces może przeprowadzić algorytm przeszukiwania aby wykryć cykle w grafie alokacji zasobów. Jeśli mamy cykl to deadlock istnieje. Aby usunąć takie zakleszczenie możemy albo zabić jeden  z procesów deadlocka lub zabrać jednemu z procesów zamieszanych w deadlock zasoby które go spowodowały.

zapobieganie zakleszczeniom - aby zapobiec zakleszczeniom możemy zrobić jedną z kilku rzeczy:
1. Zabronić procesom jednoczesnego trzymania zasobów i proszenia o więcej. Jeśli proces trzyma zasób, powinien go uwolnić a następnie poprosić ponownie, tym razem jednocześnie z nowym procesem w jednej prośbie
2. Jeśli proces zobaczy że proszony przez niego zasób jest zablokowany, to sprawdza które procesy mają do niego dostęp i też są zablokowane. Wtedy trzeba co najmniej jednemu procesowi kazać uwolnić taki zasób i poprosić o niego jeszcze raz.
3. Wprowadzić do hierarchii procesów system powiązania priorytetu z czasem zablokowania.

## Zadanie 3

**sytuacja wyścigu** - sytuacja, gdzie zachowanie systemu zależy od kolejności przeprowadzania operacji przez co możemy dostać inny wynik za każdym razem. Powstaje gdy kilka wątków wchodzą w sekcję krytyczną w tym samym czasie i próbują zaktualizować tą samą zmienną.

```
const int n = 50;
shared int tally = 0;

void total() {
for (int count = 1; count <= n; count++)
tally = tally + 1;
}

void main() { parbegin (total(), total()); }
```

instrukcja `tally = tally + 1` to tak naprawdę 3 instrukcje:
1. załadowanie tally do rejestru
2. zwiększenie wartości w rejestrze o 1
3. zapisanie wartości rejestru do tally

W ten sposób mamy następujące rezultaty:

Maksymalna wartość dla k równoległych wywołań - 50 * k
Minimalna wartość dla k równoległych wywołań - 2 (na obrazku dla dwóch - A i B - ale rozszerzenie jest trywialne)
![](https://i.imgur.com/EeBhuqe.png)

## Zadanie 4
11.1-5, 12.8

## Zadanie 5
12.9
