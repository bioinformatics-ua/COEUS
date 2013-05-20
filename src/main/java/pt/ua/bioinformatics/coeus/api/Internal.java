package pt.ua.bioinformatics.coeus.api;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.domain.Concept;
import pt.ua.bioinformatics.coeus.domain.Entity;
import pt.ua.bioinformatics.coeus.domain.Item;

/**
 * Utility class for COEUS internal methods.
 *
 * @author pedrolopes
 */
public class Internal {

    private static API api;

    /**
     * Loads Concept object information from COEUS SDB for given identifier.
     *
     * @param concept key:value or URI for desired Concept.
     * @return loaded Concept object.
     */
    public static Concept getConcept(String concept) {
        api = Boot.getAPI();
        Concept c = new Concept();
        String query = "";
        if (concept.contains("http")) {
            query = "SELECT * {"
                    + "<" + concept + "> dc:title ?title ."
                    + "<" + concept + "> rdfs:label ?label ."
                    + "<" + concept + "> dc:description ?description ."
                    + "<" + concept + "> coeus:hasEntity ?entity"
                    + " }";
        } else {
            query = "SELECT * {"
                    + "coeus:" + concept + " dc:title ?title ."
                    + "coeus:" + concept + " rdfs:label ?label ."
                    + "coeus:" + concept + " dc:description ?description ."
                    + "coeus:" + concept + " coeus:hasEntity ?entity"
                    + " }";
        }
        ResultSet rs = api.selectRS(query, false);
        while (rs.hasNext()) {
            QuerySolution row = rs.nextSolution();
            c.setDescription(row.getLiteral("description").getString());
            c.setTitle(row.getLiteral("title").getString());
            c.setLabel(row.getLiteral("label").getString());
            c.setHasEntity(getEntity(row.get("entity").toString()));
            c.setUri(concept);
        }
        return c;
    }

    /**
     * Loads Entity object information from COEUS SDB for given identifier.
     *
     * @param entity key:value or URI for desired Entity.
     * @return loaded Entity object.
     */
    public static Entity getEntity(String entity) {
        api = Boot.getAPI();
        Entity e = new Entity();
        String query = "";
        if (entity.contains("http")) {
            query = "SELECT * {"
                    + "<" + entity + "> dc:title ?title ."
                    + "<" + entity + "> rdfs:label ?label ."
                    + "<" + entity + "> dc:description ?description }";

        } else {
            query = "SELECT * {"
                    + "coeus:" + entity + " dc:title ?title ."
                    + "coeus:" + entity + " rdfs:label ?label ."
                    + "coeus:" + entity + " dc:description ?description }";
        }
        ResultSet rs = api.selectRS(query, false);
        while (rs.hasNext()) {
            QuerySolution row = rs.nextSolution();
            e.setDescription(row.getLiteral("description").getString());
            e.setTitle(row.getLiteral("title").getString());
            e.setLabel(row.getLiteral("label").getString());
            e.setUri(entity);
        }
        return e;
    }

    /**
     * Loads Item object information from COEUS SDB for given identifier.
     *
     * @param item key:value or URI for desired Item.
     * @return loaded Item object.
     */
    public static Item getItem(String item) {
        api = Boot.getAPI();
        Item i = new Item();
        String query = "";
        if (item.contains("http")) {
            query = "SELECT * {"
                    + "<" + item + "> dc:title ?title ."
                    + "<" + item + "> rdfs:label ?label ."
                    + "<" + item + "> coeus:isAssociatedTo ?item"
                    + "}";

        } else {
            query = "SELECT * {"
                    + "coeus:" + item + " dc:title ?title ."
                    + "coeus:" + item + " rdfs:label ?label ."
                    + "coeus:" + item + " coeus:isAssociatedTo ?item }";
        }
        ResultSet rs = api.selectRS(query, false);
        while (rs.hasNext()) {
            QuerySolution row = rs.nextSolution();
            i.setTitle(row.getLiteral("title").getString());
            i.setLabel(row.getLiteral("label").getString());
            i.addProperty("coeus:isAssociatedTo", row.get("item").toString());
            i.setUri(item);
        }
        return i;
    }

    /**
     * Loads all Concepts associated with the given Entity object.
     *
     * @param e the Entity object.
     * @return ArrayList<Concept> filled with Concept objects.
     */
    public static ArrayList<Concept> getConcepts(Entity e) {
        ArrayList<Concept> concepts = new ArrayList<Concept>();
        try {
            api = Boot.getAPI();
            String query = "";
            if (e.getUri().contains("http")) {
                query = "SELECT * {"
                        + "<" + e.getUri() + "> coeus:isEntityOf ?c ."
                        + "?c dc:title ?title ."
                        + "?c rdfs:label ?label ."
                        + "?c dc:description ?description }";

            } else {
                query = "SELECT * {"
                        + "coeus:" + e.getUri() + " coeus:isEntityOf ?c ."
                        + "?c dc:title ?title ."
                        + "?c rdfs:label ?label ."
                        + "?c dc:description ?description }";
            }
            ResultSet rs = api.selectRS(query, false);
            while (rs.hasNext()) {
                QuerySolution row = rs.nextSolution();
                Concept c = new Concept();
                c.setDescription(row.getLiteral("description").getString());
                c.setTitle(row.getLiteral("title").getString());
                c.setLabel(row.getLiteral("label").getString());
                c.setHasEntity(getEntity(row.get("entity").toString()));
                c.setUri(row.get("c").toString());
                concepts.add(c);
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][Internal] Unable to load concepts for Entity " + e.getTitle());
            }
            Logger.getLogger(Internal.class.getName()).log(Level.SEVERE, null, ex);
        }
        return concepts;
    }
}
