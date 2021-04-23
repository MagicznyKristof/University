# Lista 12

###### tags: `SO`

## Zadanie 1

**wyścig** - sytuacja, w której dwa (lub więcej niż dwa) procesy czytają lub zapisują współdzielone dane a wynik zależy od tego który proces będzie działał kiedy.
**dane współdzielone** - dane do których dostęp ma wiele pracujących ze sobą procesów (wątków) (dostęp tzn. mogą czytać i zapisywać do pamięci).

*myid* - to w funkcji *main* będzie współdzielone (nowy wątek będzie zaczynał z &*myid*), to w funkcji thread nie będzie współdzielone (każdy wątek utworzy swoje *myid* kopiując je ze wskaźnika który **jest** współdzielony)
*strtab* - będzie współdzielone, ale nie będzie powodować wyścigów - nie zapisujemy nic do tej zmiennej poza skopiowaniem do niej *argv* na samym początku gdy nie ma jeszcze żadnego wyścigu.
*vargp* - odpowiada *myid* w funkcji *main*. Będzie współdzielone i powodować wyścigi.
*cnt* - będzie współdzielone (static) i będzie powodować wyścigi
*argc* - nie będzie współdzielone i nie będzie powodować wyścigów
*argv[0]* - nie będzie współdzielone i nie będzie powodować wyścigów

## Zadanie 2

**sekcja krytyczna**- część programu, w której proces korzysta ze współdzielonej pamięci
**wyłączanie przerwań** - blokowanie przerwań procesora (i jakichkolwiek innych) gdy proces wchodzi do sekcji krytycznej 
**drobno-ziarniste blokowanie** (nie drobnoziarniste?) - metoda blokowania gdzie każdy element struktury ma swój własny lock zamiast jednego locku na całą strukturę. Np. mamy strukturę listy, gdzie element wskazuje na kolejny w liście. Gruboziarniste blokowanie blokowałoby całą listę, podczas gdy drobnoziarniste blokuje tylko te elementy listy które musi.

### Podaj i uzasadnij założenia jakie musi spełniać rozwiązanie problemu sekcji krytycznej (§2.3.2).

1. Żadne dwa procesy nie mogą jednocześnie przebywać wewnątrz swoich sekcji krytycznych. - dość oczywiste, jeśli tak nie będzie to możemy mieć problem wyścigu
2. Nie można przyjmować żadnych założeń dotyczących szybkości lub liczby procesorów. - jeśli założymy błędnie, to program może zacząć robić głupie rzeczy, (np zablokujemy sekcję krytyczną na X sekund a proces wyjdzie z niej po 1/10X sekund - możemy zmarnować dużo czasu - lub po 10X sekund - mamy sytuację wyścigu)
3. Proces działający wewnątrz swojego regionu krytycznego nie może blokować innych procesów. - chcemy mieć możliwość w czasie wykonywanie procesu w sekcji krytycznej przełączania kontekstu na inny proces (który akurat nie jest w żadnej sekcji krytycznej) 
4. Żaden proces nie powinien oczekiwać w nieskończoność na dostęp do swojego regionu krytycznego. - nie chcemy dopuścić do zagłodzenia procesu

### Czemu w programach przestrzeni użytkownika do jej implementacji nie możemy używać wyłączania przerwań (ang. interrupt disable)?

Ponieważ udzielanie processowi użytkownika tak dużego prawa jest nierozsądne. Jeśli proces wyłączyłby przerwania po czym nigdy ich nie włączył z powrotem, nie moglibyśmy nic zrobić i system by umarł (a nie możemy zagwarantować że proces użytkownika tak nie zrobi w przeciwieństwie do procesu jądra).

###  Odwołując się do Prawa Amdahla powiedz czemu programistom powinno zależeć na tym, by sekcje krytyczne były możliwie jak najkrótsze – określa się to również mianem drobno-ziarnistego blokowania (ang. fine-grained locking).

**Prawo Amdahla** - jest używane do znajdowania maksymalnego spodziewanego zwiększenia wydajności całkowitej systemu jeżeli tylko część systemu została ulepszona. Jest ono często używane w przypadku prowadzenia obliczeń równoległych do przewidzenia teoretycznego maksymalnego wzrostu szybkości obliczeń przy użyciu wielu procesorów. (wikipedia)

Zwiększenie szybkości wykonywania programu przy użyciu wielu wątków na wielu procesorach może być tylko tak szybkie jak dużo operacji możemy wykonać równolegle. Program spędzający czas w sekcji krytycznej nie będzie mógł być wykonywany w tym czasie na innych procesach. Przykładowo jeśli program z użyciem jednego wątku wykonuje się 10 godzin, z czego godzinę musi spędzić w sekcjach krytycznych, to nieważne jak dużo wątków i procesorów użyjemy, czas jego działania nie zejdzie poniżej jednej godziny. Powinniśmy więc minimalizować czas jaki program spędza w sekcji krytycznej

## Zadanie 3

**instrukcja atomowa** - instrukcja wykonywana "na raz", bez możliwości przerwania w środku
**blokada wirująca** - blokada, gdzie oczekujący proces czeka w pętli na zwolnienie zasobu do którego chce uzyskać dostęp

```
int CompareAndSwap(int *ptr, int expected, int new) {
    int original = *ptr;
    if (original == expected)
        *ptr = new;
    return original;
}
```

```
void lock(spin_t *lock)
{
    while(CompareAndSwap(lock, 0, 1) == 1)
    ; //spin
}

void unlock(spin_t *lock)
{
    *lock = 0;
}
```

### Czemu blokada wirująca nie jest sprawiedliwa (ang. fair)

Nie możemy zagwarantować, że spin lock kiedykolwiek się zakończy i program dostanie dostęp do zasobów których potrzebuje.

### Wiemy, że w przestrzeni użytkownika wątek może zostać wywłaszczony, jeśli znajduje się w sekcji krytycznej chronionej dowolną blokadą. Jakie problemy to rodzi?

1. Inne procesy zmarnują dużo czasu procesora kręcąc się
2. Jeśli wątki mają różne priorytety, możemy doprowadzić do zagłodzenia całego systemu

## Zadanie 4

**przeciwdziałanie zakleszczeniom** - takie działanie systemu żeby zakleszczenia nie występowały

* *Mutual exclusion*: wątki dostają wyłączną kontrolę nad zasobami których potrzebują (np. lock).
* *Hold-and-wait*: Waki trzymają przyznane im zasoby (np. "otrzymane" locki) i czekają na inne zasoby (np. locki których potrzebują.
* *No preemption*: Zasoby (np. locki) nie mogą być zabrane wątkom które je trzymają siłą.
* *Circular wait*: Istnieje cykl wątków taki że każdy wątek trzyma zasoby (np. locki) potrzebne innym wątkom.

### Na podstawie §32.3 wyjaśnij w jaki sposób można przeciwdziałać zakleszczeniom (ang. deadlock prevention)?

* Circular wait prevention - przydzielanie zasobom jakichś priorytetów i wprowadzenie zasady że zasoby można uzyskać tylko w określonej kolejności (nie można uzyskać zasobu o wyższym priorytecie przed zasobem o niższym priorytecie).
* Hold and wait prevention - proces żąda wszystkich potrzebnycch mu zasobów na raz. Trzeba dopilnować żeby w tym czasie nie nastąpiło przerwanie oraz trzeba część zasobów z dużym prawdopodobieństwem pozyskać wcześniej co jest marnotrawstwem i zmniejsza współbieżność.
* no preemption prevention - wykorzystanie interfejsu trylock. Rodzi to dużo problemów w rodzaju livelocka czy konieczności oddawania innych zasobów które wzięło się między próbami trylocka.
* Mutual exclusion prevention - unikanie przyznawania locków poza przypadkami gdy jest to absolutnie konieczne i budowanie struktur danych w taki sposób żeby nie potrzebowały locków

## Zadanie 5

1. 
```c=
shared boolean blocked [2] = { false, false };
shared int turn = 0;

void P (int id) {
    P0, P1
    while (true) {
        blocked[id] = true;
        while (turn != id) {
            while (blocked[1 - id])
                continue;
            turn = id;
        }
    /* put code to execute in critical section here */
    blocked[id] = false;
    }
}

void main() { parbegin (P(0), P(1)); }
```
2. 
```c=
shared boolean blocked [2] = { false, true };
shared int turn = 0;

void P (int id) {
    P0
    while (true) {
        blocked[id] = true;
        while (turn != id) {
            while (blocked[1 - id])
                continue;
            P1 (wejdziemy do pierwszej pętli ponieważ turn = 0 a z drugiej wyjdziemy bo blocked[0] = false)
            turn = id;
        }
    /* put code to execute in critical section here */
    blocked[id] = false;
    }
}

void main() { parbegin (P(0), P(1)); }
```
3. 
```c=
shared boolean blocked [2] = { true, true };
shared int turn = 0;

void P (int id) {
    while (true) {
        blocked[id] = true;
        while (turn != id) {
            while (blocked[1 - id])
                continue;
            P1
            turn = id;
        }
    P0 (nie wejdziemy do pierwszej pętli ponieważ turn = 0)
    /* put code to execute in critical section here */
    blocked[id] = false;
    }
}

void main() { parbegin (P(0), P(1)); }
```
4. 
```c=
shared boolean blocked [2] = { true, true };
shared int turn = 1;

void P (int id) {
    while (true) {
        blocked[id] = true;
        while (turn != id) {
            while (blocked[1 - id])
                continue;
            P1
            turn = id;
        }
    P0, P1 (oba procesy są w sekcji krytycznej w tym samym czasie)
    /* put code to execute in critical section here */
    blocked[id] = false;
    }
}

void main() { parbegin (P(0), P(1)); }
```

## Zadanie 6

**aktywne czekanie** - ciągłe sprawdzanie czy zasób który chcemy uzyskać już się zwolnił.
**blokada usypiająca** - blokada w której zamiast aktywnie czekać, usypiamy wątek na jakiś czas.
**zagłodzenie** - system wykonuje postęp ale niektóre procesy nie. Nie dostają one dostępu do potrzebnych im zasobów i przez to nie mogą pójść dalej. Przykładowo kilka procesów potrzebuje dostępu do zasobu. Jeśli scheduler przydziela zasoby zgodnie z priorytetem, to może się zdarzyć tak, że procesy o wyższym priorytecie będą otrzymywały zasób cały czas i ten o najniższym priorytecie nigdy się nie wykona. Na przykładzie skrzyżowania, zielone samochody mają wyższy priorytet niż żółte.
![](https://i.imgur.com/p0M5Zqn.png)

### Czemu oddanie czasu procesora funkcją «yield» (§28.13) nie rozwiązuje wszystkich problemów, które mieliśmy z blokadami wirującymi?

Nie rozwiązuje problemu głodzenia, wciąż jest dość kosztowny oraz nie rozwiązuje problemu priorytetów

### Zreferuj implementację blokad usypiających podaną w §28.14.[...]

```
typedef struct __lock_t {
    int flag;
    int guard;
    queue_t *q;
} lock_t;

void lock_init(lock_t *m) {
    m->flag = 0;
    m->guard = 0;
    queue_init(m->q);
}

void lock(lock_t *m) {
    while (TestAndSet(&m->guard, 1) == 1)
        ; //acquire guard lock by spinning
    if (m->flag == 0) {
        m->flag = 1; // lock is acquired
        m->guard = 0;
    } else {
        queue_add(m->q, gettid());
        setpark(); // new code
        m->guard = 0;
        park();
    }
}

void unlock(lock_t *m) {
    while (TestAndSet(&m->guard, 1) == 1)
        ; //acquire guard lock by spinning
    if (queue_empty(m->q))
        m->flag = 0; // let go of lock; no one wants it
    else
        unpark(queue_remove(m->q)); // hold lock
                                    // (for next thread!)
    m->guard = 0;
}
```
Kod implementuje kolejkę do locka. Procesy które chcą uzyskać lock na początku próbują otrzymać guard locka, który pilnuje żeby tylko jeden proces na raz próbował dopisać się do kolejki. Jeśli nikt nie ma locka, to proces go otrzymuje po czym zwalnia guarda. Jeśli lock jest zajęty, to proces dopisuje się do kolejki, po czym idzie spać. *setpark* pilnuje, żeby proces nie został wywłaszczony w nieodpowiednim momencie (po oddaniu guarda ale przed pójściem spać - mielibyśmy wtedy sytuację wyścigu).

Jeśli proces zwalnia lock, to sprawdza kto czeka następny w kolejce do niego. Jeśli kolejka jest pusta to go zwalnia, jeśli ktoś oczekuje na locka to proces który go trzyma, budzi pierwszy wątek w kolejce po czym oddaje mu locka.

Taka implementacja rozwiązuje problem głodzenia - wątki dostają locka w kolejności w jakiej o niego poproszą i żaden nie zostanie pominięty przez losowy scheduling procesora.

## Zadanie 8


