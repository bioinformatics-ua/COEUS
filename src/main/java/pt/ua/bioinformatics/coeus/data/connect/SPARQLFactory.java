package pt.ua.bioinformatics.coeus.data.connect;

import com.hp.hpl.jena.query.DatasetFactory;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.Syntax;
import com.hp.hpl.jena.rdf.model.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ItemFactory;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.data.Triplify;
import pt.ua.bioinformatics.coeus.domain.InheritedResource;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 * Data factory for transforming SPARQL data into RDF items using generic
 * Triplify.
 *
 * @author pedrolopes
 */
public class SPARQLFactory implements ResourceFactory {

    private Resource res;
    private Triplify rdfizer;
    private String query;
    private QueryExecution e;
    private ResultSet rs;
    private boolean hasError = false;

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public SPARQLFactory(Resource r) {
        this.res = r;
    }

    /**
     * Reads SPARQL data according to Resource information.
     * <p>Workflow</b><ol>
     * <li>Check if resource is starter/extends</li>
     * <li>Load SPARQL resource into ResultSet</li>
     * <li>Start Triplify with factory Resource</li>
     * <li>Get data for Item key into Triplify</li>
     * <li>Load data for each InheritedResource property into Triplify hashmap
     * based on SPARQL elements</li>
     * <li>Itemize single item</li>
     * </ol></p>
     */
    public void read() {
        if (res.getMethod().equals("map")) {
            // TO DO
        } else if (res.getMethod().equals("cache")) {
            try {
                if (res.getExtendsConcept().equals(res.getIsResourceOf().getUri())) {
                    query = PrefixFactory.allToString() + res.getEndpoint();
                    e = QueryExecutionFactory.create(query, Syntax.syntaxARQ, DatasetFactory.create());
                    rs = e.execSelect();
                    try {
                        while (rs.hasNext()) {
                            QuerySolution row = rs.nextSolution();
                            InheritedResource key = (InheritedResource) res.getHasKey();
                            rdfizer = new Triplify(res);
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource r = (InheritedResource) o;
                                String[] tmp = r.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    rdfizer.add(inside, row.get(r.getQuery()).toString());
                                }
                            }
                            if (key.getRegex() == null) {
                                rdfizer.itemize(row.get(key.getQuery()).toString());
                            } else {
                                Pattern p = Pattern.compile(key.getRegex());
                                Matcher m = p.matcher(row.get(key.getQuery()).toString());
                                if (m.find()) {
                                    rdfizer.itemize(m.group());
                                }
                            }
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) { saveError(ex);
                            Logger.getLogger(SPARQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                } else {
                    // load extension data
                    HashMap<String, String> extensions;
                    if (res.getExtension().equals("")) {
                        extensions = res.getExtended();
                    } else {
                        extensions = res.getExtended(res.getExtension());
                    }
                    for (String item : extensions.keySet()) {
                        query = PrefixFactory.allToString() + res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(item));
                        e = QueryExecutionFactory.create(query, Syntax.syntaxARQ, DatasetFactory.create());
                        rs = e.execSelect();
                        try {
                            while (rs.hasNext()) {
                                QuerySolution row = rs.nextSolution();
                                InheritedResource key = (InheritedResource) res.getHasKey();
                                rdfizer = new Triplify(res, extensions.get(item));
                                for (Object o : res.getLoadsFrom()) {
                                    InheritedResource r = (InheritedResource) o;
                                    String[] tmp = r.getProperty().split("\\|");
                                    for (String inside : tmp) {
                                        rdfizer.add(inside, row.get(r.getQuery()).toString());
                                    }
                                }
                                if (key.getRegex() == null) {
                                    rdfizer.itemize(row.get(key.getQuery()).toString());
                                } else {
                                    Pattern p = Pattern.compile(key.getRegex());
                                    Matcher m = p.matcher(row.get(key.getQuery()).toString());
                                    if (m.find()) {
                                        rdfizer.itemize(m.group());
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            if (Config.isDebug()) { saveError(ex);
                                Logger.getLogger(SPARQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][SPARQLFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(SPARQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("complete")) {
            // TODO
        }
    }

    /**
     * Updates the resource coeus:built property once the resource finished
     * building.
     *
     * @return success of the operation
     */
    public boolean save() {
        boolean success = false;
        try {
            //only change built property if there are no errors
            if (hasError == false) {
                API api = Boot.getAPI();
                com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
                Statement statementToRemove = api.getModel().createLiteralStatement(resource, Predicate.get("coeus:built"), false);
                api.removeStatement(statementToRemove);
                api.addStatement(resource, Predicate.get("coeus:built"), true);
            }
            success = true;
            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Saved resource " + res.getUri());
            }
        } catch (Exception ex) {
            if (Config.isDebug()) { saveError(ex);
                System.out.println("[COEUS][API] Unable to save resource " + res.getUri());
                Logger.getLogger(SPARQLFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
    
    private void saveError(Exception ex) {
        try {
            API api = Boot.getAPI();
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
            Statement statement=api.getModel().createLiteralStatement(resource, Predicate.get("dc:coverage"), "ERROR: "+ex.getMessage());
            api.addStatement(statement);
            hasError = true;

            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Saved error on resource " + res.getUri());
            }
        } catch (Exception e) {
            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Unable to save error on resource " + res.getUri());
                Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, e);
            }
        }
    }
}
