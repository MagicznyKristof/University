package wyrazenie.op2arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Maksimum reprezentuje wyrazenie maksymalne z  dwoch  wyrazen
 * @author Krzysztof
 * 
 */
public class Maksimum extends Operator2Arg{
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	@Override
	public double oblicz(){
		return Math.max(x.oblicz(),y.oblicz());
	}

	public Maksimum (Wyrazenie x,Wyrazenie y){
		super(x,y);
	};
	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */    
	@Override
	public String toString() {
		return "max("+x+" ,"+y+")";
	}
}