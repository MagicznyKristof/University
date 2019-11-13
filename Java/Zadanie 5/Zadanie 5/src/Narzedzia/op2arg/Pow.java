package Narzedzia.op2arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa reprezentujaca potegowanie liczb
 * @author magicznykrzysztof
 */
public class Pow extends Operator2arg{
     /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
        check();
        return Math.pow(array[1],array[0]);
    }
};