package Narzedzia.op2arg;

import Narzedzia.Exception.DivisionByZeroONP;
import Narzedzia.Exception.ExceptionONP;

/**
 * Klasa reprezentujaca dzielenie dwoch wartosci
 * @author magicznykrzysztof
 */
public class Division extends Operator2arg{
            /**
     * Oblicza wartosc wyrazenia klasy
     * @return Wynik
     * @throws ExceptionONP Gdy wystapi blad w obliczeniach 
     */
    @Override
    public double value() throws ExceptionONP{
	if (array[0]==0) throw new DivisionByZeroONP();
        check();
        return array[1]/array[0];
    }
};