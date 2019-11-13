package geometria;

public class Trojkat {
	public Punkt P1, P2, P3;
	
	public Trojkat( double P1x, double P1y, double P2x, double P2y, double P3x, double P3y ){
		this.P1 = new Punkt(P1x, P1y);
		this.P2 = new Punkt(P2x, P2y);
		this.P3 = new Punkt(P3x, P3y);
		if( P1x == P2x && P1y == P2y ) throw new IllegalArgumentException( "punkty są sobie równe" );
		if( P1x == P3x && P1y == P3y ) throw new IllegalArgumentException( "punkty są sobie równe" );
		if( P3x == P2x && P3y == P2y ) throw new IllegalArgumentException( "punkty są sobie równe" );
		if( (P1y - P2y)/(P1x - P2x) == (P1y - P3y)/(P1x - P3x)) throw new IllegalArgumentException( "punkty są wspolliniowe" );
	}
	
	public String toString(){
		String wyjscie = "punkty trojkata maja wspolrzedne:\na = " + P1.toString() + "\nb = " + P2.toString() + "\nc = " + P3.toString();
		return wyjscie;
	}
	
	public void przesun( Wektor v )
	{
		P1.przesun(v);
		P2.przesun(v);
		P3.przesun(v);
	}
	
	public void obroc( Punkt p, double kat )
	{
		P1.obroc(p, kat);
		P2.obroc(p, kat);
		P3.obroc(p, kat);
		
	}
	
	public void odbicie( Prosta p )
	{
		P1.odbicie(p);
		P2.odbicie(p);
		P3.odbicie(p);
	}
}
