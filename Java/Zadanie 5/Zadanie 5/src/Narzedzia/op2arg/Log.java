package Narzedzia.op2arg;

import Narzedzia.Exception.DivisionByZeroONP;
import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa logarytmowanie wartosci
 * @author magicznykrzysztof
 */
 public class Log extends  Operator2arg{
        /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
        check();
        if (Math.log(array[0])==0) throw new DivisionByZeroONP();
        return Math.log(array[1])/Math.log(array[0]);
    }
};