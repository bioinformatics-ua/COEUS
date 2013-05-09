package pt.ua.bioinformatics.coeus.common;

import pt.ua.bioinformatics.coeus.data.connect.JSONFactory;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.parser.ParseException;
import java.util.ArrayList;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import pt.ua.bioinformatics.coeus.data.connect.CSVFactory;
import pt.ua.bioinformatics.coeus.data.connect.PluginFactory;
import pt.ua.bioinformatics.coeus.data.connect.RDFFactory;
import pt.ua.bioinformatics.coeus.data.connect.ResourceFactory;
import pt.ua.bioinformatics.coeus.data.connect.SPARQLFactory;
import pt.ua.bioinformatics.coeus.data.connect.SQLFactory;
import pt.ua.bioinformatics.coeus.data.connect.XMLFactory;
import pt.ua.bioinformatics.coeus.domain.Concept;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 * Seed builder class. 
 * <p>
 * General class handler for loading new data into COEUS SDB.
 * </p>
 * 
 * @author pedrolopes
 */
public class Builder {

    private static ArrayList<Resource> resources = new ArrayList<Resource>();

    public static ArrayList<Resource> getResources() {
        return resources;
    }

    public static void setResources(ArrayList<Resource> resources) {
        Builder.resources = resources;
    }

    /**
     * Reads resources from COEUS SDB and populates Resource object list for further building.
     * 
     */
    public static void readResources() {
        try {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Reading resources for " + Config.getName());
            }
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?s ?resof ?method ?comment ?label ?title ?built ?publisher ?extends ?extension ?order ?endpoint ?built ?query WHERE { ?s rdf:type coeus:Resource ."
                    + " ?s rdfs:comment ?comment ."
                    + " ?s rdfs:label ?label ."
                    + " ?s dc:title ?title ."
                    + " ?s dc:publisher ?publisher ."
                    + " ?s coeus:isResourceOf ?resof ."
                    + " ?s coeus:extends ?extends ."
                    + " ?s coeus:method ?method ."
                    + " ?s coeus:endpoint ?endpoint ."
                    + " ?s coeus:order ?order . "
                    + "OPTIONAL { ?s coeus:built ?built} . OPTIONAL { ?s coeus:extension ?extension} . OPTIONAL {?s coeus:query ?query}} ORDER BY ?order", "js", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");

            for (Object o : bindings) {
                JSONObject binding = (JSONObject) o;
                JSONObject s = (JSONObject) binding.get("s");
                JSONObject d = (JSONObject) binding.get("comment");
                JSONObject l = (JSONObject) binding.get("label");
                JSONObject t = (JSONObject) binding.get("title");
                JSONObject resof = (JSONObject) binding.get("resof");
                JSONObject publisher = (JSONObject) binding.get("publisher");
                JSONObject ext = (JSONObject) binding.get("extends");
                JSONObject endpoint = (JSONObject) binding.get("endpoint");
                JSONObject method = (JSONObject) binding.get("method");
                JSONObject extension = (JSONObject) binding.get("extension");
                JSONObject built = (JSONObject) binding.get("built");
                JSONObject query = (JSONObject) binding.get("query");
                Resource r = new Resource(s.get("value").toString(), t.get("value").toString(), l.get("value").toString(), d.get("value").toString(), publisher.get("value").toString(), endpoint.get("value").toString(), method.get("value").toString());
                r.setExtendsConcept(ext.get("value").toString());
                r.setIsResourceOf(new Concept((resof.get("value").toString())));
                r.setExtension(!(extension == null) ? extension.get("value").toString() : "");
                r.setQuery(!(query == null) ? query.get("value").toString() : "");
                r.setBuilt(!(built == null) ? Boolean.parseBoolean(built.get("value").toString()) : false);
                resources.add(r);
            }
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Resource information read");
            }
        } catch (ParseException ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Unable to read resource information");
                Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    /**
     * Reads Resource object information from COEUS SDB for further building.
     * <p>Method used for single resource imports.
     * </p>
     * 
     * @param whatResource the resource label that will be read.
     * @return  a new Resource object.
     */
    public static Resource readResource(String whatResource) {
        Resource r = null;
        try {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Reading resource for " + Config.getName());
            }
            System.out.println(whatResource);
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?res ?method ?comment ?label ?title ?built ?publisher ?extends ?extension ?order ?endpoint ?query WHERE { ?res a coeus:Resource . ?res rdfs:comment ?comment . ?res rdfs:label ?label . ?res dc:title ?title . ?res dc:publisher ?publisher . ?res coeus:extends ?extends . ?res coeus:method ?method . ?res coeus:endpoint ?endpoint . ?res coeus:order ?order . OPTIONAL { ?res coeus:built ?built} . OPTIONAL {?res coeus:extension ?extension} . OPTIONAL {?res coeus:query ?query} . FILTER regex(str(?label), '" + whatResource + "')} ORDER BY ?order LIMIT 1", "js", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");
            for (Object o : bindings) {
                JSONObject binding = (JSONObject) o;
                JSONObject s = (JSONObject) binding.get("res");
                JSONObject d = (JSONObject) binding.get("comment");
                JSONObject l = (JSONObject) binding.get("label");
                JSONObject t = (JSONObject) binding.get("title");
                JSONObject publisher = (JSONObject) binding.get("publisher");
                JSONObject ext = (JSONObject) binding.get("extends");
                JSONObject endpoint = (JSONObject) binding.get("endpoint");
                JSONObject method = (JSONObject) binding.get("method");
                JSONObject extension = (JSONObject) binding.get("extension");
                JSONObject built = (JSONObject) binding.get("built");
                JSONObject query = (JSONObject) binding.get("query");
                r = new Resource(s.get("value").toString(), t.get("value").toString(), l.get("value").toString(), d.get("value").toString(), publisher.get("value").toString(), endpoint.get("value").toString(), method.get("value").toString());
                r.setExtendsConcept(ext.get("value").toString());
                r.setExtension(!(extension == null) ? extension.get("value").toString() : "");
                r.setQuery(!(query == null) ? query.get("value").toString() : "");
                r.setBuilt(!(built == null) ? Boolean.parseBoolean(built.get("value").toString()) : false);
            }
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Resource information read");
            }
        } catch (ParseException ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Unable to read resource information");
                Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return r;
    }

    /**
     * Initiates data conversion process from Resource to RDF in COEUS Data SDB.
     * 
     * @param r resource whose data will be read.
     * @return success of the operation.
     */
    public static boolean readData(Resource r) {
        boolean success = false;
        ResourceFactory factory;
        try {
            if (!r.isBuilt()) {
                if (r.getPublisher().equals("plugin")) {
                    factory = new PluginFactory(r);
                } else if (r.getPublisher().equals("csv")) {
                    factory = new CSVFactory(r);
                } else if (r.getPublisher().equals("xml")) {
                    factory = new XMLFactory(r);
                } else if (r.getPublisher().equals("sql")) {
                    factory = new SQLFactory(r);
                } else if (r.getPublisher().equals("sparql")) {
                    factory = new SPARQLFactory(r);
                } else if (r.getPublisher().equals("json")) {
                    factory = new JSONFactory(r);
                } else if (r.getPublisher().equals("rdf") | r.getPublisher().equals("ttl")) {
                    factory = new RDFFactory(r);
                } else {
                    factory = null;
                }
                factory.read();
                factory.save();
            }
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Data for " + r.getTitle() + " read");
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Unable to read data for " + r.getTitle());
                Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Instance builder.
     * <p><b>Workflow</b><ol>
     *  <li>Reads resource information from COEUS Data SDB</li>
     *  <li>Reads information for each resource (Key, Concept and LoadsFrom)</li>
     *  <li>Reads data for each resource</li>
     * </ol></p>
     * @return
     */
    public static boolean build() {
        boolean success = false;
        try {
            readResources();
            for (Resource r : resources) {
                r.loadInfo();
                try {

                    if (r.isBuilt()) {
                        if (Config.isDebug()) {
                            System.out.println("[COEUS][Builder] Already built resource " + r.getTitle());
                        }
                    } else {
                        if (Config.isDebug()) {
                            System.out.println("[COEUS][Builder] Reading data for resource " + r.getTitle());
                        }
                        readData(r);
                    }
                } catch (Exception ex) {
                    if (Config.isDebug()) {
                        System.out.println("[COEUS][Builder] Unable to read data for " + Config.getName() + " in resource " + r.getTitle());
                    }
                    Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Finished building " + Config.getName());
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Unable to build " + Config.getName());
                Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Instance builder for a single Resource.
     * <p><b>Workflow</b><ol>
     *  <li>Reads resource information from COEUS Data SDB</li>
     *  <li>Reads data for  resource</li>
     * </ol></p>
     * @param resource
     * @return 
     */
    public static boolean build(String resource) {
        boolean success = false;
        try {
            Resource r = readResource(resource);
            r.loadInfo();
            try {
                readData(r);
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Builder] Unable to read data for " + Config.getName() + " in resource " + r.getTitle());
                    Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
                }
            }

            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Finished building " + Config.getName());
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Unable to build " + Config.getName());
                Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Saves new JS configuration file with updated information.
     *
     * @return success of the operation.
     */
    public static boolean save() {
        boolean success = false;
        try {
            // TO DO
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Builder] Unable to save build configuration");
                Logger.getLogger(Builder.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
}
