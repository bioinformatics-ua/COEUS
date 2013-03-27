package pt.ua.bioinformatics.coeus.domain;

/**
 * Handles mappings for COEUS CSV, SQL, SPARQL and XML Resource types individuals.
 * <p>This InheritedResource data type permits having a single general class for every
 * external Resource, simplifying data import code.
 * </p>
 * 
 * @author pedrolopes
 */
public class InheritedResource {

    private String description;
    private String label;
    private String title;
    private String uri;
    private String property;
    private String query;
    private String regex;

    public String getRegex() {
        return regex;
    }

    public void setRegex(String regex) {
        this.regex = regex;
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

    public String getProperty() {
        return property;
    }

    public void setProperty(String property) {
        this.property = property;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
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

    public InheritedResource(String label, String title, String uri, String property, String query) {
        this.label = label;
        this.title = title;
        this.uri = uri;
        this.property = property;
        this.query = query;
    }

    @Override
    public String toString() {
        return "[COEUS][InheritedResource] " + title + "\n\t - " + label + "\n\t - " + description + "\n\t - " + property + "\n\t - " + query + "\n\t >> " + uri;
    }
}
