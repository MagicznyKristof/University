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
}
/*
public class Odcinek
{
	Punkt Punkt1, Punkt2;
	*/
