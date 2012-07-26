package pt.ua.bioinformatics.coeus.domain;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 * Handles mappings for COEUS Item individuals.
 * <p>Item individuals are single entities in COEUS ontology</p>
 * 
 * @author pedrolopes
 */
public class Item {

    private String id;
    private String title;
    private String label;
    private String uri;
    private HashMap<String, String> properties = new HashMap<String, String>();
    private Concept hasConcept;
    private String key;

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Concept getHasConcept() {
        return hasConcept;
    }

    public void setHasConcept(Concept hasConcept) {
        this.hasConcept = hasConcept;
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

    public String getUri() {
        return uri;
    }

    public void setUri(String uri) {
        this.uri = uri;
    }

    public HashMap<String, String> getProperties() {
        return properties;
    }

    public void setProperties(HashMap<String, String> properties) {
        this.properties = properties;
    }

    public Item(String uri, String title, String label) {
        this.title = title;
        this.label = label;
        this.uri = uri;
    }

    /** 
     * Create a new Item based on its key.
     * <p>Keys may be entire URIs or simple &lt;key&gt;:&lt;value&gt; pairs.</p>
     * 
     * @param key The Item key.
     */
    public Item(String key) {
        this.key = key;
        if (key.startsWith("http://")) {
        } else {
            try {
                ResultSet results = Boot.getAPI().selectRS("SELECT ?p ?o {coeus:" + key + " ?p ?o }", false);
                while (results.hasNext()) {
                    QuerySolution row = results.next();
                    if (PrefixFactory.encode(row.get("p").toString()).equals("diseasecard:omim")) {
                        this.id = row.get("o").toString();
                    } else if (PrefixFactory.encode(row.get("p").toString()).equals("rdfs:label")) {
                        this.label = row.get("o").toString();
                    } else {
                        this.hasConcept = new Concept(row.get("o").toString());
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Item] Unable load Item from key");
                    Logger.getLogger(Item.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    public Item() {
    }

    /**
     * Adds a new property to the Item property map.
     * 
     * @param predicate
     * @param literal 
     */
    public void addProperty(String predicate, String literal) {
        this.properties.put(predicate, literal);
    }

    @Override
    public String toString() {
        return "Item{" + "title=" + title + ", label=" + label + ", uri=" + uri + ", properties=" + properties + ", hasConcept=" + hasConcept + '}';
    }
}
