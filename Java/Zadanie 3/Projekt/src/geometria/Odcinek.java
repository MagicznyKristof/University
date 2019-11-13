package geometria;

public class Odcinek {
	private Punkt P1, P2;
	
	public Odcinek( double P1x, double P1y, double P2x, double P2y ){
		this.P1 = new Punkt(P1x, P1y);
		this.P2 = new Punkt(P2x, P2y);
		if( P1x == P2x && P1y == P2y ) throw new IllegalArgumentException( "punkty są sobie równe" );
		
	}
	public String toString(){
		String wyjscie = "punkty odcinka maja wsporzedne:\na = " + P1.toString() + "\nb = " + P2.toString();
		return wyjscie;
	}
	
	public void przesun( Wektor v )
	{
		P1.przesun(v);
		P2.przesun(v);
	}
	
	public void obroc( Punkt p, double kat )
	{
		P1.obroc(p, kat);
		P2.obroc(p, kat);
		
	}
	
	public void odbicie( Prosta p )
	{
		P1.odbicie(p);
		P2.odbicie(p);
	}
}
