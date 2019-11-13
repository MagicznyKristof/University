package Narzedzia.op0arg;

import Narzedzia.Exception.UnknownSymbolONP;
import Narzedzia.Exception.ExceptionONP;
import Narzedzia.Calc.Operand;
import java.util.Objects;
import java.util.regex.Pattern;

/**
 * Klasa przechowujaca zmienne wraz z ich wartosciami, klucz-wartosc
 * @author magicznykrzysztof
 */
public class Variable extends Operand {
    String x;
    double val;
    
    
    public String getX() {
        return x;
    }
    
    /**
     * @param c Nazwa zmiennej
     * @param l Wartosc
     * @throws ExceptionONP Wyrzuca wyjatek jesli nazwa zmiennej nie pasuje to wzorca 
     */
    public Variable(String c,double l) throws ExceptionONP{
        if(!Pattern.matches("\\p{Alpha}\\p{Alnum}*", c)) throw new UnknownSymbolONP();
	x=c;
        val=l;
    }
    /**
     * @return Zwraca wartosc zmiennej 
     */
    @Override
    public double value(){
	return val;
    }
    /**
     * Porownuje czy obiekt jest taki sam, wzgledem zmiennej
     * @param obj
     * @return Czy zmienne są takie same
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Variable other = (Variable) obj;
        return Objects.equals(this.x, other.x);
    }
}