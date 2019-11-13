package wyrazenie.op1arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Przeciwienstow reprezentuje wartosc przeciwna do argumentu 
 * @author Krzysztof
 * 
 */
public class Przeciwienstwo extends Operator1arg{   
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */
	@Override
	public double oblicz(){
		return -x.oblicz();
	}

	public Przeciwienstwo (Wyrazenie x){
		super(x);
	};

	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */       
	@Override
	public String toString() {
		return "(-"+x+")";
	}
}