package Narzedzia.Exception;

/**
 * Klasa Wyjatek wyrazenia ONP gdy te wyrazenie jest niepoprawne
 * @author magicznykrzysztof
 */
public class IncorrectExpressionONP extends ExceptionONP{
    public IncorrectExpressionONP (String x){
        super(x);
    }

    public IncorrectExpressionONP() {
        this("Incorrect expression ONP");
    }
   
    public String toString ()
    {
        return "Incorrect expression ONP";
    }
}