public class zadanie2 {
	
	static long liczba = 0;
	static String x;
	public static void main(String[] args){

		if(args.length == 0)
			System.err.println("Podaj liczbę do rozłożenia");
			
		for (int i=0; i < args.length; i++){
				liczba = Long.parseLong( args[i] );
				x = liczbypierwsze.toString( liczba );
				System.out.println( args[i] + " = " + x);
		}
	}
}
