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
import java.util.Date;
import org.apache.commons.validator.routines.UrlValidator;
import org.json.simple.parser.ParseException;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 *
 * @author Pedro Sernadela <sernadela at ua.pt>
 */
public class NanopubParser {

    public static void main(String[] args) throws ParseException {
        Boot.start();

        //INPUTS
        String concept = "coeus:concept_HGNC";

        String queryConcepts = "SELECT * {?item coeus:hasConcept " + concept + "}";
        ResultSet rs = Boot.getAPI().selectRS(queryConcepts, false);
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
            }

            Provenance p = new Provenance(np_item + "_Provenance");
            p.add(new Triple(Node.createURI(a.getUri()), Node.createURI("http://www.w3.org/ns/prov#wasDerivedFrom"), Node.createLiteral("COEUS")));

            PublicationInfo i = new PublicationInfo(np_item + "_PubInfo");
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#generatedAtTime"), Node.createLiteral(new Date().toString(), null, XSDDatatype.XSDdateTime)));
            i.add(new Triple(Node.createURI(np_item), Node.createURI("http://www.w3.org/ns/prov#wasAttributedTo"), Node.createLiteral(Config.getName())));

            /**/
            Nanopublication np = new Nanopublication(np_item, a, p, i);
            System.out.println(np.writeNQuads());
            Boot.getAPI().storeNanopub(np);
        }

    }
}
