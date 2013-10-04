/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.common;

/**
 *
 * @author sernadela
 */
public class Worker implements Runnable{
    String name;
    
    public Worker(String name){
        this.name=name;
    }

    @Override
    public void run() {
        System.out.println("worker run call");
        Boot.build();
    }
    
    @Override
    public String toString(){
        return name;
    }
    
}
