package geometria;

public class Wektor {
	public final double dx, dy;
	
	public Wektor( double x, double y )
	{
		this.dx = x;
		this.dy = y;
	}
	
	public String toString(){
		String wyjscie = dx + ", " + dy;
		return wyjscie;
	}
	
	public static Wektor zloz( Wektor a, Wektor b )
	{
		return new Wektor( a.dx + b.dx, a.dy + b.dy );
	}
}
