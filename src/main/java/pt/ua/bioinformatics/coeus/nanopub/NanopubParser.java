/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.nanopub;

import com.hp.hpl.jena.graph.Node;
import com.hp.hpl.jena.graph.Triple;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import org.json.simple.parser.ParseException;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;

/**
 *
 * @author Pedro Sernadela <sernadela at ua.pt>
 */
public class NanopubParser {

    public static void main(String[] args) throws ParseException {
        Boot.start();

        String queryConcepts = "SELECT * {?item coeus:hasConcept coeus:concept_HGNC}";
        ResultSet rs = Boot.getAPI().selectRS(queryConcepts, false);
        while (rs.hasNext()) {
            QuerySolution row = rs.next();

            String item = row.get("item").toString();
            //System.out.println(item);
            String queryItems = "SELECT * { <" + item + "> ?p ?o}";
            ResultSet rs_item = Boot.getAPI().selectRS(queryItems, false);
            Assertion a = new Assertion(item + "_Nanopub_Assertion");
            while (rs_item.hasNext()) {
                QuerySolution row_item = rs_item.next();
                String p = row_item.get("p").toString();
                String o = row_item.get("o").toString();
                //System.out.println(item + " " + p + " " + o);
                if (o.startsWith("http")) {
                    a.add(new Triple(Node.createURI(item), Node.createURI(p), Node.createURI(o)));
                } else {
                    a.add(new Triple(Node.createURI(item), Node.createURI(p), Node.createLiteral(o)));
                }
            }

            Provenance p = new Provenance(item + "_provenance");
            PublicationInfo i = new PublicationInfo(item + "_info");

            /**/
            Nanopublication np = new Nanopublication(item, a, p, i);
            System.out.println(np.writeNQuads());
        }

        //String r=Boot.getAPI().select(queryItems, "json", false);
        //System.out.println(r);
    }
}
