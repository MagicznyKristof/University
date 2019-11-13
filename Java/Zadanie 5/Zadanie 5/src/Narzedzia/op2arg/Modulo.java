package Narzedzia.op2arg;

import Narzedzia.Exception.DivisionByZeroONP;
import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa modulo 
 * @author magicznykrzysztof
 */
public class Modulo extends Operator2arg{
        /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP {
        check();
        if (array[0]==0) throw new DivisionByZeroONP();
        return array[1]%array[0];
    }
};