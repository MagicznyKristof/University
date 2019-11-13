package Narzedzia.Exception;

/**
 * Klasa Wyjatek wyrazenia ONP gdy brak elementow w kolekcji
 * @author magicznykrzysztof
 */
public class NoElementsONP extends ExceptionONP{
    public NoElementsONP (String x){
        super(x);
    }

    public NoElementsONP() {
        this("No Elements in the collection");
    }
   
    @Override
    public String toString ()
    {
        return "No Elements in the collection";
    }
}