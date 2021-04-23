# Lista 4

###### tags: `SO`

## Zadanie 1

**rekord katalogu** - para (nie do końca) informacji o pliku lub katalogu znajdującym się w katalogu 
**metadane** - informacje przechowywane przez system o pliku (katalogu, potoku, I/O, etc)
**dowiązanie** - rekord katalogu, który wiąże plik z jakąś nazwą

Czemu wywołania read(2) i write(2) nie działają na katalogach?

Ponieważ wywołania read(2) i write(2) działają na deskryptorach plików które tworzone są przy użyciu open(2) (nie tylko, ale opendir go nie tworzy). Dodatkowo nie możemy zapisać nic do katalogu poniweaż dane w katalogu traktowane są jako metadane

Jakim wywołaniem systemowym można wczytać rekord katalogu (ang. directory entry )? 
readdir(3)

Czy zawartość katalogu jest posortowana?
Nie, jeżeli wywołamy program, który czyta rekordy linijka po linijce, dostaniemy coś takiego (dla przykładowego folderu z folderami *1*, *2*, *3* oraz plikami *ls.c* i *a.out*)
```
> /a.out
2037209 2
2037207 3
1979389 a.out
2037208 1
2036626 .
1979388 ls.c
2036621 ..
```

```
> stat /
  File: '/'
  Size: 4096      	Blocks: 8          IO Block: 4096   directory
Device: 806h/2054d	Inode: 2           Links: 25
Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2020-11-05 07:06:03.588005395 +0100
Modify: 2020-10-15 15:10:49.264799274 +0200
Change: 2020-10-15 15:10:49.264799274 +0200
 Birth: -

```
Mamy 25 powiązań. Dwa z nich to standardowa liczba linków dla każdego folderu - do siebie i rodzica (w przypadku katalogu głównego do siebie dwukrotnie). Pozostałe 23 powiązania to powiązania do folderów dzieci.

## Zadanie 4

**urządzenia blokowe i znakowe** - urządzenia służące do odczytu/zapisu danych. Urządzenia blokowe pracują na banych blokami i nie są strumieniowane za to są buforowane (np. dyski) a urządzenia znakowe pracują na danych znak po znaku i są strumieniowane (np. myszki, modemy, pamięć RAM)

Do czego służy wywołanie systemowe ioctl(2)? 

Do manipulowania plikami I/O. Pozwala na tworzenie hooków do sterowników urządzeń. 

pierwszy argument - deskryptor
drugi argument - request - _IO i reszta korzystają z niego podczas ustalania requestu
trzeci argument - parametr (variadic argument) - mowa o tym że t parametr w programie 

DIOCEJECT - request ioctl powodujący wysunięcie dysku.
KIOCTYPE - request ioctl zwracający typ klawiatury
SIOCGIFCONF - request ioctl zwracający listę ifnet gniazda
