package Narzedzia.op1arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa reprezentujaca wartosc bezwzgledna
 * @author magicznykrzysztof
 */
public class Abs extends Operator1arg{
     /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
        check();
        return Math.abs(array[0]);
    }
};