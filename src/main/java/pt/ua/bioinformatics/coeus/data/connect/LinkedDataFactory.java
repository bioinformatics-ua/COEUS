/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.data.connect;

import com.hp.hpl.jena.rdf.model.Statement;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ItemFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.data.Triplify;
import pt.ua.bioinformatics.coeus.domain.InheritedResource;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 *
 * @author sernadela
 */
public class LinkedDataFactory implements ResourceFactory {

    private Resource res;
    private Triplify rdfizer;
    private boolean hasError = false;

    public LinkedDataFactory(Resource r) {
        this.res = r;
    }

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public Triplify getRdfizer() {
        return rdfizer;
    }

    public void setRdfizer(Triplify rdfizer) {
        this.rdfizer = rdfizer;
    }

     /**
     * Add Linked Data according to Resource information.
     * <p>Workflow</b><ol>
     * <li>Get Linked data URI (endpoint)</li>
     * <li>Link it to the respective item</li>
     * <li>If methot is complete add also the rdf data</li>
     * </ol></p>
     */
    @Override
    public void read() {

        try {
            HashMap<String, String> extensions;
            if (res.getExtension().equals("")) {
                extensions = res.getExtended();
            } else {
                extensions = res.getExtended(res.getExtension());
            }
            for (String item : extensions.keySet()) {
                try {
                    String endpoint = res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(item));
                    rdfizer = new Triplify(res, extensions.get(item));
                    InheritedResource key = (InheritedResource) res.getHasKey();
                    rdfizer.getMap().add(endpoint);
                    String[] predicates = key.getProperty().split("\\|");
                    //link all user predicates
                    for (String p : predicates) {
                        rdfizer.link(p);
                    }
                    //link default predicate
                    rdfizer.link("coeus:isAssociatedTo");
                    //import rdf data only if methot is complete
                    if (res.getMethod().equals("complete")) {
                        String base = res.getEndpoint().replace("#replace#", "");
                        URL url = new URL(endpoint);
                        URLConnection conn = url.openConnection();
                        //set linked data content to rdf
                        conn.setRequestProperty("Accept", "application/rdf+xml");
                        //add to the api model
                        rdfizer.getApi().readModel(conn.getInputStream(), base);
                    }
                } catch (Exception ex) {
                    if (Config.isDebug()) { saveError(ex);
                        System.out.println("[COEUS][LinkedDataFactory] unable to load data for " + item);
                        Logger.getLogger(LinkedDataFactory.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }

        } catch (Exception ex) {
            if (Config.isDebug()) { saveError(ex);
                System.out.println("[COEUS][LinkedDataFactory] unable to load data for " + res.getUri());
                Logger.getLogger(LinkedDataFactory.class.getName()).log(Level.SEVERE, null, ex);
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
            //only change built property if there are no errors
            if (hasError == false) {
                API api = Boot.getAPI();
                com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
                Statement statementToRemove = api.getModel().createLiteralStatement(resource, Predicate.get("coeus:built"), false);
                api.removeStatement(statementToRemove);
                api.addStatement(resource, Predicate.get("coeus:built"), true);
            }
            success = true;
            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Saved resource " + res.getUri());
            }
        } catch (Exception ex) {
            if (Config.isDebug()) { saveError(ex);
                System.out.println("[COEUS][API] Unable to save resource " + res.getUri());
                Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
    
    private void saveError(Exception ex) {
        try {
            API api = Boot.getAPI();
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
            Statement statement=api.getModel().createLiteralStatement(resource, Predicate.get("dc:coverage"), "ERROR: "+ex.getMessage()+". For more information, please see the application server log.");
            api.addStatement(statement);
            hasError = true;

            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Saved error on resource " + res.getUri());
            }
        } catch (Exception e) {
            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Unable to save error on resource " + res.getUri());
                Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, e);
            }
        }
    }

}
