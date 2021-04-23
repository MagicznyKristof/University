# Lista 5

###### tags: `SO`

## Zadanie 1
Punkt montażowy to miejsce w systemie plików, w którym "zamontowany" jest inny system plików. Tzn mamy punkt montażowy - katalog b, który staje się korzeniem dla "nowego" systemu plików![](https://i.imgur.com/O8QsC6a.png)

```
> findmnt
TARGET                                SOURCE      FSTYPE        OPTIONS
/                                     /dev/sda6   ext4          rw,relatime,errors=remount-ro,data=ordered
├─/sys                                sysfs       sysfs         rw,nosuid,nodev,noexec,relatime
│ ├─/sys/kernel/security              securityfs  securityfs    rw,nosuid,nodev,noexec,relatime
│ ├─/sys/fs/cgroup                    tmpfs       tmpfs         ro,nosuid,nodev,noexec,mode=755
│ │ ├─/sys/fs/cgroup/systemd          cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroup
│ │ ├─/sys/fs/cgroup/perf_event       cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,perf_event
│ │ ├─/sys/fs/cgroup/cpu,cpuacct      cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,cpu,cpuacct
│ │ ├─/sys/fs/cgroup/blkio            cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,blkio
│ │ ├─/sys/fs/cgroup/hugetlb          cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,hugetlb
│ │ ├─/sys/fs/cgroup/cpuset           cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,cpuset
│ │ ├─/sys/fs/cgroup/net_cls,net_prio cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,net_cls,net_prio
│ │ ├─/sys/fs/cgroup/devices          cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,devices
│ │ ├─/sys/fs/cgroup/pids             cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,pids
│ │ ├─/sys/fs/cgroup/freezer          cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,freezer
│ │ └─/sys/fs/cgroup/memory           cgroup      cgroup        rw,nosuid,nodev,noexec,relatime,memory
│ ├─/sys/fs/pstore                    pstore      pstore        rw,nosuid,nodev,noexec,relatime
│ ├─/sys/kernel/debug                 debugfs     debugfs       rw,relatime
│ └─/sys/fs/fuse/connections          fusectl     fusectl       rw,relatime
├─/proc                               proc        proc          rw,nosuid,nodev,noexec,relatime
│ └─/proc/sys/fs/binfmt_misc          systemd-1   autofs        rw,relatime,fd=34,pgrp=1,timeout=0,minproto=5,maxproto=5,direct
│   └─/proc/sys/fs/binfmt_misc        binfmt_misc binfmt_misc   rw,relatime
├─/dev                                udev        devtmpfs      rw,nosuid,relatime,size=3872852k,nr_inodes=968213,mode=755
│ ├─/dev/pts                          devpts      devpts        rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000
│ ├─/dev/shm                          tmpfs       tmpfs         rw,nosuid,nodev
│ ├─/dev/mqueue                       mqueue      mqueue        rw,relatime
│ └─/dev/hugepages                    hugetlbfs   hugetlbfs     rw,relatime
└─/run                                tmpfs       tmpfs         rw,nosuid,noexec,relatime,size=779696k,mode=755
  ├─/run/lock                         tmpfs       tmpfs         rw,nosuid,nodev,noexec,relatime,size=5120k
  └─/run/user/1000                    tmpfs       tmpfs         rw,nosuid,nodev,relatime,size=779696k,mode=700,uid=1000,gid=1000
    └─/run/user/1000/gvfs             gvfsd-fuse  fuse.gvfsd-fu rw,nosuid,nodev,relatime,user_id=1000,group_id=1000
```
W pamięci stałej przechowują dane:
*ext4*
*sysfs*?
*pstore* - persistent storage - system plików używany do przechowywania rekordów zapisanych w ostatnich chwilach przed śmiercią systemu. Pliki w tym systemie powinny być zapisane gdzie indziej krótko po reboocie systemu i wymazane z tego systemu.
*proc*

**noatime** - w zamontowanym systemie nie jest aktualizowany czas ostatniego dostępu
**noexec** - zapobiega bezpośredniemu wykonywaniu plików binarnych na zamontowanym systemie
**sync** - wszystkie operacje muszą być wykonywane synchronicznie

Noexec jest przydatny przy montowaniu tmpfs (np USB) aby zapobiec ryzyku ataku wykonywalnym plikiem binarnym. Noatime można np. użyć w celu wydłużenia życia USB, ponieważ nie musi się on wtedy kłopotać z aktualizowaniem informacji za każdym razem gdy przyjdziemy coś przeczytać. Sync możemy użyć np jeśli wiemy, że będziemy pracować z niecierpliwymi użytkownikami, którzy nie będą chcieli czekać, aż urządzenie skończy się synchronizować (tzn. opróżni bufor) przy kopiowaniu plików i mogą wyciągnąć USB zanim tak naprawdę plik zdąży się przenieść.

## Zadanie 2

![](https://i.imgur.com/9wlt3Gr.png)
Numer i-węzła - numer i-węzła dla danego wpisu w katalogu, tzn dla danego pliku
Rozmiar wpisu - rozmiar jaki zajmuje ten wpis. Jest wyrażony w bajtach i zwykle uwzględnia pewne dopełnienie po nazwie. Wskazuje na następny element ścieżki.
Typ - określa czy mamy do czyniena z plikiem (F), katalogiem (D) itp.
Długość nazwy pliku - długość nazwy wyrażona w bajtach.
Nazwa pliku - zakończona bajtem zerowym i dopełniona do najbliższej granicy bloku 32-bitowego (dalej mogą występować inne wypełienia)

**Nieużytek** - fragment pamięci, ktory przestał być potrzebny ale nie został zwolniony.

Operacje:
Usuwania pliku - usuwamy wpis o pilku z katalogu, "zwiększamy" rozmiar poprzedniego pliku. Jeśli dookoła były jakieś nieużytki to nic się nie dzieje, po prostu jest ich więcej.
Dodawanie pliku - dodajemy wpis o pliku w wolnym miejscu. Jeśli nie ma wystarczająco dużo miejsca na zrobienie tego, zapisujemy plik w innym wolnym miejscu.

**Kompaktowanie** - proces, w którym system usuwa nieużytki aby zwolnić miejsce w pamięci 

## Zadanie 3
**ścieżka bezwzględna** - ścieżka z katalogu głównego ***/*** do pliku
**i-węzeł** - tablica struktur danych po jednej dla każdego pliku zawierająca informacje o nim

1. /
```
/$ stat .
  File: '.'
  Size: 4096      	Blocks: 8          IO Block: 4096   directory
Device: 806h/2054d	Inode: 2           Links: 25
```
```
656642 drwxr-xr-x  14 root root  4096 gru 17  2019 usr
```
2. /usr
```
/usr$ stat .
  File: '.'
  Size: 4096      	Blocks: 8          IO Block: 4096   directory
Device: 806h/2054d	Inode: 656642      Links: 14
```
```
656650 drwxr-xr-x 338 root root 12288 paź 15 00:29 share
```
3. /usr/share
```
/usr/share$ stat .
  File: '.'
  Size: 12288     	Blocks: 24         IO Block: 4096   directory
Device: 806h/2054d	Inode: 656650      Links: 338
```
```
1051472 drwxr-xr-x   93 root root  4096 lip 19  2016 man
```
4. /usr/share/man
```
/usr/share/man$ stat .
  File: '.'
  Size: 4096      	Blocks: 8          IO Block: 4096   directory
Device: 806h/2054d	Inode: 1051472     Links: 93
```
```
1722285 drwxr-xr-x   2 root root 110592 paź 15 15:10 man1
```
5. /usr/share/man/man1
```
/usr/share/man/man1$ stat .
  File: '.'
  Size: 110592    	Blocks: 224        IO Block: 4096   directory
Device: 806h/2054d	Inode: 1722285     Links: 2
```
```
1707678 -rw-r--r--  1 root root   2375 kwi 24  2020 lp.1.gz
```

> Czemu nie możemy tworzyć dowiązań do plików znajdujących się w obrębie innych zamontowanych systemów plików?
Ponieważ twarde dowiązania wymagają i-węzła, który jest wewnętrzny dla systemu plików


## Zadanie 8
Resource fork to segment przechowujący dodatkowe informacje o pliku. Informacje są przechowywane w ustrukturyzowanej formie, mogąto być przykładowo mapy bitowe ikon, kształty okien, definicje i zawartość menu. Resource forka używają głównie pliki wykonywalne ale mogą go posiadać wszystkie pliki.

**Rozszerzone atrybuty plików** - właściwości systemu plików które pozwalają na kojarzenie z plikami metadanych któych system sam z siebie nie interpretuje.

Rozszerzone atrybuty plików w linuksie (xattr) mają postać par nazwa-wartość które są na stałe przypisane do plików.

## Zadanie 9
**dowiązanie twarde** - wskaźnik na inode pliku, pozwala na dostęp do jednego pliku z dwóch różnych miejsc w systemie plików. Każdy plik posiada co najmniej jedno dowiązanie twarde, jeśli licznik jego dowiązań zejdzie do 0, to znaczy że plik można usunąć. Nie może wskazywać na nieistniejący plik.
**dowiązanie symboliczne** - specjalny plik który przechowuje ścieżkę do innego pliku. System nie sprawdza czy ścieżka jest poprawna, w związku z czym dowiązanie może wskazywać na nieistniejący plik (taki który nigdy nie istniał lub został usunięty od czasu utworzenia dowiązania) lub może powstać pętla.

Podczas wykonywania niektórych operacji moze zostać przekroczony limit dowiązań symbolicznych i wtedy funkcja zwróci błąd ELOOP (np. *access(2)*, *path_resolution(7)*, *chown(2)*, generalnie każda operacja która potrzebuje ścieżki i może natrafić na pętlę).

Pętli nie da się zrobić z użyciem hard linków, ponieważ twarde dowiązania do folderów są zabronione. Superuser jest w stanie zrobić pętlę z użyciem hard linków, ale bardzo trudno ją wtedy naprawić

