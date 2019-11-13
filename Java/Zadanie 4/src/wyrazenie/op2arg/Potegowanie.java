package wyrazenie.op2arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Potegowanie reprezentuje wyrazenie potegowania wyrazenia
 * @author Krzysztof
 * 
 */
public class Potegowanie extends Operator2Arg{
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */ 
	@Override
	public double oblicz(){
		return Math.pow(x.oblicz(),y.oblicz());
	}

	public Potegowanie (Wyrazenie x,Wyrazenie y){
		super(x,y);
	};
	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */       
	@Override
	public String toString() {
		return "("+x+" ^ "+y+")";
	}
}