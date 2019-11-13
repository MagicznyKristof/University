package Narzedzia.op1arg;

import Narzedzia.Exception.DivisionByZeroONP;
import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa reprezentujaca ArcusTangens
 * @author magicznykrzysztof
 */
public class Acot extends Operator1arg{
         /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
        check();
        if(Math.atan(array[0])==0) throw new DivisionByZeroONP();
        return 1/Math.atan(array[0]);
    }
};