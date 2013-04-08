package pt.ua.bioinformatics.coeus.data;

import au.com.bytecode.opencsv.CSVReader;
import com.hp.hpl.jena.rdf.model.InfModel;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.RDFReader;
import com.hp.hpl.jena.reasoner.Reasoner;
import com.hp.hpl.jena.reasoner.ReasonerRegistry;
import com.hp.hpl.jena.sdb.SDBFactory;
import com.hp.hpl.jena.sdb.Store;
import com.hp.hpl.jena.update.UpdateAction;
import com.hp.hpl.jena.util.FileManager;
import java.io.FileReader;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 * COEUS Data Storage key class. Handles all SDB-related stuff.
 * <p>Storage relies on Jena internal methods and structure.<br />For further information please check Jena's documentation</p>
 * </p>
 *
 * @author pedrolopes
 */
public class Storage {

    private static boolean loaded = false;
    private static boolean connected = false;
    private static Model model = null;
    private static Store store = null;
    private static Reasoner reasoner = ReasonerRegistry.getRDFSSimpleReasoner(); //what's the best reasoner?
    private static InfModel infmodel = null;

    public static boolean isConnected() {
        return connected;
    }

    public static void setConnected(boolean connected) {
        Storage.connected = connected;
    }

    public static InfModel getInfmodel() {
        return infmodel;
    }

    public static void setInfmodel(InfModel infmodel) {
        Storage.infmodel = infmodel;
    }

    public static boolean isLoaded() {
        return loaded;
    }

    public static void setLoaded(boolean loaded) {
        Storage.loaded = loaded;
    }

    public static Model getModel() {
        return model;
    }

    public static void setModel(Model model) {
        Storage.model = model;
    }

    public static Reasoner getReasoner() {
        return reasoner;
    }

    public static void setReasoner(Reasoner reasoner) {
        Storage.reasoner = reasoner;
    }

    public static Store getStore() {
        return store;
    }

    public static void setStore(Store store) {
        Storage.store = store;
    }

    /**
     * Connects Seed to COEUS SDB.
     * <p>
     *  Connection information must be available in JS configuration file, <strong>sdb</strong> property.
     * </p>
     *
     * @return success of the operation.
     */
    public static boolean connect() {
        try {
            store = (Store) SDBFactory.connectStore(Config.getPath() + Config.getSdb());
            model = SDBFactory.connectDefaultModel(store);
            infmodel = ModelFactory.createInfModel(reasoner, model);
            connected = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Successfully connected to COEUS SDB");
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Unable to connect to COEUS SDB");
                Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return connected;
    }

    /**
     * Connects Seed to COEUS SDB without inference support.
     * <p>
     *  Connection information must be available in JS configuration file, <strong>sdb</strong> property.
     * </p>
     *
     * @return success of the operation.
     */
    public static boolean connectX() {
        try {
            store = (Store) SDBFactory.connectStore(Config.getPath() + Config.getSdb());
            model = SDBFactory.connectDefaultModel(store);
            connected = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Successfully connected to COEUS SDB");
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Unable to connect to COEUS SDB");
                Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return connected;
    }

    /**
     * Loads COEUS ontology from general URI.
     * <p>
     * Base COEUS ontology must be available in JS configuration file, <strong>ontology</strong> property.
     * </p>
     *
     * @return success of the operation.
     */
    private static boolean loadOntology() {
        boolean success = false;
        try {
            InputStream in = FileManager.get().open(Config.getOntology());
            model.read(in, null);
            success = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] COEUS Ontology loaded");
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Unable to load COEUS Ontology");
                Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Loads Seed setup for COEUS instance.
     * <p>
     *  Setup information must be available in JS configuration file, <strong>setup</strong> property.
     * </p>
     * 
     * @return success of the operation.
     */
    private static boolean loadSetup() {
        boolean success = false;
        try {
            InputStream in = FileManager.get().open(Config.getPath() + Config.getSetup());
            RDFReader r = model.getReader();
            r.read(model, in, PrefixFactory.getURIForPrefix(Config.getKeyPrefix()));
            success = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] " + Config.getName() + " setup loaded");
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Unable to load " + Config.getName() + " setup");
                Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Clears configuration information from COEUS SDB.
     * 
     * @return success of the operation.
     */
    public static boolean clear() {
        boolean success = false;
        try {
            String sparqlQuery = PrefixFactory.allToString() + "DELETE WHERE {?r rdf:type coeus:Resource . ?r ?p ?o }";
            UpdateAction.parseExecute(sparqlQuery, Storage.model);
            sparqlQuery = PrefixFactory.allToString() + "DELETE WHERE {?r rdf:type coeus:Concept . ?r ?p ?o }";
            UpdateAction.parseExecute(sparqlQuery, Storage.model);
            sparqlQuery = PrefixFactory.allToString() + "DELETE WHERE {?r rdf:type coeus:CSV . ?r ?p ?o }";
            UpdateAction.parseExecute(sparqlQuery, Storage.model);
            sparqlQuery = PrefixFactory.allToString() + "DELETE WHERE {?r rdf:type coeus:SQL . ?r ?p ?o }";
            UpdateAction.parseExecute(sparqlQuery, Storage.model);
            sparqlQuery = PrefixFactory.allToString() + "DELETE WHERE {?r rdf:type coeus:XML . ?r ?p ?o }";
            UpdateAction.parseExecute(sparqlQuery, Storage.model);
            sparqlQuery = PrefixFactory.allToString() + "DELETE WHERE {?r rdf:type coeus:SPARQL . ?r ?p ?o }";
            UpdateAction.parseExecute(sparqlQuery, Storage.model);

            success = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] " + Config.getName() + " SDB cleared");
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Unable to clear " + Config.getName() + " setup");
                Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Storage load handler for new instance builds.
     * <p><b>Workflow</b><ol>
     *  <li>Connect to COEUS SDB instance</li>
     *  <li>Cleanup all COEUS Data in SDB</li>
     *  <li>Load COEUS ontology into SDB</li>
     *  <li>Load instance setup into SDB</li>
     *  <li>Load predicates for building</li>
     * </ol></p>
     * @return
     */
    public static boolean load() {
        if (!loaded) {
            try {
                connect();
                //clear();
                //reset();
                loadOntology();
                loadSetup();
//                infmodel = ModelFactory.createInfModel(reasoner, model);
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Storage] finished loading " + Config.getName());
                }
                loaded = true;
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Storage] Unable to load " + Config.getName());
                    Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return loaded;
    }

    /**
     * Loads COEUS Data Predicate information to Predicate singleton for further usage.
     * <p><b>Workflow</b><ol>
     *  <li>Load default Semantic Web properties</li>
     *  <li>Load COEUS-specific properties</li>
     * </ol></p>
     *
     * @return success of the operation.
     */
    public static boolean loadPredicatess() {
        boolean success = false;
        try {
            // load default predicates
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT DISTINCT ?p WHERE { ?s ?p ?o}", "js", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");

            for (Object o : bindings) {
                JSONObject binding = (JSONObject) o;
                JSONObject s = (JSONObject) binding.get("p");
                Predicate.add(PrefixFactory.encode((String) s.get("value")), Storage.getModel().getProperty((String) s.get("value")));
            }

            // load COEUS-specific predicates (Object and Data properties)
            JSONParser parserr = new JSONParser();
            JSONObject responsee = (JSONObject) parserr.parse(Boot.getAPI().select("SELECT DISTINCT ?p WHERE { ?p ?o ?s {?p rdf:type owl:ObjectProperty } UNION {?p rdf:type owl:DatatypeProperty }}", "js", false));
            JSONObject resultss = (JSONObject) responsee.get("results");
            JSONArray bindingss = (JSONArray) resultss.get("bindings");
            for (Object o : bindingss) {
                JSONObject binding = (JSONObject) o;
                JSONObject s = (JSONObject) binding.get("p");
                Predicate.add(PrefixFactory.encode((String) s.get("value")), Storage.getModel().getProperty((String) s.get("value")));
            }
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] COEUS Predicates loaded");
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] Unable to load predicate information");
                Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Loads available predicates in COEUS to universal list (Predicate class).
     * 
     * @return success of the operation
     */
    public static boolean loadPredicates() {
        boolean success = false;
        try {
            CSVReader predicates = new CSVReader(new FileReader(Config.getPath() + Config.getPredicates()));
            String[] nextLine;
            while ((nextLine = predicates.readNext()) != null) {
                if(!(nextLine[0].indexOf("#") == 0)) {
                    Predicate.add(PrefixFactory.encode(nextLine[0]), Storage.getModel().getProperty(nextLine[0]));
                }
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to execute SPARQL select");
                Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Validates inferred model validity according to chosen reasoner.
     *
     * @return validity.
     */
    public static boolean validate() {
        boolean valid = false;
        /*        try {
        ValidityReport validity = infmodel.validate();
        if (validity.isValid()) {
        valid = true;
        if (Config.isDebug()) {
        System.out.println("[COEUS][Storage] valid SDB");
        }
        } else {
        if (Config.isDebug()) {
        System.out.println("[COEUS][Storage] non-valid SDB.\n\tConflicts:\n");
        for (Iterator i = validity.getReports(); i.hasNext();) {
        ValidityReport.Report report = (ValidityReport.Report) i.next();
        System.out.println("\t\t - " + report);
        }
        }
        }
        } catch (Exception ex) {
        if (Config.isDebug()) {
        System.out.println("[COEUS][Storage] Unable to validate COEUS SDB");
        }
        Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
        } */
        return valid;
    }

    /**
     * Clean up all COEUS Data in SDB.
     *
     * @return
     */
    private static boolean reset() {
        boolean success = true;
        try {
            store.getTableFormatter().create();
            store.getTableFormatter().truncate();
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Storage] unable to reset COEUS SDB");
            }
            Logger.getLogger(Storage.class.getName()).log(Level.SEVERE, null, ex);
        }
        return success;
    }
}
