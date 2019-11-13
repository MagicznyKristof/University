import geometria.*;

public class Zad3 {
	public static void main(String[] args) {
		double x, y;
		Punkt a, c;
		Odcinek AB;
		Trojkat ABC;
		Wektor v, w;
		Prosta p;
		
		x = 5.0;
		y = 5.0;
		a = new Punkt( x, y );
/*		AB = new Odcinek( x, y, x, y );*/
		AB = new Odcinek( x, y, x, y+1 );
/*		ABC = new Trojkat(x, y, x, y, x, y+1);*/
/*		ABC = new Trojkat(x, y, x, y+1, x, y+2);*/
		c = new Punkt(x+1, y);
		ABC = new Trojkat(x, y, x, y+1, x+1, y);
		System.out.println( a.toString() );
		System.out.println( AB.toString() );
		System.out.println( ABC.toString() );
		v = new Wektor( 1, 1 );
		w = new Wektor( 1, 1 );
		v = Wektor.zloz(v, w);
		System.out.println( v.toString() );
		p = new Prosta( 2, 3, 4 );
		//System.out.print(czyrownolegle(p, q));
		ABC.przesun(v);
		System.out.println( ABC.toString() );
		a.obroc(c, Math.PI/2);
		AB.odbicie(p);
		System.out.println( a.toString() );
		System.out.println( AB.toString() );
		System.out.println( ABC.toString() );
			
		
	}
}
			