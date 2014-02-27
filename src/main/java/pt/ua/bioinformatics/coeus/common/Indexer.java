/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.common;

import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.rdf.model.Model;

/**
 *
 * @author pedrolopes
 */
public class Indexer {

    public static void index() {
        try {

            Model m = Boot.getAPI().getModel();
            // -- Read and index all literal strings.
            
            IndexBuilderString larqBuilder = new IndexBuilderString() ;
            long i = System.currentTimeMillis();
            // ---- Alternatively build the index after the model has been created. 
            larqBuilder.indexStatements(m.listStatements());
            // -- Finish indexing
            larqBuilder.closeWriter() ;
            // -- Create the access index  
            IndexLARQ index = larqBuilder.getIndex() ;
            // -- Make globally available
            LARQ.setDefaultIndex(index);
            long f = System.currentTimeMillis();
            System.out.println("\n\t[COEUS] " + Config.getName() + " Indexer done in " + ((f - i) / 1000) + " seconds.\n");
            //larqBuilder.indexStatements(Boot.getAPI().getModel().listStatements()) ;

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

    }
}
