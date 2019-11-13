import geometria.Punkt;

public class Zadanie3 {
	public static void main(String[] args) {
		double x, y;
		Punkt a;
		
		for (int i=0; i < args.length; i+=2){
			try{
				x = new Double( args[i] );
				y = new Double( args[i+1] );
				a = new Punkt( x, y );
				System.out.println( a.toString() );
			}catch ( IllegalArgumentException q ){ q.printStackTrace( ); }
		}
	}
}
			
