package pt.ua.bioinformatics.coeus.common;

import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.plugins.SingleImport;

/**
 *
 * @author pedrolopes
 */
public class Run {

    /**
     * COEUS importer runner class.
     * <p>
     *      Organized in import levels for dependency handling.
     *      (This needs refactoring!)
     * </p>
     * 
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            // Start build process            
            //Boot.start();
            
            // Import single resource (threaded) example
           SingleImport single = new SingleImport("resource_go");
            Thread t = new Thread(single);
            t.start();
        } catch (Exception ex) {
            Logger.getLogger(Run.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
