/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.common;

import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.StmtIterator;

/**
 *
 * @author pedrolopes
 */
public class Indexer {

    static void index() {
        try {
            Boot.start();
            Model m = Boot.getAPI().getModel();
            // ---- Read and index all literal strings.
            IndexBuilderString larqBuilder = new IndexBuilderString();

            // Index statements as they are added to the model.


            // To just build the index, create a model that does not store statements 
            // Model model2 = ModelFactory.createModelForGraph(new GraphSink()) ;



            // ---- Alternatively build the index after the model has been created. 
            StmtIterator iter = m.listStatements();
            larqBuilder.indexStatements(iter);
            //larqBuilder.indexStatements(Boot.getAPI().getModel().listStatements()) ;

            // ---- Finish indexing
            larqBuilder.closeWriter();

            // ---- Create the access index  
            IndexLARQ index = larqBuilder.getIndex();
        } catch (Exception ex) {
            System.out.println(ex.getMessage());

        }

    }
}
