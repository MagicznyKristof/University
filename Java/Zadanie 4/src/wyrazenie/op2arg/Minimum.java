package wyrazenie.op2arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Minimum reprezentuje minimalna wartosc w dwoch wyrazen
 * @author Krzysztof
 * 
 */
public class Minimum extends Operator2Arg {
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	@Override
	public double oblicz(){
		return Math.min(x.oblicz(),y.oblicz());
	}

	public Minimum (Wyrazenie x,Wyrazenie y){
		super(x,y);
	};

	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */   
	@Override
	public String toString() {
		return "min("+x+" , "+y+")";
	}
}