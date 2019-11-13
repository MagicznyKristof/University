package Narzedzia.op0arg;

import Narzedzia.Calc.Operand;

/**
 * Klasa reprezentujaca liczbe
 * @author magicznykrzysztof
 */
public class Number extends Operand{
    private final double val;
    public Number (double x){ val=x; }
    /**
     * Zwraca wartosc liczby
     * @return Liczba
     */
    @Override
    public double value(){ return val; }
};