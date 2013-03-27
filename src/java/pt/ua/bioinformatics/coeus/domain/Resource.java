package pt.ua.bioinformatics.coeus.domain;

import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 * Handles mappings for COEUS Resource individuals.
 * <p>A Resource is any referenced external system, whether app, database or service.<br />Resource class instances are used 
 * to configure data loading from external systems.</p>
 *
 * @author pedrolopes
 */
public class Resource {

    private String description;
    private String label;
    private String title;
    private String uri;
    private InheritedResource hasKey;                               // Pointer to the InheritedResource that will act as a key during data loading process
    private String source;
    private String subject;
    private String method;
    private String publisher;
    private ArrayList<Object> loadsFrom = new ArrayList<Object>();  // List containing the Resource heritage: property-specific data handling
    private Concept isResourceOf;
    private String extendsConcept;
    private String endpoint;
    private String extension;
    private String query;
    private boolean built = false;

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public boolean isBuilt() {
        return built;
    }

    public void setBuilt(boolean built) {
        this.built = built;
    }

    public String getExtension() {
        return extension;
    }

    public void setExtension(String extension) {
        this.extension = extension;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String query) {
        this.subject = query;
    }

    public String getExtendsConcept() {
        return extendsConcept;
    }

    public void setExtendsConcept(String uri) {
        this.extendsConcept = uri;
    }

    public Concept getIsResourceOf() {
        return isResourceOf;
    }

    public void setIsResourceOf(Concept isResourceOf) {
        this.isResourceOf = isResourceOf;
    }

    public String getSource() {
        return source;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public InheritedResource getHasKey() {
        return hasKey;
    }

    public void setHasKey(InheritedResource hasKey) {
        this.hasKey = hasKey;
    }

    public ArrayList<Object> getLoadsFrom() {
        return loadsFrom;
    }

    public void setLoadsFrom(ArrayList<Object> isResourceOf) {
        this.loadsFrom = isResourceOf;
    }

    public String getUri() {
        return uri;
    }

    public void setUri(String uri) {
        this.uri = uri;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Resource(String uri, String title, String label, String description, String publisher, String endpoint, String method) {
        this.uri = uri;
        this.description = description;
        this.label = label;
        this.title = title;
        this.publisher = publisher;
        this.endpoint = endpoint;
        this.method = method;
    }

    /**
     * Loads individuals from the Concept that this Resource extends.
     *
     * @return an ArrayList<String> containing Concept individual URIs.
     */
    public ArrayList<String> getExtended() {
        ArrayList<String> extensions = new ArrayList<String>();
        try {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] " + title + " loading extension data");
            }
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?title WHERE { ?title coeus:hasConcept " + PrefixFactory.encode(extendsConcept) + " } ORDER BY ?title", "json", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");
            for (Object obj : bindings) {
                JSONObject binding = (JSONObject) obj;
                JSONObject tit = (JSONObject) binding.get("title");
                extensions.add(tit.get("value").toString());
            }

        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] Unable to load extension concept information");
                Logger.getLogger(Resource.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if (Config.isDebug()) {
            System.out.println("\tExtension data loaded");
        }
        return extensions;
    }

    /**
     * Loads individuals from the Concept that this Resource extends, based on given extension property.
     *
     * @return an ArrayList<String> containing Concept individual URIs.
     */
    public ArrayList<String> getExtended(String uri) {
        ArrayList<String> extensions = new ArrayList<String>();
        try {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] " + title + " loading extension data");
            }
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?title WHERE { ?t coeus:hasConcept " + PrefixFactory.encode(extendsConcept) + " . ?t " + uri + " ?title} ORDER BY ?title", "json", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");
            for (Object obj : bindings) {
                JSONObject binding = (JSONObject) obj;
                JSONObject tit = (JSONObject) binding.get("title");
                extensions.add(tit.get("value").toString());
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] Unable to load extension concept information");
                Logger.getLogger(Resource.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if (Config.isDebug()) {
            System.out.println("\tExtension data loaded");
        }
        return extensions;
    }

    /**
     * Loads Resource information from COEUS Data SDB.
     *
     * @return success of the operation.
     */
    public boolean loadInfo() {
        boolean success = true;
        try {
            loadKey();
            loadConcept();
            loadInherited();
            success = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource][" + this.title + "] information read");                
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] Unable to load resource information");
                Logger.getLogger(Resource.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Loads information for inherited resources, composing the LoadsFrom graph.
     *
     * @return success of the operation.
     */
    private boolean loadInherited() {
        boolean success = true;
        try {
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?c ?title ?prop ?label ?query WHERE { " + PrefixFactory.encode(uri) + " coeus:loadsFrom ?c ."
                    + " ?c dc:title ?title ."
                    + " ?c coeus:property ?prop ."
                    + " ?c rdfs:label ?label ."
                    + " ?c coeus:query ?query}", "js", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");
            for (Object obj : bindings) {
                JSONObject binding = (JSONObject) obj;
                JSONObject c_label = (JSONObject) binding.get("label");
                JSONObject c_title = (JSONObject) binding.get("title");
                JSONObject c = (JSONObject) binding.get("c");
                JSONObject c_query = (JSONObject) binding.get("query");
                JSONObject prop = (JSONObject) binding.get("prop");
                InheritedResource cs = new InheritedResource(c_label.get("value").toString(), c_title.get("value").toString(), c.get("value").toString(), prop.get("value").toString(), c_query.get("value").toString());
                loadsFrom.add(cs);
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Resource][" + cs.getTitle() + "] Loads information from " + cs.getTitle());
                }
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] Unable to load inherited resource information");
                Logger.getLogger(Resource.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Loads information for Resource key, defining the loaded item formats.
     *
     * @return success of the operation.
     */
    private boolean loadKey() {
        boolean success = false;
        try {
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?c ?title ?prop ?label ?query ?regex WHERE { " + PrefixFactory.encode(uri) + " coeus:hasKey ?c ."
                    + " ?c dc:title ?title ."
                    + " ?c coeus:property ?prop ."
                    + " ?c rdfs:label ?label ."
                    + " ?c coeus:query ?query ."
                    + "OPTIONAL {?c coeus:regex ?regex}}", "js", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");
            for (Object obj : bindings) {
                JSONObject binding = (JSONObject) obj;
                JSONObject c_label = (JSONObject) binding.get("label");
                JSONObject c_title = (JSONObject) binding.get("title");
                JSONObject c = (JSONObject) binding.get("c");
                JSONObject c_query = (JSONObject) binding.get("query");
                JSONObject prop = (JSONObject) binding.get("prop");
                JSONObject c_regex = (JSONObject) binding.get("regex");
                hasKey = new InheritedResource(c_label.get("value").toString(), c_title.get("value").toString(), c.get("value").toString(), prop.get("value").toString(), c_query.get("value").toString());
                hasKey.setRegex(!(c_regex == null) ? c_regex.get("value").toString() : null);
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] Unable to load resource key information");
                Logger.getLogger(Resource.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Loads information for the Concept individual associated with the Resource.
     * 
     * @return success of the operation.
     */
    private boolean loadConcept() {
        boolean success = false;
        try {
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?c ?title ?label WHERE { "
                    + PrefixFactory.encode(uri) + " coeus:isResourceOf ?c ."
                    + " ?c dc:title ?title ."
                    + " ?c rdfs:label ?label}", "js", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");
            for (Object obj : bindings) {
                JSONObject binding = (JSONObject) obj;
                JSONObject con_label = (JSONObject) binding.get("label");
                JSONObject con_title = (JSONObject) binding.get("title");
                JSONObject con = (JSONObject) binding.get("c");
                isResourceOf = new Concept(con.get("value").toString(), con_title.get("value").toString(), con_label.get("value").toString());
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] Unable to load resource concept information");
                Logger.getLogger(Resource.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Verifies if direct resource dependencies are already built.
     *
     * @return dependency building status.
     */
    public boolean builtDependency() {
        boolean success = false;
        try {
            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(Boot.getAPI().select("SELECT ?built { "
                    + " ?res a coeus:Resource . "
                    + " ?res rdfs:label ?label ."
                    + " ?res coeus:extends ?concept ."
                    + " ?concept coeus:hasResource ?dep ."
                    + " OPTIONAL{?dep coeus:built ?built}"
                    + " FILTER regex(str(?label), \"" + this.label + "\")"
                    + "}", "js", false));
            JSONObject results = (JSONObject) response.get("results");
            JSONArray bindings = (JSONArray) results.get("bindings");
            for (Object obj : bindings) {
                JSONObject binding = (JSONObject) obj;
                JSONObject desc = (JSONObject) binding.get("built");
                success = !(desc == null) ? Boolean.parseBoolean(desc.get("value").toString()) : false;
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Resource] Unable to verify dependencies");
                Logger.getLogger(Resource.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    @Override
    public String toString() {
        return publisher + " Resource " + title + "\n\t - " + label + "\n\t - " + description + "\n\t - " + source + "\n\t >> " + uri;
    }
}
