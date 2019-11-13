package Narzedzia.op1arg;

import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa sprawdzajaca znak wartosci
 * @author magicznykrzysztof
 */
public class Sgn extends Operator1arg{
     /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
        check();
        if(array[0]>0) return 1;
        if(array[0]<0) return -1;
        return 0;
    }
};