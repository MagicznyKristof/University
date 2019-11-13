public class Rzymskie {
	private static String[] rzymskie = {
		"M", "CM", "D", "CD", "C","XC", "L", "XL", "X", "IX", "V", "IV", "I"
		};

	private static int[] arabskie = {
		1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
	};

	public final int x;

	public String toString(){
		String liczba = "";

			int tmp = x;
			int miejsce = 0;
			
			if( tmp < 5000 ){
				while( tmp > 0 ){    
					while( tmp >= arabskie[miejsce] ){
						liczba += rzymskie[miejsce];
						tmp -= arabskie[miejsce];
					}
					miejsce++;
				}
			}
		return liczba;
	}
	public Rzymskie(int x){
		this.x = x;
		if( x<1 || x>4999 ) throw new IllegalArgumentException("liczba " + x + " spoza zakresu 1-4999");
	}
}
