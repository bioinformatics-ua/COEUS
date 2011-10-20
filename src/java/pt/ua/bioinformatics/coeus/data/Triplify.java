package pt.ua.bioinformatics.coeus.data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ConceptFactory;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 * Generic data transformer to get triples into SDB Store.
 *
 * @author pedrolopes
 */
public class Triplify {

    private HashMap<String, String> properties = new HashMap<String, String>();
    private Resource resource;
    private String extension = "";
    private API api = Boot.getAPI();
    private ArrayList<String> map = new ArrayList<String>();

    public API getApi() {
        return api;
    }

    public void setApi(API api) {
        this.api = api;
    }

    public ArrayList<String> getMap() {
        return map;
    }

    public void setMap(ArrayList<String> map) {
        this.map = map;
    }

    public String getExtension() {
        return extension;
    }

    public void setExtension(String extension) {
        this.extension = extension;
    }

    public Triplify(Resource resource, String extension) {
        this.resource = resource;
        this.extension = extension;
    }

    public Resource getResource() {
        return resource;
    }

    public void setResource(Resource r) {
        this.resource = r;
    }

    public HashMap<String, String> getProperties() {
        return properties;
    }

    public void setProperties(HashMap<String, String> properties) {
        this.properties = properties;
    }

    public String get(String what) {
        return properties.get(what);
    }

    public void add(String pred, String obj) {
        properties.put(pred, obj);
    }

    public void clear() {
        properties.clear();
    }

    public Triplify(Resource r) {
        this.resource = r;
    }

    /**
     * Creates new Item individual in SDB and respective statements according to setup file.
     * <p><b>Workflow</b><ol>
     *  <li>Add Item with <concept>_<key> structure and default properties</li>
     *  <li>Connect Item with respective Concept</li>
     *  <li>Associate with Item from extension</li>
     *  <li>Add Resource-specific properties</li>
     * </ol></p>
     *
     * @param i
     * @return
     */
    public boolean itemize(String i) {
        boolean success = false;
        try {
            // create initial Item triple with <concept>_<key> structure
            String[] itemTmp = resource.getIsResourceOf().getLabel().split("_");
            com.hp.hpl.jena.rdf.model.Resource item = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + itemTmp[1] + "_" + i);
            com.hp.hpl.jena.rdf.model.Resource obj = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "Item");
            api.addStatement(item, Predicate.get("rdf:type"), obj);

            // set Item label and creator
            api.addStatement(item, Predicate.get("rdfs:label"), ConceptFactory.getTokenFromConcept(this.resource.getIsResourceOf().getLabel()) + i);
            api.addStatement(item, Predicate.get("dc:creator"), Config.getName());

            // associate Item with Concept
            com.hp.hpl.jena.rdf.model.Resource con = api.getResource(resource.getIsResourceOf().getUri());
            api.addStatement(item, Predicate.get("coeus:hasConcept"), con);
            api.addStatement(con, Predicate.get("coeus:isConceptOf"), item);

            // associate with other Item
            if (!extension.equals("")) {
                com.hp.hpl.jena.rdf.model.Resource it = api.getResource(extension);
                api.addStatement(item, Predicate.get("coeus:isAssociatedTo"), it);
                api.addStatement(it, Predicate.get("coeus:isAssociatedTo"), item);
            }

            // set Resource-specific properties (from HashMap)
            for (String key : properties.keySet()) {
                api.addStatement(item, Predicate.get(key), properties.get(key));
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Triplify] Unable to add item to " + resource.getTitle());
                Logger.getLogger(Triplify.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Completes an Item individual in SDB with respective statements according to setup file.
     * <p><b>Workflow</b><ol>
     *  <li>Get Item from <concept>_<key> structure</li>
     *  <li>Add Resource-specific properties</li>
     * </ol></p>
     * 
     * @param uri
     * @return
     */
    public boolean complete() {
        boolean success = false;
        try {
            // get initial Item triple with <concept>_<key> structure
            com.hp.hpl.jena.rdf.model.Resource item = api.getResource(extension);

            // set Resource-specific properties (from HashMap)
            for (String key : properties.keySet()) {
                api.addStatement(item, Predicate.get(key), properties.get(key));
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Triplify] Unable to complete " + extension);
                Logger.getLogger(Triplify.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Maps two Item individual lists in SDB with respective statements according to setup file.
     * <p><b>Workflow</b><ol>
     *  <li>Get Item from <concept>_<key> structure</li>
     *  <li>Map new Item</li>
     * </ol></p>
     * @return 
     */
    public boolean map() {
        boolean success = false;
        try {
            com.hp.hpl.jena.rdf.model.Resource item = api.getResource(extension);
            for (String s : map) {
                try {
                    com.hp.hpl.jena.rdf.model.Resource to = api.getResource(s);
                    api.addStatement(item, Predicate.get("coeus:isAssociatedTo"), to);
                } catch (Exception ex) {
                    if (Config.isDebug()) {
                        System.out.println("[COEUS][API] Unable to map " + extension.toString() + " for " + s);
                    }
                }
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to map " + extension.toString());
                Logger.getLogger(Triplify.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
}
