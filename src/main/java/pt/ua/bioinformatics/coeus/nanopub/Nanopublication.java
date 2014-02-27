/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.nanopub;

import com.hp.hpl.jena.graph.Node;
import com.hp.hpl.jena.graph.Triple;
import com.hp.hpl.jena.sparql.core.DatasetGraph;
import com.hp.hpl.jena.sparql.core.DatasetGraphFactory;
import com.hp.hpl.jena.sparql.core.Quad;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;
import org.openjena.riot.RiotWriter;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.data.Predicate;

/**
 * Nanopublication (nanopub.org) implementation with Apache Jena (jena.apache.org).
 * 
 * @author Pedro Sernadela <sernadela at ua.pt>
 */
public class Nanopublication {

    String uri; // np uri graph
    Assertion assertion; //each np has only one Assertion graph (in this implementation)
    Provenance provenace; //each np has only one Provenance graph (in this implementation)
    PublicationInfo pubInfo; //each np has only one PublicationInfo graph (in this implementation)
    List<Triple> content = new ArrayList<Triple>(); //triples only relative to the np itself

    public Nanopublication(String uri, Assertion assertion, Provenance provenace, PublicationInfo pubInfo) {
        this.uri = uri;
        this.assertion = assertion;
        this.provenace = provenace;
        this.pubInfo = pubInfo;
        init();
    }

    public String getUri() {
        return uri;
    }

    public void setUri(String uri) {
        this.uri = uri;
    }

    public Assertion getAssertion() {
        return assertion;
    }

    public void setAssertion(Assertion assertion) {
        this.assertion = assertion;
    }

    public Provenance getProvenace() {
        return provenace;
    }

    public void setProvenace(Provenance provenace) {
        this.provenace = provenace;
    }

    public PublicationInfo getPubInfo() {
        return pubInfo;
    }

    public void setPubInfo(PublicationInfo pubInfo) {
        this.pubInfo = pubInfo;
    }

    public List<Triple> getContent() {
        return content;
    }

    public void setContent(List<Triple> content) {
        this.content = content;
    }

    /**
     * Add a triple to the np graph
     * @param t 
     */
    public void add(Triple t) {
        content.add(t);
    }

    /**
     * Create the linkage with the np fields
     *
     */
    private void init() {
        Triple type = new Triple( Node.createURI(uri), Node.createURI(Predicate.get("rdf:type").getURI()), Node.createURI(PrefixFactory.getURIForPrefix("np") + "Nanopublication"));
        add(type);
        Triple hasAssertion = new Triple(Node.createURI(uri), Node.createURI(PrefixFactory.getURIForPrefix("np")+"hasAssertion"), Node.createURI(assertion.getUri()));
        add(hasAssertion);
        Triple hasProv = new Triple( Node.createURI(uri), Node.createURI(PrefixFactory.getURIForPrefix("np")+"hasProvenance"), Node.createURI(provenace.getUri()));
        add(hasProv);
        Triple hasInfo = new Triple( Node.createURI(uri), Node.createURI(PrefixFactory.getURIForPrefix("np")+"hasPublicationInfo"), Node.createURI(pubInfo.getUri()));
        add(hasInfo);
    }
    
    /**
     * Retrieve only the quads associated with the np itself
     * @return 
     */
    public List<Quad> getNanopubQuads(){
        List<Quad> q=new ArrayList<Quad>();
        for (Triple triple : content) {
            Quad quad=new Quad(Node.createURI(uri), triple);
            q.add(quad);
        }
        return q;
    } 

    /**
     * Write all quads associated with the np
     * 
     * @return 
     */
    public String writeNQuads() {
        
        DatasetGraph dg = DatasetGraphFactory.createMem();
        //load all Quads related with nanopub itself
        for (Quad q : getNanopubQuads()) {
            dg.add(q);
        }
        //load all Quads related with nanopub Assertion graph
        for (Quad q : getAssertion().getAssertionQuads()) {
            dg.add(q);
        }
        //load all Quads related with nanopub Provenance graph
        for (Quad q : getProvenace().getProvenanceQuads()) {
            dg.add(q);
        }
        //load all Quads related with nanopub PublicationInfo graph
        for (Quad q : getPubInfo().getPublicationInfoQuads()) {
            dg.add(q);
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(baos);
        RiotWriter.writeNQuads(ps, dg);
        dg.close();

        return baos.toString();
    }
    

}
