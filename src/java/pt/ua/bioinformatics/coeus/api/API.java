package pt.ua.bioinformatics.coeus.api;

import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.ResultSetFormatter;
import com.hp.hpl.jena.rdf.model.InfModel;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.Property;
import com.hp.hpl.jena.rdf.model.Resource;
import java.io.ByteArrayOutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.parser.JSONParser;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Storage;

/**
 * COEUS API handler class.
 * <p>Main API class for internal Java usage, use this or internal when building new data access methods!</p>
 * <p>
 *  <ul>
 *      <li>select*|get* are data extraction methods for SPARQL queries and direct triplets.</li>
 *      <li>add*|create* are data input methods for data creating.</li>
 *  </ul>
 * </p>
 *
 * @author pedrolopes
 */
public class API {

    private Model model = Storage.getModel();                   // Jena Model access
    private InfModel inferredModel = Storage.getInfmodel();     // Jena InferredModel access (when active!)
    private Internal internal = new Internal();                 // Cross-usage with Internal
    private JSONParser jsonparser = new JSONParser();           // JSONParser for JSON outputs

    public JSONParser getJsonparser() {
        return jsonparser;
    }

    public void setJsonparser(JSONParser jsonparser) {
        this.jsonparser = jsonparser;
    }

    public Internal getInternal() {
        return internal;
    }

    public void setInternal(Internal internal) {
        this.internal = internal;
    }

    public InfModel getInferredModel() {
        return inferredModel;
    }

    public void setInferredModel(InfModel inferredModel) {
        this.inferredModel = inferredModel;
    }

    public Model getModel() {
        return model;
    }

    public void setModel(Model model) {
        this.model = model;
    }

    public API() {
    }

    /**
     * Perform a SPARQL SELECT query to COEUS SDB.
     *
     * @param query the SPARQL query (no prefixes).
     * @param format the response format (csv, xml, json/js, rdf)
     * @param inferred true to query on inferred model, false to query on simple model.
     * @return
     */
    public ResultSet selectRS(String query, boolean inferred) {
        ResultSet response = null;
        try {
            String sparqlQuery = PrefixFactory.allToString() + query;
            QueryExecution qe = null;

            if (inferred) {
                qe = QueryExecutionFactory.create(sparqlQuery, inferredModel);
                //qe = QueryExecutionFactory.create(sparqlQuery, model);
            } else {
                qe = QueryExecutionFactory.create(sparqlQuery, model);
            }
            response = qe.execSelect();
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to select ResultSet items from COEUS Data");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return response;
    }

    /**
     * Perform a SPARQL SELECT query to COEUS SDB with multiple output formats support.
     *
     * @param query the SPARQL query (no prefixes).
     * @param format the response format (csv, xml, json/js, rdf)
     * @param inferred true to query on inferred model, false to query on simple model.
     * @return
     */
    public String select(String query, String format, boolean inferred) {
        String response = "";
        try {
            String sparqlQuery = PrefixFactory.allToString() + query;
            QueryExecution qe = null;

            if (inferred) {
                qe = QueryExecutionFactory.create(sparqlQuery, inferredModel);
                //qe = QueryExecutionFactory.create(sparqlQuery, model);
            } else {
                qe = QueryExecutionFactory.create(sparqlQuery, model);
            }
            response = execute(qe, format);
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to select items from COEUS Data");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return response;
    }

    /**
     * Gets all properties associated with a given individual.
     *
     * @param individual the individual COEUS id <concept>_<id>.
     * @param format the response format.
     * @return
     */
    public String getIndividual(String individual, String format) {
        String response = "";
        try {
            String sparqlQuery = PrefixFactory.allToString() + "SELECT ?pred ?obj WHERE  { coeus:" + individual + " ?pred ?obj}";
            QueryExecution qe = QueryExecutionFactory.create(sparqlQuery, model);
            response = execute(qe, format);
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to get individual from COEUS Data");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return response;
    }

    /**
     * Gets triple-based information according to given parameters.
     *
     * @param sub the subject (defaults to s, sub, subject).
     * @param pred the predicate (defaults to p, pred, predicate).
     * @param obj the object (defaults to o, obj, object).
     * @param format the response format.
     * @return
     */
    public String getTriple(String sub, String pred, String obj, String format) {
        String response = "";
        String select = "SELECT ?s_sub ?s_pred ?s_obj WHERE {?w_sub ?w_pred ?w_obj}";
        if (sub.equals("s") || sub.equals("sub") || sub.equals("subject")) {
            select = select.replace("?s_sub", "?" + sub).replace("?w_sub", "?" + sub);
        } else {
            select = select.replace("?s_sub", "").replace("?w_sub", sub);
        }
        if (pred.equals("p") || pred.equals("pred") || pred.equals("predicate")) {
            select = select.replace("?s_pred", "?" + pred).replace("?w_pred", "?" + pred);
        } else {
            select = select.replace("?s_pred", "").replace("?w_pred", pred);
        }
        if (obj.equals("o") || obj.equals("obj") || obj.equals("object")) {
            select = select.replace("?s_obj", "?" + obj).replace("?w_obj", "?" + obj);
        } else {
            select = select.replace("?s_obj", "").replace("?w_obj", obj);
        }
        try {
            String sparqlQuery = PrefixFactory.allToString() + select;
            QueryExecution qe = QueryExecutionFactory.create(sparqlQuery, model);
            response = execute(qe, format);
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to get triple from COEUS Data");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return response;
    }

    /**
     * Executes SPARQL queries in COEUS Data SDB server.
     *
     * @param qe Jena QueryExecution object.
     * @param format expected return format.
     * @return
     */
    private String execute(QueryExecution qe, String format) {
        String response = "";
        try {
            ResultSet rs = qe.execSelect();
            if (format.equals("txt") || format.equals("text")) {
                response = ResultSetFormatter.asText(rs);
            } else if (format.equals("json") || format.equals("js")) {
                ByteArrayOutputStream os = new ByteArrayOutputStream();
                ResultSetFormatter.outputAsJSON(os, rs);
                response = os.toString();
            } else if (format.equals("xml")) {
                response = ResultSetFormatter.asXMLString(rs);
            } else if (format.equals("rdf")) {
                ByteArrayOutputStream os = new ByteArrayOutputStream();
                ResultSetFormatter.outputAsRDF(os, "RDF/XML", rs);
                response = os.toString();
            } else if (format.equals("csv")) {
                ByteArrayOutputStream os = new ByteArrayOutputStream();
                ResultSetFormatter.outputAsCSV(os, rs);
                response = os.toString();
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to execute SPARQL select");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return response;
    }

    /**
     * Adds the given triple statement to COEUS model.
     *
     * @param subject a Resource for to the statement subject.
     * @param predicate a Property for the statement predicate.
     * @param object a Resource for the statement object.
     * @return success of the operation.
     */
    public boolean addStatement(Resource subject, Property predicate, Resource object) {
        boolean success = false;
        try {
            this.model.add(subject, predicate, object);
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to add triple to database");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Adds the given triple statement to COEUS model
     *
     * @param subject a Resource for to the statement subject.
     * @param predicate a Property for the statement predicate.
     * @param object a String for the statement object.
     * @return success of the operation.
     */
    public boolean addStatement(Resource subject, Property predicate, String object) {
        boolean success = false;
        try {
            this.model.add(subject, predicate, object);
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to add triple to database");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Adds the given triple statement to COEUS model
     *
     * @param subject a Resource for to the statement subject.
     * @param predicate a Property for the statement predicate.
     * @param object a boolean value for the statement object.
     * @return success of the operation.
     */
    public boolean addStatement(Resource subject, Property predicate, boolean object) {
        boolean success = false;
        try {
            this.model.addLiteral(subject, predicate, object);
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to add triple to database");
                Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Gets information for a given Resource in COEUS SDB.
     *
     * TODO: shouldn't this be in Internal?
     * 
     * @param uri the desired Resource URI.
     * @return the loaded Resource.
     */
    public Resource getResource(String uri) {
        Resource resource = null;
        try {
            resource = this.model.getResource(uri);
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to obtain new Resource from Model");
            Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return resource;
    }

    /**
     * Creates a new Resource in COEUS SDB.
     *
     * @param uri the URI for the new Resource.
     * @return the newly created Resource.
     */
    public Resource createResource(String uri) {
        Resource resource = null;
        try {
            resource = this.model.createResource(uri);
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to create new Resource in model");
            }
            Logger.getLogger(API.class.getName()).log(Level.SEVERE, null, ex);
        }
        return resource;
    }

    /**
     * Extracts an item identifier from a full URI.
     * 
     * @param uri
     * @return 
     */
    public String uriToItem(String uri) {
        String[] full = uri.split("/");
        return full[full.length - 1];
    }

    /**
     * Extracts an item identifier from an Item label.
     * 
     * @param uri
     * @return 
     */
    public String labelToItem(String label) {
        if (!label.contains("_")) {
            return label;
        } else {
            String[] full = label.split("_");
            return full[1];
        }
    }
}
