package wyrazenie.op1arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Sinus reprezentuje Sinusa w podanym punkcie
 * @author Krzysztof
 * 
 */
public class Cosinus extends Operator1arg{
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	@Override
	public double oblicz(){
		return Math.cos(x.oblicz());
	}

	public Cosinus (Wyrazenie x){
		super(x);
	};
	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */       
	@Override
	public String toString() {
		return "cos("+x+")";
	}
}