# SO lista 0

###### tags: `SO`

## Zadanie 1
przerwanie sprzętowe (hardware interrupt) - asynchroniczne (tzn nie są spowodowane wykonaniem instrukcji). Są powodowane przez sygnały zewnętrznych dla procesora urządzeń I/O. Działają tak, że po tym jak instrukcja skończy się wykonywać, procesor zauważa że interrupt pin (jak to było po polsku?) zgłasza przerwanie, czyta numer przerwania i przekazuje odpowiedniemu handlerowi do obsługi. Handler wraca do **następnej** instrukcji (**obecna** skończyła się wykonywać)
*    wciśnięcie klawisza na klawiaturze
*    transmisja danych z dysku twardego
*    nadejście pakietu sieciowego 

pułapka (trap) - **celowy** wyjątek wywołany wykonaniem instrukcji. Służy do zapewnienia komunikacji między programami a kernelem (**system calle**). Z punktu widzenia programisty pułapka jest identyczna do zwykłej instrukcji ale jej implementacja jest inna. Po wykonaniu instrukcji-pułapki, kernel przekazuje jej obsługę do odpowiedniego handlera. Handler po zakończeniu obsługiwania pułapki wraca do następnej instrukcji.
*    syscalle (np. read - czytanie pliku, fork - tworzenie nowego procesu, execve - wczytanie nowego programu, exit - zakończenie procesu)
*    asercje (assert() w C)
*    breakpointy (w gdb)

wyjątek (exception) - oba powyższe oraz błędy przetwarzania instrukcji (nieplanowane, potencjalnie odwracalne (**faults**) lub nie (**aborts**)). Po zgłoszeniu wyjątku procesor przekazuje kontrolę do handlera, który próbuje naprawić problem. Jeśli mu się to uda, zwraca kontrolę do instrukcji, która spowodowała błąd (wykonuje ją jeszcze raz). W przeciwnym przypadku przekazuje kontrolę procedurze (jak to lepiej określić) **abort**, która zamyka program wywołujący błąd.
*    błąd strony (page **fault** - odwracalny)
*    dzielenie przez zero (divide error)
*    błędne odwołanie do pamięci (odwołanie do niezdefiniowanej pamięci wirtulanej, próba zapisu do pamięci read-only)
*    arytmetyczny overflow

## Zadanie 2
Wektor przerwań to tablica, która zawiera adresy procedur obsługi przerwania. Kiedy procesor otrzyma informację o przerwaniu, kończy wykonywać aktualną instrukcję. Następnie wrzuca na stos kernela **adres powrotny** oraz informacje o stanie procesora które pozwolą zrestartować przerwany program, szuka w wektorze przerwań adresu procedury obsługi przerwania odpowiedniej dla numeru przerwania który otrzymał i przekazuje jej kontrolę. 

Po natrafieniu na instrukcję powrotu z przerwania, przywraca odpowiedni stan procesora i rejestrów danych, wraca do user mode i przywraca kontrolę przerwanemu programowi.

## Zadanie 3
![](https://i.imgur.com/Fitu5zt.png)
ELF Header - najważniejsze informacje o pliku, które pozwalają na parsowanie i interpretację pliku wykonywalnego.
![](https://i.imgur.com/M6JuIkX.png)

Segment header table - opisane wszystkie segmenty oraz relacja segmentów i sekcji
![](https://i.imgur.com/iq8wupH.png)

Section header table - informacje o sekcjach
![](https://i.imgur.com/FMR24t6.png)
![](https://i.imgur.com/kzrNjOp.png)

Różnica między segmentami a sekcjami: 
sekcja zawiera statyczne dane dla linkera (czy sekcja to dane do załadowania do pamięci - np. .data, .text lub metadata o innych sekcjach której linker użyje ale dane znikną podczas runtime - np. .symtab, .srttab)
segment zawiera dynamiczne informacje dla systemu operacyjnego (gdzie należy załadować go do pamięci wirtualnej, jakie ma pozwolenia)

## Zadanie 4
Na początku działania programu jądro musi odpowiednio ustawić flagi jednostek zmiennoprzecinkowych SSE2, x87) i flagi rejestru stanu (rFLAGS) oraz odpowiednio ustawić stos.

Na stosie musi znajdować się (od dołu):
argc - liczba argumentów
argv[] - wskaźniki na argumenty (argv[argc] = NULL)
envp[] - wskaźniki na zmienne srodowiskowe (też zakończone NULLem)
auxiliary vector (również kończy sie nullem)
padding
blok informacji - argumenty, zmienne środowiskowe

![](https://i.imgur.com/DYc49Au.png)

auxiliary vector służy do komunikacji programowi pewnych informacji z poziomu kernela. Np AT_PAGESZ trzyma rozmiar strony w bajtach a AT_UID prawdziwe user ID procesu
![](https://i.imgur.com/fJNhZ3Z.png)

Aby wywołać funkcję jądra należy użyć wywołania systemowego. Interfejs kernela używa rejestrów *%rdi*, *%rsi*, *%rdx*, *%r10*, *%r8* i *%r9*, przez co wywołania systemowe ograniczone są do 6 argumentów. Numer syscalla należy umieścić w rejestrze *%rax*, który będzie też zawierał wynik syscalla. Wartość pomiędzy -4095 a -1 oznacza błąd syscalla

