

import wyrazenie.Wyrazenie;
import wyrazenie.Para;
import wyrazenie.Stala;
import wyrazenie.Zmienna;
import wyrazenie.op1arg.Arctan;
import wyrazenie.op2arg.Potegowanie;
import wyrazenie.op2arg.Logarytmowanie;
import wyrazenie.op2arg.Mnozenie;
import wyrazenie.op2arg.Odejmowanie;
import wyrazenie.op2arg.Dodawanie;
import wyrazenie.op2arg.Dzielenie;

/**
 * Program do obliczania wyrazen arytmetycznych
 * @author Krzysztof
 */
public class Zad4 {
    public static void main(String[] args) {
        try{
            
            Para a=new Para("x",-1.618);
            Para b=new Para("y",4);
            Para old_a=new Para("x",1);
        
            Zmienna.zmienne.wstaw(old_a);
            Zmienna.zmienne.wstaw(b);

            System.out.println("Jak nazywa sie obiekt -a? Odp. "+a);
            System.out.println("Czy zmienna x jest rowna y? Odp. "+a.equals(b));
            System.out.println("Szukam zmienna x w zbiorze. Odp. "+Zmienna.zmienne.szukaj("x"));            
            Zmienna.zmienne.ustal(a);
            
            System.out.println("Wartosc x po aktualizacji:"+Zmienna.zmienne.czytaj("x"));
            System.out.println("Znajduje sie tyle elementow: "+Zmienna.zmienne.ile());
            
            Wyrazenie w = new Dodawanie(
                new Stala(7),
                new Mnozenie(
                    new Zmienna("x"),
                    new Stala(5)
                )
            );

            Wyrazenie w1 = new Dodawanie(
                new Stala(3),
                new Stala(5)
            );            
            
            Wyrazenie w2 = new Dodawanie(
                new Stala(2),
                new Mnozenie(
                        new Zmienna("x"),
                        new Stala(5)
                )
            );          
            
            Wyrazenie w3 = new Dzielenie(
                new Odejmowanie(
                        new Mnozenie(
                                new Stala(11),
                                new Stala(3)
                        ),
                        new Stala(1)
                ),
                new Dodawanie(
                        new Stala(7),
                        new Stala(5)
                )
            );
            
            Wyrazenie w4 = new Arctan(
                new Dzielenie(
                        new Mnozenie(
                                new Dodawanie(
                                        new Stala(13),
                                        new Zmienna("x")
                                ),
                                new Zmienna("x")
                        ),
                        new Stala(0)
                )
            );            
            
            Wyrazenie w5=new Dodawanie(
                    new Potegowanie(
                            new Stala(2),
                            new Stala(5)
                    ),
                    new Mnozenie(
                            new Zmienna("x"),
                            new Logarytmowanie(
                                    new Stala(2),
                                    new Zmienna("y")
                            )
                    )                  
            );
            
            System.out.println(w+"= "+w.oblicz());
            System.out.println(w1+"= "+w1.oblicz());
            System.out.println(w2+"= "+w2.oblicz());
            System.out.println(w3+"= "+w3.oblicz());
            System.out.println(w4+"= "+w4.oblicz());
            System.out.println(w5+"= "+w5.oblicz());
        }
        catch(IllegalArgumentException a)
            {a.printStackTrace(); }
    }
    
}
