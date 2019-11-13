package Narzedzia.Exception;

/**
 * Klasa Wyjatek wyrazenia ONP gdy liczba jest dzielona przez 0
 * @author magicznykrzysztof
 */
public class DivisionByZeroONP extends ExceptionONP {
    public DivisionByZeroONP (String x){
        super(x);
    }

    public DivisionByZeroONP() {
        this("Division by Zero");
    }
   
    @Override
    public String toString ()
    {
        return "Division by Zero in the expression ONP";
}
}