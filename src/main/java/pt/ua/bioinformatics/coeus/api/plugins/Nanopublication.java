/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.api.plugins;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import java.util.HashMap;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;

/**
 *
 * @author pedrolopes
 */
public class Nanopublication {
    private String id;
    private HashMap<String, String> assertion = new HashMap<String, String>();
    private HashMap<String, String> provenance = new HashMap<String, String>();
    private HashMap<String, String> publication = new HashMap<String, String>();

    public HashMap<String, String> getAssertion() {
        return assertion;
    }

    public void setAssertion(HashMap<String, String> assertion) {
        this.assertion = assertion;
    }

    public HashMap<String, String> getProvenance() {
        return provenance;
    }

    public void setProvenance(HashMap<String, String> provenance) {
        this.provenance = provenance;
    }

    public HashMap<String, String> getPublication() {
        return publication;
    }

    public void setPublication(HashMap<String, String> publication) {
        this.publication = publication;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Nanopublication(String id) {
        this.id = id;        
    }
    
    public void load() {
        ResultSet rs_assertion = Boot.getAPI().selectRS("SELECT ?p ?o WHERE { <http://bioinformatics.ua.pt/nanoadr/resource/assertion_" + id + "> ?p ?o}", false);
        while (rs_assertion.hasNext()) {
            QuerySolution row = rs_assertion.next();
           
            assertion.put(PrefixFactory.encode(row.get("p").toString()), PrefixFactory.encode(row.get("o").toString()));
           
        }
        ResultSet rs_provenance = Boot.getAPI().selectRS("SELECT ?p ?o WHERE { <http://bioinformatics.ua.pt/nanoadr/resource/provenance_" + id + "> ?p ?o}", false);
        while (rs_provenance.hasNext()) {
            QuerySolution row = rs_provenance.next();
            provenance.put(PrefixFactory.encode(row.get("p").toString()), PrefixFactory.encode(row.get("o").toString()));
        }
        ResultSet rs_pubinfo = Boot.getAPI().selectRS("SELECT ?p ?o WHERE { <http://bioinformatics.ua.pt/nanoadr/resource/pubinfo_" + id + "> ?p ?o}", false);
        while (rs_pubinfo.hasNext()) {
            QuerySolution row = rs_pubinfo.next();
            publication.put(PrefixFactory.encode(row.get("p").toString()), PrefixFactory.encode(row.get("o").toString()));
        }
    }
    
    
}
