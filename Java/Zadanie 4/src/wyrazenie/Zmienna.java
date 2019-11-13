package wyrazenie;

/**
 * Klasa Zmienna przechowująca nazwe zmiennej oraz zbior zmiennych.
 * @author Kamil
 * 
 */
public class Zmienna extends Wyrazenie{
	public static final Zbior zmienne=new Zbior();
	String x;
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	@Override
	public double oblicz(){
		return zmienne.czytaj(x);
	}

	public Zmienna(String x){
		this.x=x;
	}

	@Override
	public String toString() {
		return x;
	}
}