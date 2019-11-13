package wyrazenie.op1arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa Odrotnosc reprezentuje wartosc odwrotna 
 * @author Krzysztof
 
 */
public class Odwrotnosc extends Operator1arg{
	/**
	 * Oblicza wyrazenie dla podanej klasy
	 * @return Wynik wyrazenia
	 */   
	@Override
	public double oblicz(){
		if (x.oblicz()==0) throw new IllegalArgumentException("Dzielenie przez zero");
		return 1/x.oblicz();
	}
	
	public Odwrotnosc (Wyrazenie x){
		super(x);
	};

	/**
	 * 
	 * @return Reprezentacja wyrazenia 
	 */       
	@Override
	public String toString() {
		return "(1/"+x+")";
	}    
}