package wyrazenie;

/**
 * Klasa zbior przechowuje obiekty typu Para
 * @author Krzysztof
 * 
 */
public class Zbior {
	private int rozmiar;
	private int wpisane; 
	private  Para [] zbior;

	/**
	 * Konstruktor jedno-argumentowy
	 * @param rozmiar Przydzielnie rozmiaru zbioru
	 */
	public Zbior(int rozmiar){
		zbior=new Para[rozmiar];
		this.rozmiar=rozmiar;
		wpisane=0;
	}
	/**
	 * Konstruktor domyslny, przydziela rozmiar zbioru na 10 par
	 */
	public Zbior(){
		zbior=new Para[10];
		this.rozmiar=10;
		wpisane=0;
	}

	/**
	 * Metoda usuwa podaną Pare w argumencie ze zbioru
     * @param kl Usuwanie po kluczu String
     */
	public void usun(String kl){
		if (!sprawdz(kl)) throw new IllegalArgumentException ("Nie ma takiej pary");
		for(int i=0;i<wpisane;i++){
			if ((zbior[i].klucz.equals(kl))&&(i<wpisane-1)) {
				zbior[i]=zbior[wpisane-1];
				zbior[wpisane-1]=null;
				wpisane--;
			}
			else if(i==wpisane-1){
				zbior[wpisane-1]=null;
				wpisane--;
			}
            
		}
	}
    /**
     *  metoda sprawdza czy podany klucz istnieje
     */
	private boolean sprawdz(String a){
		for(int i=0;i<wpisane;i++)
			if(zbior[i].klucz.equals(a)) return true;
		return false;
	}
    
    /**
     * metoda sprawdza czy zostal przekroczony zakres tablicy
     */
	private boolean zakres(){
		if (wpisane>=rozmiar) return true;
		return false;
	}
    
	/** 
	 * metoda szuka pary z określonym kluczem      
	 * @param kl klucz typu string
	 * @return Zwraca obiekt typu Para
	 * @throws IllegalArgumentException
	 *      Jesli nie ma takiej pary (@link IllegalArgumentException)
	 */
	public Para szukaj (String kl) throws IllegalArgumentException {
		if (!sprawdz(kl)) throw new IllegalArgumentException ("Nie ma takiej pary");
		for(int i=0;i<wpisane;i++)
			if (zbior[i].klucz.equals(kl)) return zbior[i]; 
		return null;
	}

	/** 
	 * Metoda wstawia do zbioru nową parę      
	 * @param p Obiekt ktory ma być wstawiony do zbioru
	 * @throws IllegalArgumentException
	 * Jesli przekroczymy zakres lub istnieje juz taka para (@link IllegalArgumentException)
	 */
	public void wstaw (Para p) throws IllegalArgumentException {
		if(sprawdz(p.klucz)) throw new IllegalArgumentException ("Istnieje taka para z podanym kluczem");
		if(zakres()) throw new IllegalArgumentException ("Przekroczono zakres");
		zbior[wpisane]=p;
		wpisane++;
	}

	/** 
	 * Metoda odszukuje parę i zwraca wartość związaną z kluczem      
	 * @param kl Klucz po ktorym nalezy wyszukac wartosc
	 * @throws IllegalArgumentException
	 * Jesli takiej pary nie ma w zbiorze (@link IllegalArgumentException)
	 * @return Zwraca <b>wartosc</b> pary typu double 
	 */
	public double czytaj (String kl) throws IllegalArgumentException {
		if (!sprawdz(kl)) throw new IllegalArgumentException ("Nie ma takiej pary");
		for(int i=0;i<wpisane;i++)
			if (zbior[i].klucz.equals(kl))
				return zbior[i].getter();
		return 0;        
	}

	/** 
	 * Metoda wstawia do zbioru nową albo aktualizuje istniejącą parę 
	 * @param p Wstawia podana pare to zbioru
	 */
	public void ustal (Para p) throws IllegalArgumentException {
		if (sprawdz(p.klucz)){
			for(int i=0;i<wpisane;i++)
				if (zbior[i].klucz.equals(p.klucz)) {
					zbior[i]=p;
				}                  
        }
		else{
			wstaw(p);
		}
	}

	/** 
	 * Metoda podaje ile par jest przechowywanych w zbiorze      
	 * @return Zwraca wartosc, ile par znajduje sie w zbiorze
	 */
	public int ile () {
		return wpisane;
	}
    
    /**
     *  Metoda usuwa wszystkie pary ze zbioru 
     */
	public void czysc () {
		zbior=null;
		wpisane=0;
	}
}