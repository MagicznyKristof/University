package Narzedzia.op1arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa logarytm naturalny 
 * @author magicznykrzysztof
 */
public class Ln extends Operator1arg{
        /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
        check();
        return Math.log(array[0]);
    }
};