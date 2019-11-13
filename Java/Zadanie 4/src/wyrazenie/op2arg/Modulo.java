package wyrazenie.op2arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Modulo reprezentuje wyrazenie obliczone z modulem dwoch  wyrazen
 * @author Krzysztof
 * 
 */
public class Modulo extends Operator2Arg{    
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	@Override
	public double oblicz(){
		if (y.oblicz()==0) throw new  IllegalArgumentException("Dzielenie przez Zero");
		return x.oblicz()%y.oblicz();
    }

	public Modulo (Wyrazenie x,Wyrazenie y){
		super(x,y);
	};

	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */
	@Override
	public String toString() {
		return "("+x+" mod "+y+")";
	}
}
