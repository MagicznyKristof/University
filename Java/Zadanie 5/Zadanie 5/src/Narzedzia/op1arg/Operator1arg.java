package Narzedzia.op1arg;

import Narzedzia.op0arg.Operator0arg;

/**
 * Klasa reprezentujaca funkcje jedno-argumentowe
 * @author magicznykrzysztof
 */
public abstract class Operator1arg extends Operator0arg{
     /**
     * Zwraca arnosc funkcji
     * @return Arnosc
     */
    @Override
    public int arity (){
        return 1;
    }
};