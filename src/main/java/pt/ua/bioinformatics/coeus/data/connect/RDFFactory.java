/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.data.connect;

import com.hp.hpl.jena.ontology.Individual;
import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Statement;
import com.hp.hpl.jena.util.iterator.ExtendedIterator;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ItemFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.data.Triplify;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 *
 * @author sernadela
 */
public class RDFFactory implements ResourceFactory {

    private Resource res;
    private API api = Boot.getAPI();
    private Triplify rdfizer;
    private boolean hasError = false;

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
     * Reads RDF data and links individuals according to Resource information. 
     */
    public void read() {
        if (res.getMethod().equals("cache")) {
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
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][RDFFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(RDFFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("complete")) {

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
                        //auxiliar model
                        OntModel auxModel = ModelFactory.createOntologyModel();
                        auxModel.read(endpoint);
                        ExtendedIterator<Individual> individuals = auxModel.listIndividuals();
                        // if query is not provided link all individuals to the item
                        if (res.getQuery() == null | res.getQuery().equals("")) {
                            while (individuals.hasNext()) {
                                Individual individual = individuals.next();
                                rdfizer.getMap().add(individual.asResource().toString());
                            }
                        } else {
                            while (individuals.hasNext()) {
                                Individual individual = individuals.next();
                                String uri = res.getQuery();
                                if (!res.getQuery().startsWith("http")) {
                                    uri = auxModel.getNsPrefixURI(uri);
                                }
                                if (individual.getNameSpace().equals(uri)) {
                                    rdfizer.getMap().add(individual.asResource().toString());
                                }
                            }
                        }
                        //link all individuals
                        rdfizer.link("coeus:isAssociatedTo");
                        //import rdf data
                        rdfizer.getApi().readModel(endpoint);

                    } catch (Exception ex) {
                        if (Config.isDebug()) { saveError(ex);
                            System.out.println("[COEUS][RDFFactory] unable to load data for " + item);
                            Logger.getLogger(RDFFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }

            } catch (Exception ex) {
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][RDFFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(RDFFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
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
                Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
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
