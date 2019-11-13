package Narzedzia.op2arg;

import Narzedzia.op1arg.Operator1arg;

/**
 * Klasa reprezentujaca funkcje dwu-argumentowe
 * @author magicznykrzysztof
 */
public abstract class Operator2arg extends Operator1arg{
    /**
     * Zwraca arnosc funkcji
     * @return Arnosc
     */
    @Override
    public int arity(){
        return 2;
    }
};