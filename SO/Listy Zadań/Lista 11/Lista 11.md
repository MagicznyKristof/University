# Lista 11

###### tags: `SO`

## Zadanie 1
**blok** - w ext2 mała grupa sektorów dysku. Rozmiar bloku jest wyznaczany zwykle podczas formatowania dysku i ma wpływ na wydajność, maksymalny rozmiar pliku cy maksymalny rozmiar systemu plików
**grupa bloków** - grupa bloków połączonych w celu optymalizacji i zapobiegnięciu fragmentacji. Informacja o każdej grupie bloków znajduje się w tablicy deskryptorów w blokach zaraz po superbloku. Dwa bloki na początku każdej grupy bloków są zarezerwowane na bitmapę wykorzystania bloków i bitmapę wykorzystania inodów. Maksymalny rozmiar grupy bloków to 8razy rozmiar bloku
**superblok** - zawiera wszystkie informacje na temat konfiguracji systemu plików, na przykład liczbę inodów i bloków w systemie, ile jest wolnych, liczbę bloków i inodów w każdej grupie bloków, wersję systemu plików, OS który go utworzył etc.
![](https://i.imgur.com/bORtV5R.png)
Liczbę wpisów tablicy deskryptorów grup bloków (czyli liczbę grup bloków) możemy wyliczyć dzieląc liczbę bloków przez liczbę blokó w grupie bloków (i zaokrąglając w górę).

Składowe grupy bloków:
1. Bitmapa wykorzystania bloków - pierwszy blok
2. Bitmapa wykorzystania inodów - drugi blok
3. Zwykłe bloki - do 6 kolejnych bloków

> Które grupy bloków przechowują kopie zapasową superbloku i tablicy deskryptorów grup bloków?
Grupy 0, 1 i potęgi 3, 5, 7.


## Zadanie 2
**blok pośredni** - blok zawierający wskaźniki do innych bloków
![](https://i.imgur.com/lSuRrZm.png)
**spójność systemu plików** - system plików polega na zestawie tabel które opisują dane które zawiera. Jeśli te tabele nie są zsynchronizowane z danymi na dysku, system plików przestaje być spójny

n razy:
1. Zapal bit w bitmapie pamięci (blok jest używany)
2. Zmodyfikuj inode zapisując że blok należy do pliku
3. Jeśli w inode nie ma już miejsca to zgaś bit w bitmapie pamięci po czym zapisz plik do katalogu odpowiednio modyfikując inode katalogu.

## Zadanie 3
> Czemu «rename» zakończy się błędem «EXDEV» kiedy próbujemy przenieść plik do innego systemu plików?

Ponieważ rename nie modyfikuje twardych dowiązań a nie możemy mieć dowiązania twardego między różnymi systemami plików.

> Powtórz polecenia z zadania 2 dla funkcji przenoszącej plik między dwoma różnymi katalogami.

1. Zmodyfikuj inode katalogu do którego przenosimy plik
2. Zmodyfikuj inode katalogu z którego przenosimy plik

## Zadanie 4
> Powtórz polecenia z zadania 2 dla funkcji usuwającej plik zwykły z katalogu.

1. Zmodyfikuj inode zmniejszając liczbę twardych dowiązań do zera
2. Zgaś wszystkie bity bloków pliku w bitmapie

> Kiedy możliwe jest odwrócenie operacji usunięcia pliku tj. odkasowania (ang. undelete)? 

Jeśli plik nadal otwarty jest w jakimś programie, to jego dane nie zostały jeszcze usunięte z dysku. W takim przypadku można go ponownie dowiązać.

> Kiedy w takim razie plik zostanie faktycznie usunięty z dysku?

W momencie w którym zamkniemy wszystkie programy które używają pliku.

## Zadanie 5
**dowiązanie twarde** - wskaźnik na inode pliku, pozwala na dostęp do jednego pliku z dwóch różnych miejsc w systemie plików. Każdy plik posiada co najmniej jedno dowiązanie twarde, jeśli licznik jego dowiązań zejdzie do 0, to znaczy że plik można usunąć. Nie może wskazywać na nieistniejący plik.
**dowiązanie symboliczne** - specjalny plik który przechowuje ścieżkę do innego pliku. System nie sprawdza czy ścieżka jest poprawna, w związku z czym dowiązanie może wskazywać na nieistniejący plik (taki który nigdy nie istniał lub został usunięty od czasu utworzenia dowiązania) lub może powstać pętla.

Podczas wykonywania niektórych operacji moze zostać przekroczony limit dowiązań symbolicznych i wtedy funkcja zwróci błąd ELOOP (np. *access(2)*, *path_resolution(7)*, *chown(2)*, generalnie każda operacja która potrzebuje ścieżki i może natrafić na pętlę).

## Zadanie 8
Resource fork to segment przechowujący dodatkowe informacje o pliku. Informacje są przechowywane w ustrukturyzowanej formie, mogąto być przykładowo mapy bitowe ikon, kształty okien, definicje i zawartość menu. Resource forka używają głównie pliki wykonywalne ale mogą go posiadać wszystkie pliki.

**Rozszerzone atrybuty plików** - właściwości systemu plików które pozwalają na kojarzenie z plikami metadanych któych system sam z siebie nie interpretuje.

Rozszerzone atrybuty plików w linuksie (xattr) mają postać par nazwa-wartość które są na stałe przypisane do plików.


