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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.validator.routines.UrlValidator;
import org.json.simple.JSONObject;
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

    String concept_root; // concept root
    List<String> concept_childs; // childs of the root concept (means load also items data)
    List<JSONObject> info; // additional info to include in the np
    List<JSONObject> prov; // additional prov to include in the np
    boolean loadAll = true;

    /**
     * Create a parser for the given concept root.
     *
     * @param concept_root
     * @param concept_childs
     * @param info
     * @param prov
     */
    public NanopubParser(String concept_root, List<String> concept_childs, List<JSONObject> info, List<JSONObject> prov) {
        this.concept_root = concept_root;
        this.concept_childs = concept_childs;
        this.info = info;
        this.prov=prov;
    }

    /**
     * Do the nanopublication generation/parsing
     *
     */
    public void parse() {

        for (String string : concept_childs) {
            System.err.println("\t[COEUS][NanopubParser] " + string);
        }
        Logger.getLogger(NanopubParser.class.getName()).log(Level.INFO, "[COEUS][NanopubParser] Start parsing: {0}", concept_root);

        Boot.start();

        String queryConcepts = "SELECT * {?item coeus:hasConcept " + concept_root + " FILTER NOT EXISTS {" + concept_root + " coeus:builtNp true }}";
        ResultSet rs = Boot.getAPI().selectRS(queryConcepts, false);
        if (!rs.hasNext() && Config.isDebug()) {
            Logger.getLogger(NanopubParser.class.getName()).log(Level.INFO, "[COEUS][NanopubParser] Already parsed the concept {0}", concept_root);
        }
        UrlValidator urlValidator = new UrlValidator();
        while (rs.hasNext()) {
            QuerySolution row = rs.next();

            String item = row.get("item").toString();
            //System.out.println(item);
            String queryItems = "SELECT * { <" + item + "> ?p ?o}";
            ResultSet rs_item = Boot.getAPI().selectRS(queryItems, false);

            //Build Assertion
            String np_item = item + "_Nanopub";
            Assertion a = new Assertion(np_item + "_Assertion");
            //Add Items to Assertion field
            while (rs_item.hasNext()) {
                QuerySolution row_item = rs_item.next();
                String p = row_item.get("p").toString();
                String o = row_item.get("o").toString();
                //System.out.println(item + " " + p + " " + o);

                if (urlValidator.isValid(o)) {
                    a.add(new Triple(Node.createURI(item), Node.createURI(p), Node.createURI(o)));
                } else {
                    a.add(new Triple(Node.createURI(item), Node.createURI(p), Node.createLiteral(o)));
                }
                if (p.endsWith("isAssociatedTo")) {
                    a = addAssociations(a, o);
                }
            }

            //Build Provenance
            Provenance p = new Provenance(np_item + "_Provenance");
            p.add(new Triple(Node.createURI(a.getUri()), Node.createURI("http://www.w3.org/ns/prov#wasDerivedFrom"), Node.createURI("http://bioinformatics.ua.pt/coeus/")));
            for (JSONObject json : prov) {
                String predicate = (String) json.get("predicate");
                String object = (String) json.get("object");
                if (urlValidator.isValid(object)) {
                    p.add(new Triple(Node.createURI(a.getUri()), Node.createURI(PrefixFactory.decode(predicate)), Node.createURI(object)));
                } else {
                    p.add(new Triple(Node.createURI(a.getUri()), Node.createURI(PrefixFactory.decode(predicate)), Node.createLiteral(object)));
                }
            }

            //Build PublicationInfo
            PublicationInfo i = new PublicationInfo(np_item + "_PubInfo");
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#generatedAtTime"), Node.createLiteral(new Date().toString(), null, XSDDatatype.XSDdateTime)));
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#wasAttributedTo"), Node.createLiteral(Config.getName())));
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#wasGeneratedBy"), Node.createURI(PrefixFactory.decode(concept_root))));
            for (JSONObject json : info) {
                String predicate = (String) json.get("predicate");
                String object = (String) json.get("object");
                if (urlValidator.isValid(object)) {
                    i.add(new Triple(Node.createURI(np_item), Node.createURI(PrefixFactory.decode(predicate)), Node.createURI(object)));
                } else {
                    i.add(new Triple(Node.createURI(np_item), Node.createURI(PrefixFactory.decode(predicate)), Node.createLiteral(object)));
                }
            }

            /**/
            Nanopublication np = new Nanopublication(np_item, a, p, i);
            //System.out.println(np.writeNQuads());
            Boot.getAPI().storeNanopub(np, concept_root);

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
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(PrefixFactory.decode(concept_root));
            Statement statementToRemove = api.getModel().createLiteralStatement(resource, Predicate.get("coeus:builtNp"), false);
            api.removeStatement(statementToRemove);
            api.addStatement(resource, Predicate.get("coeus:builtNp"), true);
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][NanopubParser] Unable to save property in concept " + concept_root);
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
        ResultSet rs_item_test = Boot.getAPI().selectRS(queryItems, false);
        Boolean load = false;

        //Test if the data concept is to load into the assertion
        while (rs_item_test.hasNext()) {
            QuerySolution row_item = rs_item_test.next();
            String p = row_item.get("p").toString();
            String o = row_item.get("o").toString();

            if ((p.endsWith("hasConcept")) && (concept_childs.contains(PrefixFactory.encode(o).split(":")[1]))) {
                load = true;
                Logger.getLogger(NanopubParser.class.getName()).log(Level.INFO, PrefixFactory.encode(o).split(":")[1]);
            }
        }

        while (rs_item.hasNext()) {
            QuerySolution row_item = rs_item.next();
            String p = row_item.get("p").toString();
            String o = row_item.get("o").toString();
            //Add all or add only the association
            if (load || p.endsWith("isAssociatedTo")) {
                UrlValidator urlValidator = new UrlValidator();
                if (urlValidator.isValid(o)) {
                    a.add(new Triple(Node.createURI(object), Node.createURI(p), Node.createURI(o)));
                } else {
                    a.add(new Triple(Node.createURI(object), Node.createURI(p), Node.createLiteral(o)));
                }
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
