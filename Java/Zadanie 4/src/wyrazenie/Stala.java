package wyrazenie;

/**
 * Klasa Stala reprezentuje liczbe.
 * @author Krzysztof
 * 
 */
public class Stala extends Wyrazenie {
	private final double x;
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	@Override
	public double oblicz(){
		return x;
	}

	public Stala(double x){
		this.x=x;
	}

	@Override
	public String toString() {
		return x+"";
	}
}