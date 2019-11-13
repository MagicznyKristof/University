public class liczbyrzymskie {
	public static void main(String[] args)  {
		int liczba = 0;
		Rzymskie x;

		for (int i=0; i < args.length; i++){   
			try{
				liczba = new Integer( args[i] );
				x = new Rzymskie(liczba);
				System.out.println(args[i] + " " + x);
			}catch ( NumberFormatException a){ System.out.println( "Nie mozna przekonwertowac liczby" ); }
			catch ( IllegalArgumentException a ){ a.printStackTrace( ); }
		}
	}
}
