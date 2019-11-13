package Narzedzia.op1arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa obliczajaca sin z dwoch wartosci
 * @author magicznykrzysztof
 */
public class Sin extends Operator1arg{
     /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP {
        check();
        return Math.sin(array[0]);
    }
};
