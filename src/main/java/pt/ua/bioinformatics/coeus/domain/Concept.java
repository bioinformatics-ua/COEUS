package pt.ua.bioinformatics.coeus.domain;

import java.util.HashMap;

/**
 * Handles mappings for COEUS Concept individuals.
 * <p>Concept objects are logically organized below Entity and above Item
 * objects.
 * </p>
 *
 * @author pedrolopes
 */
public class Concept {

    private String description;
    private String label;
    private String title;
    private String uri = "";
    private Resource hasResource;
    private HashMap<String, String> properties = new HashMap<String, String>();
    private Entity hasEntity;

    public Entity getHasEntity() {
        return hasEntity;
    }

    public void setHasEntity(Entity hasEntity) {
        this.hasEntity = hasEntity;
    }

    public HashMap<String, String> getProperties() {
        return properties;
    }

    public void setProperties(HashMap<String, String> properties) {
        this.properties = properties;
    }

    public Concept() {
    }

    public Concept(String uri) {
        this.uri = uri;
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

    public Concept(String uri, String title, String label, String description) {
        this.uri = uri;
        this.description = description;
        this.label = label;
        this.title = title;
    }

    public Concept(String uri, String title, String label) {
        this.uri = uri;
        this.label = label;
        this.title = title;
    }

    public Resource getHasResource() {
        return hasResource;
    }

    public void setHasResource(Resource hasResource) {
        this.hasResource = hasResource;
    }

    /**
     * Adds a new property to the Concept property map.
     *
     * @param predicate
     * @param literal
     */
    public void addProperty(String predicate, String literal) {
        this.properties.put(predicate, literal);
    }

    @Override
    public String toString() {
        return "[COEUS][Concept] " + title + "\n\t - " + label + "\n\t >> " + uri;
    }
}
