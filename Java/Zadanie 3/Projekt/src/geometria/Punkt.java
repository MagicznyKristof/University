package geometria;

public class Punkt
{
	private double x, y;
	
	public String toString(){
		String wyjscie = x + ", " + y;
		return wyjscie;
	}
		
	public Punkt( double x, double y )
	{
		this.x = x;
		this.y = y;
	}
	
	public void przesun( Wektor v )
	{
		x = x + v.dx;
		y = y + v.dy;
	}
	
	public void obroc( Punkt p, double kat )
	{
		double x0 = p.x;
		double y0 = p.y;
		double oldx = x;
		
		x = (x - x0)*Math.cos(kat) - (y - y0)*Math.sin(kat) + x0;
		y = (oldx - x0)*Math.sin(kat) + (y - y0)*Math.cos(kat) + y0;
	}
	
	public void odbicie( Prosta p )
	{
		Prosta prostopadla = new Prosta (p.a, -p.b, p.b * y - p.a * x);
		Punkt a = Prosta.przeciecie(p, prostopadla);
		x = 2 * a.x - x;
		y = 2 * a.y - y;
	}
	
	
}