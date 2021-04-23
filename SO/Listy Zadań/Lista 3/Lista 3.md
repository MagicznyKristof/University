# Lista 3

###### tags: `SO`

## Zadanie 1

* fork nie jest prosty - specyfikacja posixa mówi o 25 specjalnych przypadkach gdy fork kopiuje pamięć rodzica do dziecka. Zachowanie forka kontroluje dużo flag systemowych. *Każdy nietrywialny OS musi to uwzględnić w swojej specyfikacji a biblioteki użytkownika muszą być gotowe na bycie zforkowanym w każdej chwili*
* działanie forka jest słabe dla abstrakcji OS zaimplementowanych w user-mode - fork kopiuje całą przestrzeń adresową więc działa bardzo źle np dla zbuforowanego IO (jak to jest po polsku?) bo trzeba wyrzucić całą przestrzeń adresową jeśli nie chce się mieć skopiowanego wyjścia
* fork nie wspiera wątków - obecne systemy operacyjne działają na wątkach, ale fork przy tworzeniu nowego procesu nie kopiuje wszystkich wątków rodzica, tylko ten wywołujący funkcję
* fork nie jest bezpieczny - dziecko dziedziczy wszystko z rodzica i to programista musi naprawić stan którego dziecko nie potrzebuje (np pozamykać deskryptory plików)
* fork jest wolny
* fork się nie skaluje
* fork zachęca do nadmiernego zaangażowania pamięci - fork poprzez kopiowanie przy zapisietworzy dużo stron pamięci tylko do odczytu. Każda strona takiej pamięci reprezentuje możliwą alokację - jeśli zostanie zmodyfikowana to potrzeba koejnej strony by uchronić się przed page faultem. Jeśli forkowany a następnie execowany jest duży proces, to dostajemy dużo stron tylko do odczytuj które nie zostaną zmodyfikowane, przez co konserwatywna implementacja (zwracanie błędu wywołania forka jeśli nie ma wystarczająco pamięci by obsłużyć wszystkie pagefaulty) marnuje dużo zasobów. Implementacja linuxowa natomiast overcommituje pamięć - linux zawsze zwraca że jest wystarczająco pamięci a jeśli page fault zauważy że jednak nie ma, to zabija procesy by ją zwolnić.

posix_spawn() jest szybszy, skaluje się i nie angażuje za dużo pamięci.

## Zadanie 2

osierocenie - rodzic procesu zostaje zabity. 
1. Po uruchomieniu sleep
> PID PPID CMD
> 4830  2580  /usr/lib/gnome-terminal/gnome-terminal-server 
4973  4830 bash <- powłoka bash
4995  4973 bash <- kopia powłoki bash
5051  4995 sleep 1000 <- zadanie drugoplanowe sleep
2. Po zabiciu rodzica SIGKILL (kill -9 4995)
> 2580  1715 /sbin/upstart --user
> 4830  2580 /usr/lib/gnome-terminal/gnome-terminal-server
4973  4830 bash
5051  2580 sleep 1000
3. Po zabiciu rodzica SIGHUP ()
> 4830  2580 /usr/lib/gnome-terminal/gnome-terminal-server
4973  4830 bash

Dzieje się tak, ponieważ SIGKILL zabija jedynie proces do którego został wysłany a jego dzieci mogą zostać adoptowane, SIGHUP zabija też wszystkie dzieci procesu do którego został wysłany

