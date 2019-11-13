package wyrazenie.op1arg;

import wyrazenie.Wyrazenie;


/**
 * Klasa Arctan reprezentuje Arctangens w podanej wartosci
 * @author Krzysztof
 * 
 */
public class Arctan extends Operator1arg{
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */    
	@Override
	public double oblicz(){
		return Math.atan(x.oblicz());
	}

	public Arctan (Wyrazenie x){
		super(x);
	};
	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */       
	@Override
	public String toString() {
		return "arctag("+x+")";
	}
}