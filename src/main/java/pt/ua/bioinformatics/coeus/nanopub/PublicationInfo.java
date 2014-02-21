/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.nanopub;

import com.hp.hpl.jena.graph.Node;
import com.hp.hpl.jena.graph.Triple;
import com.hp.hpl.jena.sparql.core.Quad;
import java.util.ArrayList;
import java.util.List;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.data.Predicate;

/**
 *
 * @author Pedro Sernadela <sernadela at ua.pt>
 */
public class PublicationInfo {

    String id;
    List<Quad> content = new ArrayList<Quad>();

    public PublicationInfo(String id) {
        this.id = id;
        init();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public List<Quad> getContent() {
        return content;
    }

    public void setContent(List<Quad> content) {
        this.content = content;
    }

    private void init() {
        Triple type = new Triple(Node.createURI(id), Node.createURI(Predicate.get("rdf:type").getURI()), Node.createURI(PrefixFactory.getURIForPrefix("np") + "PublicationInfo"));
        add(type);
    }

    /**
     * Add a triple to the PublicationInfo graph
     *
     * @param t
     */
    public void add(Triple t) {
        Quad q = new Quad(Node.createURI(id), t);
        content.add(q);
    }
}
