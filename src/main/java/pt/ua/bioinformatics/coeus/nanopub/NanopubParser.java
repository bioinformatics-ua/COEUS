/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.nanopub;

import com.hp.hpl.jena.datatypes.xsd.XSDDatatype;
import com.hp.hpl.jena.graph.Node;
import com.hp.hpl.jena.graph.Triple;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.Statement;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.validator.routines.UrlValidator;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;

/**
 *
 * @author Pedro Sernadela <sernadela at ua.pt>
 */
public class NanopubParser {

    String concept;
    boolean loadAll = true;

    /**
     * Create a parser for the given concept. Ex: "coeus:concept_HGNC"
     *
     * @param concept
     */
    public NanopubParser(String concept) {
        this.concept = concept;
    }

    /**
     * Do the nanopublication generation/parsing
     *
     */
    public void parse() {

        Logger.getLogger(NanopubParser.class.getName()).log(Level.INFO, "[COEUS][NanopubParser] Start parsing: {0}", concept);

        Boot.start();

        String queryConcepts = "SELECT * {?item coeus:hasConcept " + concept + " FILTER NOT EXISTS {" + concept + " coeus:builtNp true }}";
        ResultSet rs = Boot.getAPI().selectRS(queryConcepts, false);
        if (!rs.hasNext() && Config.isDebug()) {
            System.out.println("[COEUS][NanopubParser] Already parsed the concept " + concept);
        }
        while (rs.hasNext()) {
            QuerySolution row = rs.next();

            String item = row.get("item").toString();
            //System.out.println(item);
            String queryItems = "SELECT * { <" + item + "> ?p ?o}";
            ResultSet rs_item = Boot.getAPI().selectRS(queryItems, false);

            String np_item = item + "_Nanopub";
            Assertion a = new Assertion(np_item + "_Assertion");
            //Add Items to Assertion field
            while (rs_item.hasNext()) {
                QuerySolution row_item = rs_item.next();
                String p = row_item.get("p").toString();
                String o = row_item.get("o").toString();
                //System.out.println(item + " " + p + " " + o);
                UrlValidator urlValidator = new UrlValidator();
                if (urlValidator.isValid(o)) {
                    a.add(new Triple(Node.createURI(item), Node.createURI(p), Node.createURI(o)));
                } else {
                    a.add(new Triple(Node.createURI(item), Node.createURI(p), Node.createLiteral(o)));
                }
                if (p.endsWith("isAssociatedTo") && loadAll) {
                    a = addAssociations(a, o);
                }
            }

            Provenance p = new Provenance(np_item + "_Provenance");
            p.add(new Triple(Node.createURI(a.getUri()), Node.createURI("http://www.w3.org/ns/prov#wasDerivedFrom"), Node.createLiteral("COEUS")));

            PublicationInfo i = new PublicationInfo(np_item + "_PubInfo");
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#generatedAtTime"), Node.createLiteral(new Date().toString(), null, XSDDatatype.XSDdateTime)));
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#wasAttributedTo"), Node.createLiteral(Config.getName())));
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#wasGeneratedBy"), Node.createURI(PrefixFactory.decode(concept))));

            /**/
            Nanopublication np = new Nanopublication(np_item, a, p, i);
            //System.out.println(np.writeNQuads());
            Boot.getAPI().storeNanopub(np, concept);

        }
        save();
    }

    /**
     * Save the result property in the concept
     *
     */
    public void save() {
        try {
            API api = Boot.getAPI();
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(PrefixFactory.decode(concept));
            Statement statementToRemove = api.getModel().createLiteralStatement(resource, Predicate.get("coeus:builtNp"), false);
            api.removeStatement(statementToRemove);
            api.addStatement(resource, Predicate.get("coeus:builtNp"), true);
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][NanopubParser] Unable to save property in concept " + concept);
                Logger.getLogger(NanopubParser.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
    }

    /**
     * Add all objects (recursive function) with the property
     * (coeus:isAssociatedTo) to the Assertion
     *
     * @param a
     * @param object
     * @return
     */
    public Assertion addAssociations(Assertion a, String object) {
        String queryItems = "SELECT * { <" + object + "> ?p ?o}";
        ResultSet rs_item = Boot.getAPI().selectRS(queryItems, false);

        while (rs_item.hasNext()) {
            QuerySolution row_item = rs_item.next();
            String p = row_item.get("p").toString();
            String o = row_item.get("o").toString();

            UrlValidator urlValidator = new UrlValidator();
            if (urlValidator.isValid(o)) {
                a.add(new Triple(Node.createURI(object), Node.createURI(p), Node.createURI(o)));
            } else {
                a.add(new Triple(Node.createURI(object), Node.createURI(p), Node.createLiteral(o)));
            }

            if (p.endsWith("isAssociatedTo")) {
                Triple t = new Triple(Node.createURI(o), Node.createURI(p), Node.createURI(object));
                if (!a.getContent().contains(t)) {
                    a = addAssociations(a, o);
                }
            }
        }
        return a;
    }
}
