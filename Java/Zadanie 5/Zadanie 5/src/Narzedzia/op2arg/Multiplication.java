package Narzedzia.op2arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa mnozenie dwoch wartosci
 * @author magicznykrzysztof
 */
public class Multiplication extends Operator2arg{
        /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
        check();
        return array[1]*array[0];
    }
};