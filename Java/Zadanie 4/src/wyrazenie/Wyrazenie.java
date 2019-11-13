package wyrazenie;
/**
 * Abstrakcyjna klasa Wyrazenie
 * @author Krzysztof
 * 
 */
abstract public class Wyrazenie {
    
	/** Metoda sumujaca wyrazenia 
	 * @param args Ciag wyrazen 
	 * @return Wynik operacji sumowania argumentow
	 */
	public static double sumuj (Wyrazenie...args) {
		double suma=0;
		for (Wyrazenie arg : args) {
			suma = suma + arg.oblicz();
		}
		return suma;
	}

	/** Metoda mnozaca wyrazenia
	 * @param args Ciag wyrazen
	 * @return wynik operacji wymnozenia argumentow
	 */
	public static double pomnoz (Wyrazenie...args){
		double suma=0;
		for (Wyrazenie arg : args) {
			suma = suma * arg.oblicz();
		}
		return suma;
	}
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	abstract public double oblicz();
	
	/**
	 * Porownanie obiektow
	 * @return  True lub False
	 */
	@Override
	public boolean equals(Object o){
		if(this==o) return true;
		if ((o == null)||(getClass() != o.getClass())) return false;
		Wyrazenie wyrazenie= (Wyrazenie) o;
		return oblicz()==wyrazenie.oblicz();
	}
}