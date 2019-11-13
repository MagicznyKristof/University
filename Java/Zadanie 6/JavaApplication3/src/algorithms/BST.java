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
class BST <T extends Comparable<T>> implements Dict<T>
{
    private class Node <T extends Comparable<T>>
    {
        Node<T> left, right, parent;
        T data;
        
        public Node() {
            this.data = null;
            this.left = null;
            this.right = null;
        }
        public Node(T data){
		this.data = data;
		this.left = null;
		this.right = null;
	}
    }
    private Node<T> root;
    
    public boolean search(T value) {
        Node current = root;
        while(current!=null){
            if(current.data.compareTo(value) == 0){
                return true;
            }else if(current.data.compareTo(value) > 0){
                current = current.left;
            }else{
                current = current.right;
            }
	}
	return false;
    }
    
    public void insert(T value){
        if(value == null)
            throw new NullPointerException ( "Próbujesz dodać null do drzewa" );
	Node newNode = new Node(value);
        if(root==null){
            root = newNode;
            return;
	}
	Node current = root;
	while(true){
            current.parent = current;
            if(current.data.compareTo(value) > 0 ){				
		current = current.left;
		if(current==null){
                    current.parent.left = newNode;
                    
                    return;
		}
            }else{
		current = current.right;
		if(current==null){
                    current.parent.right = newNode;
                    return;
		}
            }
	}
    }
    
    public void delete(T value){
	Node current = root;
	boolean isLeftChild = false;
	while(current.data!=value){
            if(current.data.compareTo(value)>0){
		isLeftChild = true;
		current = current.left;
            }else{
		isLeftChild = false;
		current = current.right;
            }
	if(current ==null)
            System.out.println("Nie ma takiego węzła");
	}
	
        
	//Węzęł nie ma dzieci
	if(current.left==null && current.right==null){
            if(current==root)
		root = null;
            
            if(isLeftChild ==true){
		current.parent.left = null;
            }else{
		current.parent.right = null;
            }
        }else if(current.right==null){//Węzeł ma jedno dziecko
            if(current==root){
                current.left.parent = null;
		root = current.left;
            }else if(isLeftChild){
		current.parent.left = current.left;
            }else{
		current.parent.right = current.left;
            }
	}
	else if(current.left==null){
            if(current==root){
                current.right.parent = null;
		root = current.right;
            }else if(isLeftChild){
		current.parent.left = current.right;
            }else{
		current.parent.right = current.right;
            }
	}else if(current.left!=null && current.right!=null){
	//znaleźliśmy minimalne dziecko
            Node successor = min(current);
            if(current==root){
                root = successor;
            }else if(isLeftChild){
                current.parent.left = successor;
            }else{
                current.parent.right = successor;
            }			
            successor.left = current.left;
            successor.right = current.right;
            delete(successor.data);
        }		
}
    
    
    

public String toString ()
    {
        return true;/*...*/ 
    }
}
