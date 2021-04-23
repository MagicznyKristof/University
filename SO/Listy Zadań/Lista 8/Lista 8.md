# Lista 8

###### tags: `SO`

## Zadanie 2
**fragmentacja wewnętrzna** - przydzielony blok pamięci jest nie tylko wystarczający do zaalokowania obiektu o który prosi program, ale jest duzo za duży, w wyniku czego zostaje zmarnowana pamięć na końcu tego bloku. 
![](https://i.imgur.com/YS3RLll.png)

**fragmentacja zewnętrzna** - jest wystarczająco wolnych bloków pamieci żeby zaalokować pamięć, ale nie są one w stanie przechować obiektów o które prosi program. Zwykle bierze się to z tego, że wolne bloki pamięci są za małe. 
![](https://i.imgur.com/6KWRQQ9.png)

**kompaktowanie** - proces w którym alokator przesuwa bloki w taki sposób, żeby te zajęte przylegały do siebie nawzajem i niezajęte przylegały do siebie nawzajem.

> Czemu nie można zastosować kompaktowania w bibliotecznym algorytmie przydziału pamięci? 

Biblioteczny algorytm przydziału pamięci powinien zajmować się tylko pamięcią wolną, tzn. jeśli dostanie prośbę o przydział pamięci to musi zdecydować jaki fragment przydzielić i nie może zmieni tej decyzji, konieczne jest poczekanie aż program sam zdecyduje sie zwolnić pamięć.

> Na podstawie §2.3 opowiedz o dwóch głównych przyczynach występowania fragmentacji zewnętrznej.

1. Fragmentacja spowodowana odizolowanymi śmierciami - powstaje jeśli obiekt znajdujący się w środku zajętego obszaru pamięci umiera i zwalnia swoją pamięć. Obszary dookoła zwolnionego fragmentu pozostają zajęte dopóki programy je zajmujące nie postanowią ich zwolnić. Jeśli alokator jest w stanie przewidzieć które programy umrą w podobnym czasie, powinien przydzielić im pamięć obok siebie
2. Fragmentacja jest spowodowana zmianami zachowania programu w czasie - przykładowo załóżmy że program zaczął zwalniać małe obszary pamięci i prosi o duże. Alokator powinien umieć wykorzystać takie schematy.

## Zadanie 3
ramps - program prosi o przydział danych monotonicznie przez dłuższy czas
![](https://i.imgur.com/Kow5mbd.png)
peaks - program prosi o przydział dużej ilości pamięci na raz, szybko procesuje te dane po czym pozbywa się większości z nich
![](https://i.imgur.com/A4ZSVDV.png)
plateaus - program na początku prosi o przydział dużej ilości pamięci po czym wykorzystuje ją przez dłuższy czas
![](https://i.imgur.com/mxzmOGu.png)
> Na podstawie paragrafu zatytułowanego „Exploiting ordering and size dependencies” wyjaśnij jaki jest związek między czasem życia bloku, a jego rozmiarem.

Alokator podczas przydzielania pamięci powinien wziąć pod uwagę kilka rzeczy tak, aby ułatwić zwalnianie dużych bloków pamięci na raz i uniknąć fragmentacji. Obiekty podobnych rozmiarów mają duże szanse być przeznaczone do tego samego celu i w związku z tym być zwolnione w tym samym czasie. Obiekty różnego typu będą raczej używane do różnych rzeczy w różnym czasie. Rozmiar będzie prawdopodobnie powiązany z typem i przeznaczeniem, w związku z tym alokowanie obiektów różnych rozmiarów obok siebie może spowodować fragmentację gdyż będą one żyły przez różny okres.

**first-fit** - algorytm szuka pierwszego wolnego bloku od początku listy. Jeśli znaleziony blok jest za duży, zostaje podzielony a jego reszta wraca na listę wolnych bloków. W tym algorytmie zwykle dostaniemy dużo niewielkich bloków na początku listy (bo pierwsze bloki będą często dzielone), co wydłuża czas szukania - jeśli mamy dużo małych bloków to program musi przejść przez nie wszystkie. Taki algortym potrzebuje tylko prostej listy bloków. Jeśli wolne bloki wstawiamy do listy z powrotem po adresach, to dodatkowo bardzo łątwo możemy łączyć bloki jeśli zajdzie taka potrzeba.

**next-fit** - algorytm korzysta ze wskaźnika, który pamięta, gdzie ostatnia prośba o zaalokowanie pamięci sie zakończyła i szuka (first-fit) od tego momentu. Unikamy dzięki temu zgromadzeniu niewielkich fragmentów na początku listy (bo zawsze zaczynamy z innego miejsca) ale możemy znacznie zwiększyć fragmentację i *locality* (wskaźnik może sprawić, że umieścimy obiekty różnego typu i z różnych faz programu obok siebie).

**best-fit** - algorytm szuka najmniejszego wolnego bloku pamięci który jest w stanie zaalokować to o co prosi program. Problemy są dwa: dopasowania będą prawie perfekcyjne, tzn. większość bloku będzie zajęta, ale część pozostanie wolna i zmarnowana (ponieważ nie będziemy mogli już nic innego na wolną część zapisać) oraz przeszukiwanie pamięci w poszukiwaniu najlepszego dopasowania jest bardzo długie w dużych kopcach pamięci. Z drugiej strony taki algorytm ma zwykle dobre wykorzystanie pamięci .
