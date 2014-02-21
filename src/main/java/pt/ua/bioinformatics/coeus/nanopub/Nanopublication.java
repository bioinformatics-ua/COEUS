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

    String id;
    Assertion assertion; //each np has only one Assertion graph (in this implementation)
    Provenance provenace; //each np has only one Provenance graph (in this implementation)
    PublicationInfo pubInfo; //each np has only one PublicationInfo graph (in this implementation)
    List<Quad> content = new ArrayList<Quad>(); //quads only relative to the np itself

    public Nanopublication(String id, Assertion assertion, Provenance provenace, PublicationInfo pubInfo) {
        this.id = id;
        this.assertion = assertion;
        this.provenace = provenace;
        this.pubInfo = pubInfo;
        init();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public List<Quad> getContent() {
        return content;
    }

    public void setContent(List<Quad> content) {
        this.content = content;
    }

    /**
     * Add a triple to the np graph
     * @param t 
     */
    public void add(Triple t) {
        Quad q = new Quad(Node.createURI(id), t);
        content.add(q);
    }

    /**
     * Create the linkage with the np fields
     *
     */
    private void init() {
        Triple type = new Triple( Node.createURI(id), Node.createURI(Predicate.get("rdf:type").getURI()), Node.createURI(PrefixFactory.getURIForPrefix("np") + "Nanopublication"));
        add(type);
        Triple hasAssertion = new Triple(Node.createURI(id), Node.createURI(PrefixFactory.getURIForPrefix("np")+"hasAssertion"), Node.createURI(assertion.getId()));
        add(hasAssertion);
        Triple hasProv = new Triple( Node.createURI(id), Node.createURI(PrefixFactory.getURIForPrefix("np")+"hasProvenance"), Node.createURI(provenace.getId()));
        add(hasProv);
        Triple hasInfo = new Triple( Node.createURI(id), Node.createURI(PrefixFactory.getURIForPrefix("np")+"hasPublicationInfo"), Node.createURI(pubInfo.getId()));
        add(hasInfo);
    }

    /**
     * Write all quads associated with the np
     * 
     * @return 
     */
    public String writeNQuads() {
        
        DatasetGraph dg = DatasetGraphFactory.createMem();
        //load all Quads related with nanopub itself
        for (Quad q : getContent()) {
            dg.add(q);
        }
        //load all Quads related with nanopub Assertion graph
        for (Quad q : getAssertion().getContent()) {
            dg.add(q);
        }
        //load all Quads related with nanopub Provenance graph
        for (Quad q : getProvenace().getContent()) {
            dg.add(q);
        }
        //load all Quads related with nanopub PublicationInfo graph
        for (Quad q : getPubInfo().getContent()) {
            dg.add(q);
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(baos);
        RiotWriter.writeNQuads(ps, dg);
        dg.close();

        return baos.toString();
    }
    

}
