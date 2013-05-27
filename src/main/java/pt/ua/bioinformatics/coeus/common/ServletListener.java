/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.common;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 *
 * @author sernadela
 */
public class ServletListener implements ServletContextListener{

    @Override
    public void contextInitialized(ServletContextEvent sce) {      
        Boot.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
 
    }
    
}
