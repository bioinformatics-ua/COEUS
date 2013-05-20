package pt.ua.bioinformatics.coeus.data.connect;

import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.plugins.OMIMPlugin;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 * Data factory for transforming SPARQL data into RDF items using generic
 * Triplify.
 *
 * @author pedrolopes
 */
public class PluginFactory implements ResourceFactory {

    private Resource res;

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public PluginFactory(Resource r) {
        this.res = r;
    }

    /**
     * Reads SPARQL data according to Resource information.
     * <p>Workflow</b><ol>
     * <li>Check if resource is starter/extends</li>
     * <li>Load SPARQL resource into ResultSet</li>
     * <li>Start Triplify with factory Resource</li>
     * <li>Get data for Item key into Triplify</li>
     * <li>Load data for each InheritedResource property into Triplify hashmap
     * based on SPARQL elements</li>
     * <li>Itemize single item</li>
     * </ol></p>
     */
    public void read() {
        String[] divide = res.getEndpoint().split("://");
        String type = divide[0];
        try {
            if (type.equals("omim")) {
                OMIMPlugin omim = new OMIMPlugin(res);
                omim.itemize();
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][SPARQLFactory] unable to load data for " + res.getUri());
                Logger.getLogger(PluginFactory.class.getName()).log(Level.SEVERE, null, ex);
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
                Logger.getLogger(PluginFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
}
