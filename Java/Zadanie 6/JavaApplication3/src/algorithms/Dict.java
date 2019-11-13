/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package algorithms;

/**
 *
 * @author magicznykrzysztof
 */
interface Dict <T extends Comparable<T>>
{
    public boolean search(T value);
    public void insert(T value);
    
}
