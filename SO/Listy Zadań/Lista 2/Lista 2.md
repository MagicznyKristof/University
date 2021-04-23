# Lista 2

###### tags: `SO`

## Zadanie 1

![](https://i.imgur.com/IFA9Hu8.png)

**stan procesu** - stan w jakim znajduje się proces
Running - jest aktualnie wykonywany przez procesor
Ready - czeka na to aż procesor zdecyduje że chce go wykonywać
Blocked - został zablokowany i nie może być wykonywany przez procesor
**sen przerywany** - czeka na jakieś zdarzenie, np operację I/O, dostępnosć zasobów, sygnał z procesu (zakończenie procesu-dziecka)
**sen nieprzerywany** - proces czeka na coś z hardware i ignoruje wszystkie sygnały

**zablokowanie** - powiedzenie kernelowi żeby dostarczył sygnał potem
**zignorowanie** - jak sama nazwa wskazuje, zignorowanie otrzymanego sygnału

SIGKILL nie może być zablokowany ani zignorowany

## Zadanie 2

tl;dr Windows skomplikowanie, Linux prosto

Windows:

Procedura *CreateProcess* wywołuje procedurę trybu użytkownika zaimplementowaną w bibliotece *kernel32.dll* i wykonującą wiele kroków składających się na operację tworzenia procesu (z wykorzystaniem wielu wywołań systemowych i innych działań)

Linux:

Procedura *fork* kopiuje większość zawartości deskryptora procesu-dziecka z deskryptora rodzica. Znajduje dostępny PID i aktualizuje odpowiedni wpis do tablicy identyfikatorów aby wskazywał nowy proces. Następnie przydziela pamięć segmentom danych i stosowi i **przy zapisie** kopiuje segmenty procesu-rodzica.

Następnie kod dziecka wywołuje wywołanie *exec*. Jądro odnajduje i weryfikuje wskazany plik wykonywalny, kopiuje użyte argumenty i łańcuchy parametrów środowiskowych, po czym zwalnia starą przestrzeń adresową i tablice stron na nowy stos,
wyzerowuje sygnały i inicjalizuje rejestry wartościami zerowymi

**Kopiowanie przy zapisie** - Linux udostępnia procesom potomnym odrębne tablice stron, ale umieszczają w tych tablicach wskaźniki do stron procesów macierzystych, oznaczając je jako dostępne tylko do odczytu. Za każdym razem, gdy proces potomny próbuje zmienić zawartość strony, ma miejsce błąd naruszenia reguł ochrony. Jądro wydziela wówczas pamięć dla nowej kopii strony dla procesu potomnego i oznacza ją jako dostępną do odczytu i zapisu. Oznacza to, że kopiowane są tylko strony, co do których proces potomny sformułował żądania zapisu. Jedną z zalet tego modelu jest brak konieczności każdorazowego składowania dwóch kopii programu w pamięci i — tym samym — oszczędność tego cennego zasobu.

## Zadanie 3

a) kopie stosu, sterty i przestrzeni adresowej, deskryptorów plików
b) PID, sygnały oczekujące

> Czemu przed wywołaniem fork należy opróżnić bufory biblioteki stdio(3)?

Ponieważ fork kopiuje bufor, jeżeli ten nie jest pusty, to zostanie skopiowane wszystko co się w nim znajduje

> Czemu w trakcie execve jądro przywraca domyślną obsługę wyłapywanych sygnałów?

Ponieważ obraz procesu zostaje zniszczony i zbudowany od nowa i zmieniona obsługa sygnałów znaczy już po innego
