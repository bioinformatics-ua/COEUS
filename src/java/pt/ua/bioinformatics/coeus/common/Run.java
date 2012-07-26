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
     * </p>
     * <p>
     *      <strong>LEVEL 0</strong><br />Initialize system (mandatory on all runs).
     * </p>
     * <p>
     *      <strong>LEVEL 1</strong><br />Loads first level.
     * </p>
     * <p>
     *      <strong>LEVEL n</strong><br />Loads n level.
     * </p>
     * <p>
     *      <strong>FULL</strong><br />Loads everything.
     * </p>
     * <p>
     *      (This needs refactoring!)
     * </p>
     * 
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            // LEVEL 0

            //Boot.start();
            
            
            // LEVEL 1
            /*SingleImport single_uniprot = new SingleImport("resource_uniprot");
            SingleImport single_entrez = new SingleImport("resource_entrezgene");
            SingleImport single_hpo = new SingleImport("resource_hpo");
            
            Thread uniprot = new Thread(single_uniprot);
            Thread entrez = new Thread(single_entrez);
            Thread hpo = new Thread(single_hpo);
            uniprot.start(); 
            entrez.start();           
            hpo.start(); */

            // LEVEL 2
           
           /* SingleImport single_drugbank = new SingleImport("resource_drugbank");
            SingleImport single_interpro = new SingleImport("resource_interpro");
            SingleImport single_mesh = new SingleImport("resource_mesh");
            SingleImport single_pdb = new SingleImport("resource_pdb");
            SingleImport single_enzyme = new SingleImport("resource_enzyme");
            SingleImport single_pubmed = new SingleImport("resource_pubmed");
            
            Thread drugbank = new Thread(single_drugbank);
            Thread interpro = new Thread(single_interpro);
            Thread mesh = new Thread(single_mesh);
            Thread pdb = new Thread(single_pdb);
            Thread enzyme = new Thread(single_enzyme);            
            Thread pubmed = new Thread(single_pubmed);
            
            //drugbank.start();
            //interpro.start();
            //mesh.start();
            //pdb.start();
            //enzyme.start();
            //pubmed.start();

            */
            // LEVEL 3
            /*
            SingleImport single_pharmgkb = new SingleImport("resource_pharmgkb");            
            SingleImport single_ensembl = new SingleImport("resource_ensembl");
            SingleImport single_umls = new SingleImport("resource_umls");
            SingleImport single_medlineplus = new SingleImport("resource_medlineplus");
            SingleImport single_dailymed = new SingleImport("resource_dailymed");
            SingleImport single_prosite = new SingleImport("resource_prosite");
            
            Thread pharmgkb = new Thread(single_pharmgkb);
            Thread ensembl = new Thread(single_ensembl);
            Thread umls = new Thread(single_umls);
            Thread medlineplus = new Thread(single_medlineplus);
            //Thread dailymed = new Thread(single_dailymed);            
            Thread prosite = new Thread(single_prosite);
            
            pharmgkb.start();
            ensembl.start();
            umls.start();
            medlineplus.start();
            //dailymed.start();
            prosite.start();
            */ 

            // FULL
            // Boot.start();
            //Builder.build();
            
            Indexer.index();
        } catch (Exception ex) {
            Logger.getLogger(Run.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
