package Narzedzia.op1arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa reprezentujaca podloge liczby
 * @author magicznykrzysztof
 */
public class Floor extends Operator1arg{
            /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP {
        check();
        return Math.floor(array[0]);
    }
};