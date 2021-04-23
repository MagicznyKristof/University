# Lista 6

###### tags: `SO`

## Zadanie 1

**tożsamość** - identyfikator, który określa czy użytkownik ma pozwolenie na dostęp do danego zasobu

Nasz proces ma początkową tożsamość:
real uid = 1000;
effective uid = 0;
saved uid = 0.

**a) setuid(2000)**
Dostaniemy
real uid = 2000;
effective uid = 2000;
saved uid = 2000.

Dzieje się tak ponieważ
> The setuid() system call is permitted if the specified ID is equal to the real user ID or the effective user ID of the process, or if the effective user ID is that of the super user.

Tzn setuid zadziała tylko kiedy ID na które chcemy zmienić jest równe ruid lub suid albo effective uid jest UID superusera (0, co jest prawdą)

**b) setreuid(-1 2000)**
Dostaniemy
real uid = 1000;
effective uid = 2000;
saved uid = 2000.

Dzieje się tak ponieważ
>  The real and effective user IDs of the current process are set according to	the arguments. If ruid or euid is -1, the current uid is filled in by the system.
>  If the real user ID is changed (i.e. ruid is not -1) or the effective user ID is	changed	to something other than	the real user ID, then the saved user	ID will	be set to the effective	user ID.

Tzn setreuid może zmienić zarówno real jak i effective uid a jeśli jeden z argumentów jest -1, to tego argumentu nie zmienia. Tzn tutaj zmieni euid na 2000 a ruid zostawi. Do tego ponieważ euid się zmieniło, to tak samo zmieni się suid.

**c) seteuid(2000)**
Dostaniemy:
real uid = 1000;
effective uid = 2000;
saved uid = 0.

Dzieje się tak ponieważ:
> The seteuid() system call (setegid()) sets the effective user ID of the	current	process. The effective	user ID	may be set to the value of the real user ID or the saved set-user-ID.

Czyli ponieważ UID na które chcemy ustawić euid nie jest równe ani ruid ani suid, wywołanie zwróci błąd.


**d) setresuid(-1, 2000, 3000)**
Dostaniemy:
real uid = 1000;
effective uid = 2000;
saved uid = 3000.

Dzieje się tak ponieważ:
>The setresuid() system call sets the real,	effective and saved user IDs of	the current process.
>Privileged	processes may set these	IDs to arbitrary values. Unprivileged processes are restricted in that each of the new IDs must match one of the current IDs.
>Passing -1	as an argument causes the corresponding	value to remain	unchanged.

Tzn setresuid() ustawia nam wszystkie 3 wartości. Ponieważ proces jest uprzywilejowany (euid = 0), to może sobie ustawić te wartości jak tylko chce. 

> Czy proces z tożsamością ruid=0, euid=1000, suid=1000 jest uprzywilejowany? Odpowiedź uzasadnij.
Nie, nie jest uprzywilejowany (ale nie do końca). Real user ID to "prawdziwa" tożsamość procesu, natomiast wzystkie procesy które wymagają bycia uprzywilejowanym patrzą na effective user ID. Jest to po to, żeby proces mógł tymczasowo przyjmować tożsamosć innego użytkownika (np. roota). Więc w tym przypadku mamy proces roota, który tymczasoo przyjął tożsamość procesu o UID 1000 i obecnie nie jest uprzywilejowany.


## Zadanie 2
> Jaką rolę pełnią bity uprawnień *«rwx»* dla katalogów w systemach uniksowych?

r - czy możemy czytać zawartość pliku katalogu, tzn dostać listę wszystkich plików w katalogu;
w - czy możemy modyfikować zawartość pliku katalogu, tzn czy możemy dodawać, usuwać, zmieniać nazwy plików które się w nim znajdują (niezależnie od tego czy jesteśmy właścicielem pliku!);
x - czy możemy czytać metadane plików w katalogu, przeczytać zawartość pliku lub przejść do podkatalogu (jeśli znamy nazwę);
set-gid - jeśli bit jest ustawiony, to nowe pliki dziedziczą grupę katalogu a nowe podkatalogi dziedziczą ten bit;
sticky - *restricted deletion*, ustawienie tego bitu oznacza, że nieuprzywilejowany proces może unlinkować lub usuwać pliki z katalogu tylko jeśeli ma pozwolenie w ORAZ jest właścicielem ablo pliku albo katalogu. Dzięki temu możemy stwoerzyć katalog dzielony przez wielu użytkowników w którym każdy może tworzyć i usuwać swoje pliki ale nie może usuwać cudzych. */tmp* ma taki bit.

*struct stat sb* to wskaźnik wskazujący na strukturę stat, w której trzymamy informacje o pliku
*int mode* mówi jakie sprawdzenie dostępu mamy wykonać. Jest równa wartości **F_OK** (czy plik istnieje) lub maski składającej się z bitowych ORów **R_OK**, **W_OK** i **X_OK**  (read, write i execute)

Pseudokod (bardzo nieformalnie)
1. Ustal tożsamość procesu za pomocą *getuid* i *getgroups*.
2. Sprawdź co jest w *mode*.
3. Jeśli *mode* jest **F_OK**, to sprawdź tylko czy plik istnieje
4. W przeciwnym przypadku (tzn w *mode* jest maska składająca się z **R_OK**, **W_OK** i **X_OK**):
    * sprawdź czy proces jest właścicielem porównując UID procesu z UID pliku z *sb*
    * jeśli jest właścicielem, sprawdź czy właściciel posiada wszystkie potrzebne pozwolenia. Jeśli je posiada to zwróć 0, wpp. kontynuuj
    * sprawdź czy grupa procesu ma pozwolenie do pliku z *sb* porównując GID procesu i GID pliku. Jeśli jest to sprawdź czy posiada wszystkie potrzebne pozwolenia (bez tych które proces już ma z poprzedniego kroku). Jeśli je posiada to zwróć 0, wpp. kontynuuj
    * sprawdź czy każdy użytkownik posiada pozwolenia które są potrzebne procesowi. Jeśli posiada to zwróć 0, w przeciwnym przypadku wyrzuć błąd braku pozwolenia


## Zadanie 3

> Jaką tożsamość będzie miał na początku proces wykonujący «su», jeśli przed execve(2) było euid=1000?

ruid -> będzie wzięty z właściciela procesu (1000?)
euid -> 0
suid -> 0

dupa dupa

## Zadanie 4

Programy uprzywilejowane należy projektować w sposób *the least privilege* ze względów bezpieczeństwa. Program który ma istotne uprawnienia może zostać przejęty przez wrogiego agenta i zacząć robić złe rzeczy. Żeby zminimalizować ryzyko, powinien posiadać te przywileje tak krótko jak to możliwe.

Osiągamy to stosując te wytyczne:
* Trzymanie przywilejów tylko wtedy kiedy potrzeba. Tzn jeśli program uprzywilejowany i idzie robić rzeczy do których nie potrzeba przywilejów to oddaje je dopóki nie będzie ich znowu potrzebować. ![](https://i.imgur.com/NIpFe3U.png)

* Jeśli program nie będzie potrzebować tych przywilejów już nigdy to powinien całkowicie się ich pozbyć. Aby to zrobić musi zresetować wszystkie swoje UID, ale nie jest to najłatwiejsze. Jeśli program ma przywileje *roota*, to wygląda to tak ![](https://i.imgur.com/8BDzeu1.png) Jeśli właścicielem (euid i suid) jest inny użytkownik (nie root) to musimy użyć *setreuid* w ten sposób ![](https://i.imgur.com/1D1bR8G.png) Podobnie dla gid musimy użyć analogicznych komend

* Dodatkowo przy zmianie przywileju powinniśmy:
    *  starać się używać lokalnych dla danego systemu wywołań ponieważ semantyka wywołań które działają na wielu systemach często różni się między systemami co może powodować błędy. Czyli np na Linuxie lepiej użyć *setresuid* i *setresgid* do zmiany uid i gid
    *  zawsze sprawdzać czy zmiana id się powiodła i czy przebiegła tak jak chcieliśmy
    *  jeżeli zmieniamy kilka id na raz, to te z największym przywilejem powinniśmy zmienić na końcu ponieważ niektóre zmiany mogą wymagać większych pozwoleń które utracimy zmieniając id z największym przywilejem wcześniej.
---
Jeśli *exec*ujemy program to również należy zwrócić uwagę na kilka rzeczy:
* przed execiem należy oddać posiadane przywileje na stałe żeby mieć pewność że nowy program nie wystartuje z większymi przywilejami niż powinien. Możemy zamiast tego zrobić *setuid(getuid())* (analogicznie z gid) przed wywołaniem. Ustawi to tylko euid, ale exec kopiuje wartość z euid do suid.
* nigdy nie należy execować shella z przywiejami. 
* zamknąć wszystkie deskryptory plików przed *execem*

---

> czemu standardowy zestaw funkcji systemu uniksowego do implementacji programów uprzywilejowanych jest niewystarczający

Jest zbyt prosty. Programy dzielą się na dwa rodzaje: te będące superuserem i te niebędące nim. Jeżeli proces potrzebuje wykonać operacje superusera i dostaje jego przywileje, to jednocześnie pozwala mu to na zrobienie wielu innych, potencjalnie bardzo niebezpiecznych rzeczy. Zdolności zapobiegają temu dzieląc przywileje superusera na kilka części (to właśnie zdolności). Każda upzywilejowana operacja jest powiązana z jakaś zdolnością i proces może ją wykonać tylko jeżeli posiada tą zdolność

CAP_DAC_READ_SEARCH pozwala procesowi pominąć sprawdzenie uprawnień odczytu do pliku/katalogu oraz uprawnienńwykonania do katalogu. Czyli proces z tą zdolnością będzie mógł odczytać plik i otworzyć katalog do którego nie ma uprawnień
CAP_KILL pozwala procesowi zignorować pozwolenia do wysyłania sygnałów procesowi. Wtedy proces użytkownika może wysyłać sygnały innym procesom.



