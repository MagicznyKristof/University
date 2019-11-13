package Narzedzia.Exception;

/**
 * Klasa Wyjatek wyrazenia ONP gdy stos jest pusty
 * @author magicznykrzysztof
 */
public class EmptyStackONP extends ExceptionONP{
    public EmptyStackONP (String x)
    {
        super(x);
    }

    public EmptyStackONP() {
        this("Stack is empty in the expression ONP");
    }
   
    public String toString ()
    {
        return "Stack is empty in the expression ONP";
    }
    
}