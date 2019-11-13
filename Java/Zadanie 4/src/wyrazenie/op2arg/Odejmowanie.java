package wyrazenie.op2arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Odejmowanie reprezentuje wyrazenie odejmowania dwoch  wyrazen
 * @author Krzysztof
 * 
 */
public class Odejmowanie extends Operator2Arg{
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */  
	@Override
	public double oblicz(){
		return x.oblicz()-y.oblicz();
	}

	public Odejmowanie (Wyrazenie x,Wyrazenie y){
		super(x,y);
	};
	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */       
	@Override
	public String toString() {
		return "("+x+"-"+y+")";
	}
}