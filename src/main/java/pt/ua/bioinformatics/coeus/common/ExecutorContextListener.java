/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.common;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 *
 * @author sernadela
 */
public class ExecutorContextListener implements ServletContextListener{
    private  ExecutorService executor;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        executor = Executors.newFixedThreadPool(4);
        context.setAttribute("INTEGRATION_EXECUTOR", executor);
        Boot.start();
	//System.out.println("ServletContextListener started");	
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        //System.out.println("ServletContextListener destroyed");  
        List<Runnable> list=executor.shutdownNow();
        //System.err.println("\n\n\nList of runnables:\n\n");
        //for(Runnable r : list){
        //    System.err.println(r.toString());
        //}
//        System.err.println("\n\n\nList of Threads:\n\n");
//        Set<Thread> threadSet = Thread.getAllStackTraces().keySet();
//        Thread[] threadArray = threadSet.toArray(new Thread[threadSet.size()]);
//        for(Thread t:threadArray) {
//            System.err.println(t.getName());
//        }
    }
    
}
