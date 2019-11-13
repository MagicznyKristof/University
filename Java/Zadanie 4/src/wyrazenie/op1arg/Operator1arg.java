package wyrazenie.op1arg;

import wyrazenie.Wyrazenie;

/**
 * Klasa abstrakcyjna reprezentujaca wyrazenia z jednym argumentem
 * @author Krzysztof
 * 
 */
public abstract class Operator1arg extends Wyrazenie{
	protected final Wyrazenie x;

	public Operator1arg (Wyrazenie arg1) {
		if (arg1==null) throw new IllegalArgumentException();
		x = arg1;
	}
}