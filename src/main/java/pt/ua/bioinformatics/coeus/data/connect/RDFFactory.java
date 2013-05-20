/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.data.connect;

import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ItemFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 *
 * @author sernadela
 */
public class RDFFactory implements ResourceFactory {

    private Resource res;
    private API api = Boot.getAPI();

    public RDFFactory(Resource r) {
        this.res = r;
    }

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public API getApi() {
        return api;
    }

    public void setApi(API api) {
        this.api = api;
    }

    /**
     * Reads RDF data according to Resource information. <p>Workflow</b><ol>
     * <li>Get resource endpoint</li> <li>Start to load</li></ol></p>
     */
    public void read() {

        try {
            if (res.getExtendsConcept().equals(res.getIsResourceOf().getUri())) {
                if (res.getPublisher().equals("ttl")) {
                    System.out.println(res.getEndpoint());
                    api.readModel(res.getEndpoint(), "TURTLE");
                } else {
                    api.readModel(res.getEndpoint());
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
                    String location = res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(item));
                    if (res.getPublisher().equals("ttl")) {
                        api.readModel(res.getEndpoint(), "TURTLE");
                    } else {
                        api.readModel(location);
                    }
                }
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][RDFFactory] unable to load data for " + res.getUri());
                Logger.getLogger(RDFFactory.class.getName()).log(Level.SEVERE, null, ex);
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
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
            api.addStatement(resource, Predicate.get("coeus:built"), true);
            success = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Saved resource " + res.getUri());
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to save resource " + res.getUri());
                Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
}
