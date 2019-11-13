import java.util.ArrayList;
import java.util.List;


public final class liczbypierwsze
{
	private final static int POTEGA2 = 20 ;
	private final static int[] SITO = new int[1<<POTEGA2] ;
	private final static List<Long> tablica = new ArrayList<Long>();
	
	static{
		
		for( int i = 2; i * i < SITO.length; i++ )
			if( SITO[i] == 0 )
				for( int j = i; j < SITO.length; j += i )
					if( SITO[j] == 0 )
						SITO[j] = i;
	}
	
	
	public static boolean czyPierwsza (long x)
	{
		return SITO[(int)x] == 0;
	}
		
	public static long[] naCzynnikiPierwsze (long x)
		{
			long tmp = x;
			tablica.clear();
			
			if( tmp == 0 || tmp == 1 || tmp == -1){
				tablica.add( tmp );
				return tablica.stream().mapToLong(i -> i).toArray();
			}
			if( tmp < -1 )
				tablica.add( -1L );
			
			while( tmp %2 == 0 ){
				tablica.add( 2L );
				tmp /= 2;
			}
			if( tmp <= -1 )
				tmp = tmp * -1;
			int i = 3;
			
			while( tmp > SITO.length )
			{
				while( tmp % i == 0 ){
					tablica.add( (long)i );
					tmp /= i;
					if( x > SITO.length )
						break;
				}
				i += 2;
				if( i > SITO.length ){
					tablica.add( tmp );
					tmp = 0;
					break;
				}
				while( SITO[i] != 0 ){
					i+=2;
					if( i > SITO.length ){
					tablica.add( tmp );
					tmp = 0;
					break;
					}
				}
			}
			
			while( !czyPierwsza( tmp ) ){
				tablica.add( (long)SITO[(int)tmp] );
				tmp /= SITO[(int)tmp];
			}
			//tablica.add( tmp );
			
			return tablica.stream().mapToLong(j -> j).toArray();
				
	}
	public static String toString(long x){
		String napis = "";
		naCzynnikiPierwsze( x );
		napis = napis + tablica.get(0);
		for( int i = 1; i < tablica.size(); i++ )
			napis = napis + " * " + tablica.get(i);
		napis = napis + "\n";
		return napis;
	}
		
		
}
