/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.data.connect;

import com.hp.hpl.jena.rdf.model.Statement;
import com.jayway.jsonpath.JsonPath;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ConceptFactory;
import pt.ua.bioinformatics.coeus.api.ItemFactory;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.data.Triplify;
import pt.ua.bioinformatics.coeus.domain.InheritedResource;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 *
 * @author sernadela
 */
public class JSONFactory implements ResourceFactory {

    private Resource res;
    private URL u;
    private Triplify rdfizer;
    private boolean hasError = false;

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public JSONFactory(Resource r) {
        this.res = r;
    }

    /**
     * Reads JSON data according to Resource information. <p>Workflow</b><ol>
     * <li>Check if resource is starter/extends</li> <li>Load JSON resource into
     * URL and Document</li> <li>Start Triplify with factory Resource</li>
     * <li>Get data for Item key into Triplify</li> <li>Load data for each
     * InheritedResource property into Triplify hashmap based on XPath
     * queries</li> <li>Itemize single item</li> </ol></p>
     */
    public void read() {
        if (res.getMethod().equals("map")) {
            // TODO
        } else if (res.getMethod().equals("cache")) {
            try {
                if (res.getExtendsConcept().equals(res.getIsResourceOf().getUri())) {
                    u = new URL(res.getEndpoint());
                    //BufferedReader bf=new BufferedReader(new InputStreamReader(u.openStream()));

                    JSONParser parser = new JSONParser();
                    JSONObject json = (JSONObject) parser.parse(new InputStreamReader(u.openStream()));

                    try {

                        //$.results.bindings[*].obj.value
                        List<Object> entries = JsonPath.read(json, res.getQuery());
                        for (Object i : entries) {
                            //System.err.println(i );
                            InheritedResource key = (InheritedResource) res.getHasKey();
                            rdfizer = new Triplify(res);
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    Object element = JsonPath.read(i, c.getQuery());
                                    //System.out.println("Element:"+element);
                                    rdfizer.add(inside, element.toString());
                                }
                            }
                            //System.out.println(key.getQuery()+key);
                            Object xmlkey = JsonPath.read(i, key.getQuery());
                            //System.out.println(xmlkey.toString());
                            if (key.getRegex() == null) {
                                rdfizer.itemize(xmlkey.toString());
                            } else {
                                Pattern p = Pattern.compile(key.getRegex());
                                Matcher m = p.matcher(xmlkey.toString());
                                if (m.find()) {
                                    rdfizer.itemize(m.group());
                                }
                            }
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) { saveError(ex);
                            Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
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
                        u = new URL(res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(item)));

                        try {
                            JSONParser parser = new JSONParser();
                            JSONObject json = (JSONObject) parser.parse(new InputStreamReader(u.openStream()));
                            List<Object> entries = JsonPath.read(json, res.getQuery());

                            for (Object i : entries) {

                                InheritedResource key = (InheritedResource) res.getHasKey();
                                rdfizer = new Triplify(res, extensions.get(item));
                                for (Object o : res.getLoadsFrom()) {
                                    InheritedResource c = (InheritedResource) o;
                                    String[] tmp = c.getProperty().split("\\|");
                                    for (String inside : tmp) {
                                        try {
                                            List<Object> elements = JsonPath.read(i, c.getQuery());

                                            if (elements != null) {
                                                if (elements.size() >= 1) {
                                                    for (Object k : elements) {
                                                        try {
                                                            System.out.println(k.toString());
                                                            rdfizer.add(inside, k.toString());
                                                        } catch (Exception ex) {
                                                            if (Config.isDebug()) { saveError(ex);
                                                                Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                        } catch (Exception e) {
                                            try {
                                                String element = JsonPath.read(i, c.getQuery());
                                                rdfizer.add(inside, element);
                                            } catch (Exception ex) {
                                                if (Config.isDebug()) { saveError(ex);
                                                    Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
                                                }
                                            }
                                        }



                                    }
                                }
                                Object xmlkey = JsonPath.read(i, key.getQuery());

                                if (key.getRegex() == null) {
                                    rdfizer.itemize(xmlkey.toString());
                                } else {
                                    Pattern p = Pattern.compile(key.getRegex());
                                    Matcher m = p.matcher(xmlkey.toString());
                                    if (m.find()) {
                                        rdfizer.itemize(m.group());
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            if (Config.isDebug()) { saveError(ex);
                                Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }


                }
            } catch (Exception ex) {
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][JSONFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("complete")) {
            try {
                HashMap<String, String> extensions;
                if (res.getExtension().equals("")) {
                    extensions = res.getExtended();
                } else {
                    extensions = res.getExtended(res.getExtension());
                }
                for (String item : extensions.keySet()) {

                    u = new URL(res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(item)));

                    try {
                        JSONParser parser = new JSONParser();
                        JSONObject json = (JSONObject) parser.parse(new InputStreamReader(u.openStream()));
                        List<Object> entries = JsonPath.read(json, res.getQuery());
                        for (Object i : entries) {

                            rdfizer = new Triplify(res, PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + ConceptFactory.getTokenFromConcept(res.getExtendsConcept()) + ItemFactory.getTokenFromItem(extensions.get(item)));
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    //Find if has a list of objects or not:
                                    try {
                                        List<Object> elements = JsonPath.read(i, c.getQuery());
                                        if (elements != null) {
                                            for (Object k : elements) {
                                                try {
                                                    rdfizer.add(inside, k.toString());
                                                } catch (Exception ex) {
                                                    if (Config.isDebug()) { saveError(ex);
                                                        Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
                                                    }
                                                }
                                            }
                                        }
                                    } catch (Exception e) {
                                        //It has only one element
                                        try {
                                            String element = JsonPath.read(i, c.getQuery());
                                            if (element != null) {
                                                rdfizer.add(inside, element);
                                            }
                                        } catch (Exception exc) {
                                            if (Config.isDebug()) { saveError(exc);
                                                Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, exc);
                                            }
                                        }

                                    }
                                }
                            }
                            rdfizer.complete();
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) { saveError(ex);
                            Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][JSONFactory] unable to complete data for " + res.getUri());
                    Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
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
                Logger.getLogger(JSONFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
    
    private void saveError(Exception ex) {
        try {
            API api = Boot.getAPI();
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
            Statement statement=api.getModel().createLiteralStatement(resource, Predicate.get("dc:coverage"), "ERROR: "+ex.getMessage()+". For more information, please see the application server log.");
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
