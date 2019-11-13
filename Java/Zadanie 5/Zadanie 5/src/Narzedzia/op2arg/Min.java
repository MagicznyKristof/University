package Narzedzia.op2arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa reprezentujaca operacje wyboru min z dwoch wartosci
 * @author magicznykrzysztof
 */
public class Min extends Operator2arg{
        /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP {
        check();
        return Math.min(array[0],array[1]);
    }
};