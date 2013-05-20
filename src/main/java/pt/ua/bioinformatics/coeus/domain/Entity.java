package pt.ua.bioinformatics.coeus.domain;

import java.util.ArrayList;
import java.util.HashMap;
import pt.ua.bioinformatics.coeus.api.Internal;

/**
 * Handles mappings for COEUS Entity individuals.
 * <p>COEUS Entity objects are the high level umbrella-types. <strong>Entity
 * &gt; Concept &gt; Item</strong>.
 * </p>
 *
 * @author pedrolopes
 */
public class Entity {

    private String uri;
    private String label;
    private String title;
    private String description;
    private HashMap<String, String> properties = new HashMap<String, String>();
    private ArrayList<Concept> isEntityOf = new ArrayList<Concept>();

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ArrayList<Concept> getIsEntityOf() {
        return isEntityOf;
    }

    public void setIsEntityOf(ArrayList<Concept> isEntityOf) {
        this.isEntityOf = isEntityOf;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public HashMap<String, String> getProperties() {
        return properties;
    }

    public void setProperties(HashMap<String, String> properties) {
        this.properties = properties;
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

    public Entity(String uri, String label, String title) {
        this.uri = uri;
        this.label = label;
        this.title = title;
    }

    public Entity(String uri) {
        this.uri = uri;
    }

    public Entity() {
    }

    /**
     * Adds a new property to the Entity property map.
     *
     * @param predicate
     * @param literal
     */
    public void addProperty(String predicate, String literal) {
        this.properties.put(predicate, literal);
    }

    public void loadConcepts() {
        this.isEntityOf = Internal.getConcepts(this);
    }

    @Override
    public String toString() {
        return "[COEUS][Entity] " + title + "\n\t - " + label + "\n\t >> " + uri;
    }
}
