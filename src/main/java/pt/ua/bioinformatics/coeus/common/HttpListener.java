/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.common;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/**
 *
 * @author sernadela
 */
public class HttpListener implements HttpSessionListener{

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        Boot.start();
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
    }
    
}
