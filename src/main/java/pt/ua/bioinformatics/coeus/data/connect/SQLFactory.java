package pt.ua.bioinformatics.coeus.data.connect;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ConceptFactory;
import pt.ua.bioinformatics.coeus.api.DB;
import pt.ua.bioinformatics.coeus.api.ItemFactory;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.data.Triplify;
import pt.ua.bioinformatics.coeus.domain.InheritedResource;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 * Data factory for transforming SQL data into RDF items using generic Triplify.
 *
 * @author pedrolopes
 */
public class SQLFactory implements ResourceFactory {

    private Resource res;
    private DB db = new DB();
    private String query;
    private ResultSet rs;
    private Triplify rdfizer;

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public SQLFactory(Resource r) {
        this.res = r;
    }

    /**
     * Reads SQL data according to Resource information.
     * <p>Workflow</b><ol>
     * <li>Check if resource is starter/extends</li>
     * <li>Load SQL resource from database to ResultSets</li>
     * <li>Start Triplify with factory Resource</li>
     * <li>Get data for Item key into Triplify</li>
     * <li>Load data for each InheritedResource property into Triplify hashmap
     * based on SQL columns</li>
     * <li>Itemize single item</li>
     * </ol></p>
     */
    public void read() {
        if (res.getMethod().equals("complete")) {
            try {
                HashMap<String, String> extensions;
                if (res.getExtension().equals("")) {
                    extensions = res.getExtended();
                } else {
                    extensions = res.getExtended(res.getExtension());
                }
                for (String item : extensions.keySet()) {
                    db.connect(res.getEndpoint());
                    query = res.getQuery().replace("#replace#", ItemFactory.getTokenFromItem(item));
                    rs = db.getData(query);
                    try {
                        while (rs.next()) {
                            rdfizer = new Triplify(res, PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + ConceptFactory.getTokenFromConcept(res.getExtendsConcept()) + ItemFactory.getTokenFromItem(extensions.get(item)));

                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    String value=rs.getString(c.getQuery());
                                    if(value!=null) rdfizer.add(inside, value);
                                }
                            }
                            rdfizer.complete();
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][SQLFactory] unable to " + res.getMethod() + " data for " + res.getUri());
                    Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("map")) {
            try {
                // load extension data

                for (String item : res.getExtended().keySet()) {
                    db.connect(res.getEndpoint());
                    query = res.getQuery().replace("#replace#", ItemFactory.getTokenFromItem(item));
                    rs = db.getData(query);
                    try {
                        rdfizer = new Triplify(res, item);
                        InheritedResource key = (InheritedResource) res.getHasKey();
                        while (rs.next()) {
                            rdfizer.getMap().add(rs.getString(key.getQuery()));
                        }
                        rdfizer.map(key.getProperty());
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    db.close();
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][SQLFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("cache")) {
            try {
                if (res.getExtendsConcept().equals(res.getIsResourceOf().getUri())) {

                    db.connect(res.getEndpoint());
                    query = res.getQuery();
                    rs = db.getData(query);
                    try {
                        while (rs.next()) {
                            InheritedResource key = (InheritedResource) res.getHasKey();
                            rdfizer = new Triplify(res);
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource r = (InheritedResource) o;
                                String[] tmp = r.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    String value=rs.getString(r.getQuery());
                                    if(value!=null) rdfizer.add(inside, value);
                                }
                            }
                            if (key.getRegex() == null) {
                                rdfizer.itemize(rs.getString(key.getQuery()));
                            } else {
                                Pattern p = Pattern.compile(key.getRegex());
                                Matcher m = p.matcher(rs.getString(key.getQuery()));
                                if (m.find()) {
                                    rdfizer.itemize(m.group());
                                }
                            }
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    db.close();
                } else {
                    // load extension data
                    HashMap<String, String> extensions;
                    if (res.getExtension().equals("")) {
                        extensions = res.getExtended();
                    } else {
                        extensions = res.getExtended(res.getExtension());
                    }
                    for (String item : extensions.keySet()) {
                        db.connect(res.getEndpoint());
                        query = res.getQuery().replace("#replace#", ItemFactory.getTokenFromItem(item));
                        rs = db.getData(query);
                        try {
                            while (rs.next()) {
                                InheritedResource key = (InheritedResource) res.getHasKey();
                                rdfizer = new Triplify(res, extensions.get(item));
                                for (Object o : res.getLoadsFrom()) {
                                    InheritedResource r = (InheritedResource) o;
                                    String[] tmp = r.getProperty().split("\\|");
                                    for (String inside : tmp) {
                                        String value=rs.getString(r.getQuery());
                                        if(value!=null) rdfizer.add(inside, value);
                                    }
                                }
                                rdfizer.itemize(rs.getString(key.getQuery()));
                            }
                        } catch (Exception ex) {
                            if (Config.isDebug()) {
                                Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                        db.close();
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][SQLFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
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
            API api = Boot.getAPI();
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
            api.addStatement(resource, Predicate.get("coeus:built"), true);
            success = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Saved resource " + res.getUri());
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to save resource " + res.getUri());
                Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
}