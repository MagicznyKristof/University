# Lista 7

###### tags: `SO`

## Zadanie 1
**stronnicowanie na żądanie** - metoda zarządzania pamięcią, gdzie system wczytuje strony z dysku do pamięci tylko jeżeli wykonywany program o nie poprosi.

Jeżeli system operacyjny pozwoliłby modyfikować plik wykonywany, mogłoby się zdażyć, że wczytalibyśmy z dysku strony już zmodyfikowane (np. wczytałby pierwszą stronę w wersji przed modyfikacją a drugą w wersji po modyfikacji). Prowadzić to może do różnych problemów, od segmentation faulta przez uszkodzenie danych po niewykryte na pierwszy rzut oka błędy.

## Zadanie 2

**odwzorowanie pliku w pamięć** - odwzorowuje fragment pliku bezpośrednio do pamięci wirtualnej wołającego procesu.
**odwzorowanie pamięci anonimowej** - odwzorowanie bez pliku. Początkowo wypełnia całą przestrzeń pamięci zerami.
**odwzorowanie prywatne** - modyfikacje zawartości stron nie są widoczne dla innych procesów a w przypadku odwzorowania pliku w pamięć nie są przekazywane do pliku z którego została wzięta oryginalna zawartość. 
**odwzorowanie dzielone** - modyfikacja zawartości jest zawsze widoczna dla innych plików a w przypadku odwzorowania z pliku przekazuje się zmiany od razu do pliku. Początkowo wszystkie wtrony po forku są dzielone, dopiero operacja copy-on-write może uczynić stronę prywatną. W tym przypadku jeśli proces próbuje zapisać do strony tylko do odczytu, system tworzy nową stronę (kopiuje tą do której była próba zapisu), oddziela ją od procesu który dzielił ją z wołającym procesem i ustawia flagę MAP_PRIVATE. 

## Zadanie 3
![](https://i.imgur.com/iI72Q33.png)
**Prywatne odwzorowanie plików w pamięć** - wczytujemy do pamięci zawartość pliku. Początkowo wszystkie procesy korzystające z tego pliku dzielą zasoby, ale używamy kopiowania przy zapisie żeby uprywatnić strony pamięci. Ten typ odwzorowania używany jest przede wszystkim do inicjalizowania regionu pamięci z pliku (np. tekstu pliku lub danych binarnego pliku wykonywalnego)
**Anonimowe odwzorowanie pamięci anonimowej** - każde wywołanie mmap() przez proces tworzy nowe mapowanie różne od wszystkich poprzednich wywołań mmapa() (w tym czy innym procesie). Dziecko w *forku* dziedziczy mapowanie swojego rodzica ale używamy kopiowania przy zapisie żeby pozbyć się tego problemu. Używany jest głównie do inicjalizowania pustej pamięci, np malloc używa mmapa w tym celu.
**dzielone odwzorowanie pliku w pamięć** -  - wszystkie procesy odwzorowujące region pliku dzielą tą samą pamięć (te same strony pamięci) a każda zmiana przesyłana jest do pliku. W ten sposób można na przykład odwzorować w pamięci urządzenia I/O - ładujemy do pamięci plik z I/O a modyfikacje tego pliku są automatycznie zapisywane. Drugim zastosowaniem jest pozwolenie niepowiązanym procesom na szybką komunikację za pomocą dzielonego obszaru pamięci.
**dzielone odwzorowanie pamięci anonimowej** - różnica między tym a prywatnym odwzorowaniem jest taka, że tutaj pamięć nie jest kopiowana przy zapisie. Dzięki temu po forku, rodzic i dziecko mogą dzielić tę samą przestrzeń adresową i widzą zmiany robione przez siebie nawzajem. Pozwala to na efektywną komunikację międzyprocesową ale tylko pomiędzy powiązanymi procesami.

![](https://i.imgur.com/tuFc4YB.png)

Czy wynik mmapa będzie dzielony możemy ustawić za pomocą *flags* - MAP-PRIVATE oznacza odwzorowanie prywatne a MAP_SHARED dzielone. 
Czy wynik mmapa będzie odwzorowaniem pamięci anonimowej czy z pliku ustawiamy w następujący sposób: jeżeli flaga MAP_ANONYMOUS jest ustawiona i *fd* = -1, to mamy do czynienia z pamięcią anonimową (*fd* = -1 nie jest konieczne w Linuxie ale niektóre implementacje UNIXa wciaż potrzebują takiej informacji). Możemy też otworzyć /dev/zero jako źródło pliku. W przeciwnym wypadku mamy do czynienia z pamięcią z pliku gdzie fd to deskryptor pliku.

Po użyciu execa tracimy cały obraz pamięci starego procesu i zastępujemy go obrazem pamięci nowego procesu. 

W przypadku gdy wczytamy n instancji programu do pamięci, tylko raz potrzeba będzie wczytać ELF - wszystkie instancje dzielą tą pamięć.

Jeśli utworzymy duży blok odwzorowanej pamięci, ale korzystać regularnie będzimy tylko z niewielkiego fragmentu, powinniśmy użyć pamięci wymiany. Kernel, aby uniknąć overcommitowania i zmarnowania dużej ilości swap space, powinien przydzielać ją leniwie - tylko gdy proces jej potrzebuje. Użycie swap space kontrolujemy za pomocą flagi MAP_NORESERVE. Ze swap space korzystamy tylko w przypadku prywatnego odwzorowania z pozwoleniem zapisu i dzielonego odwzorowania pamięci anonimowej. Dla prywatnego odwzorowania bez możliwości zapisu nie potrzebujemy swap space gdyż i tak nie możemy zmienić zawartości a w przypadku dzielonego odwzorowania do pliku sam plik działa jak swap space.

## Zadanie 4
**pomniejsza usterka strony** - strona jest przechowywana w pamięci fizycznej ale nie ma jej w tablicy stron (mogła np. zostać załadowana przez inny proces). Nie ma potrzeby ładować jej z dysku.
**poważna usterka strony** - strony nie ma w pamięci fizycznej i trzeba ją załadować z dysku.
**bufor strony** - tymczasowy obszar przechowywania stron służący jako pośrednik miedzy dyskiem a pamięcią. Zapobiega wielokrotnemu pobieraniu z dysku tych samych danych i zbędnego zapisywania ich na dysk. 
**obiekt wspierający** - plik zwykły lub plik anonimowy (pamięć nieskojaorzona z żadnym plikiem na dysku)

![](https://i.imgur.com/CnBOH0c.png)
Mamy trzy możliwe drogi.
1. Segmentation fault - błąd polega na tym, że proces odwołuje się do strony która nie jest zmapowana do niczego. W przypadku na obrazku jest zmapowana to któregoś z białych pól. Linux przejrzy zakresy wszystkich zmapowanych stron, zobaczy że adres o który prosi proces tam nie występuje i zgłosi błąd wysyłając sydnał SIGSEGV z kodem SEGV_MAPPER.
2. Proces próbuje zrobić coś do czego nie ma uprawnien, np zapisać do pamięci tylko do odczytu - Linux zauważy błąd i zgłosi go wysyłając. Kopiowanie przy zapisie podpada pod ten punkt
3. Wszystko się zgadza (tzn. 1. i 2. nie występują), ale bit_valid jest ustawiony na 0. System operacyjny musi wczytać stronę do pamięci wirtualnej (patrz mała i duża usterka strony).

> Kiedy wystąpi błąd strony przy zapisie, mimo że pole «vm_prot» pozwala na zapis do obiektu wspierającego

==Kiedy będziemy próbowali zapisać na dysk ze strony anonimowej a na dysku nie będzie już miejsca na nową stronę.==

> Kiedy jądro wyśle SIGBUS do procesu posiadającego odwzorowanie pliku w pamięć (§49.4.3)?

Jeśli odwzorowujemy plik i w wyniku tego odwzorowania cała strona pozostanie pusta (np. odwzorowujemy 2000 bajtów pliku na dwie strony po 4 kB, wtedy bajty strony drugiej (4096-8191)) pozostaną puste i próba odwołania się do nich poskutkuje zwróceniem sygnału SIGBUS.

