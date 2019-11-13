package wyrazenie;

/**
 * Klasa Para tworzy pare z dwoch argumentow,  wartosci: String (Klucz) i Double(wartosc). String jest obiektem zadeklarowanym publicznie
 * i przechowuje klucz według ktorego mozemy szykac pary.
 * @author Krzysztof
 */

public class Para {
	public final String klucz;
	private double wartosc;
	/**
	* Konstruktor jedno-argumentowy
	* @param s Klucz typu @link String 
	*/
	public Para(String s){
		klucz=s;
	}
	/**
	 * Konstruktor dwu-argumentowy
	 * @param s Klucz typu @link String
	 * @param x Wartosc dla zmiennej <b>s</b>
	 */    
	public Para(String s, double x){
		this(s);
		wartosc=x;
	}
	/**
	 * Zwraca <b>wartosc</b> 
	 * @return wartosc
	 */
	public double getter(){
		return wartosc;
	}
	/**
	 * Nadaje <b>wartosc</b> ktora przyjmuje w argumencie
	 * @param r Argument ktory przypisujemy <b>wartosc</b> 
	 */
	public void setter(double r){
		wartosc=r;
	}
	/**
	 * 
	 * @return Zwraca napis obiektu 
	 */
	@Override
	public String toString(){
		return klucz+"->"+wartosc;
	}

	/**
	 * Metoda porownuje obiekty
	 * @param o Przyjmuje obiekt <b>Para</b> jako parametr
	 * @return zwraca wartosc <b>True</b> jesli Pary sa rowne (posiadaja takie same wartosci), wpp. <b>False</b>  
	 */
	@Override
	public boolean equals(Object o){
		if(this==o) return true;
		if ((o == null)||(getClass() != o.getClass())) return false;
		Para para= (Para) o;
		return wartosc==para.wartosc;
	
	}
}