package wyrazenie.op1arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa WartBezwzgl reprezentuje wyrazenie wartosci bezwzglednej
 * @author Krzysztof
 * 
 */
public class WartBezwzgl extends Operator1arg{    
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */    
	@Override
	public double oblicz(){
		return Math.abs(x.oblicz());
	}

	public WartBezwzgl (Wyrazenie x){
		super(x);
	};

	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */       
	@Override
	public String toString() {
		return "(|"+x+"|)";
	}
}