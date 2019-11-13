package geometria;

public class Prosta {
	public final double a, b, c;
	
	public Prosta( double a, double b, double c )
	{
		this.a = a;
		this.b = b;
		this.c = c;
	}
	
	public String toString(){
		String wyjscie = "Prosta ma wzor " + a + "x + " + b + "y + " + c;
		return wyjscie;
	}
	
	public static Prosta przesun ( Prosta p, Wektor w) 
	{
		return new Prosta ( p.a, p.b, p.c+ p.a * w.dx + p.b * w.dy );
	}
	
	public static boolean czyrownolegle( Prosta p, Prosta q )
	{
		return( p.b/p.a == q.b/q.a );
	}
	
	public static boolean czyprostopadle( Prosta p, Prosta q )
	{
		return( (p.b/p.a) * (q.b/q.a) == -1);
	}
	
	public static Punkt przeciecie( Prosta p, Prosta q )
	{
		if ( czyrownolegle( p, q ) ) throw new IllegalArgumentException( "proste sa rownolegle" );
		
		double det = p.a * q.b - p.b * q.a;
		return new Punkt( ((1/det) * (( q.b * (-1) * p.c) - q.b * q.c)), ((1/det) * (( q.a * p.c) - p.a * (-1) * q.c)));
	}
}
