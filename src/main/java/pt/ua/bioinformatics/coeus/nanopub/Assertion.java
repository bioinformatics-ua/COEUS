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
public class Assertion {

    String uri; // assertion uri graph
    List<Triple> content = new ArrayList<Triple>();

    public Assertion(String uri) {
        this.uri = uri;
        init();
    }

    public String getUri() {
        return uri;
    }

    public void setUri(String uri) {
        this.uri = uri;
    }

    public List<Triple> getContent() {
        return content;
    }

    public void setContent(List<Triple> content) {
        this.content = content;
    }

    private void init() {
        Triple type = new Triple(Node.createURI(uri), Node.createURI(Predicate.get("rdf:type").getURI()), Node.createURI(PrefixFactory.getURIForPrefix("np") + "Assertion"));
        add(type);
    }

    /**
     * Add a triple to the assertion graph
     *
     * @param t
     */
    public void add(Triple t) {
        content.add(t);
    }
    
     /**
     * Retrieve only the quads associated with the np assertion field
     *
     * @return
     */
    public List<Quad> getAssertionQuads() {
        List<Quad> q = new ArrayList<Quad>();
        for (Triple triple : content) {
            Quad quad = new Quad(Node.createURI(uri), triple);
            q.add(quad);
        }
        return q;
    }
}
