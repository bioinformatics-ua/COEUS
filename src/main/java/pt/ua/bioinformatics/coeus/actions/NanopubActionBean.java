package pt.ua.bioinformatics.coeus.actions;

import com.hp.hpl.jena.graph.Node;
import com.hp.hpl.jena.sparql.core.DatasetGraph;
import com.hp.hpl.jena.sparql.core.DatasetGraphFactory;
import com.hp.hpl.jena.sparql.core.Quad;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.util.Iterator;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import org.openjena.riot.RiotWriter;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 *
 * @author pedrolopes
 */
@UrlBinding("/nanopub/{id}")
public class NanopubActionBean implements ActionBean {

    private ActionBeanContext context;
    private String id;
    // private Nanopublication nano;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setContext(ActionBeanContext context) {
        this.context = context;
    }

    public ActionBeanContext getContext() {
        return context;
    }

    @DefaultHandler
    public Resolution handle() {

        Boot.start();
        DatasetGraph dg = Boot.getAPI().getDatasetGraph();
        DatasetGraph outGraph = DatasetGraphFactory.createMem();
        String npURI = PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + id ;
        String assURI = PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + id +"_Assertion" ;
        String provURI = PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) +id+ "_Provenance" ;
        String infoURI = PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) +id+ "_PubInfo" ;
        //Nanopub
        Iterator<Quad> itNp = dg.find(Node.createURI(npURI), Node.ANY, Node.ANY, Node.ANY);
        while (itNp.hasNext()) {
            Quad q = itNp.next();
            Quad quadToAdd = new Quad(Node.createURI(npURI), q.getSubject(), q.getPredicate(), q.getObject());
            outGraph.add(quadToAdd);
        }
        //Assertion 
        Iterator<Quad> itAss = dg.find( Node.createURI(assURI),Node.ANY, Node.ANY, Node.ANY);
        while (itAss.hasNext()) {
            Quad q = itAss.next();
            Quad quadToAdd = new Quad(Node.createURI(assURI), q.getSubject(), q.getPredicate(), q.getObject());
            outGraph.add(quadToAdd);
        }
        //Provenance
        Iterator<Quad> itProv = dg.find(Node.createURI(provURI),Node.ANY,  Node.ANY, Node.ANY);
        while (itProv.hasNext()) {
            Quad q = itProv.next();
            Quad quadToAdd = new Quad(Node.createURI(provURI), q.getSubject(), q.getPredicate(), q.getObject());
            outGraph.add(quadToAdd);
        }
        //PublicationInfo
        Iterator<Quad> itInfo = dg.find( Node.createURI(infoURI),Node.ANY, Node.ANY, Node.ANY);
        while (itInfo.hasNext()) {
            Quad q = itInfo.next();
            Quad quadToAdd = new Quad(Node.createURI(infoURI), q.getSubject(), q.getPredicate(), q.getObject());
            outGraph.add(quadToAdd);
        }

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(baos);
        RiotWriter.writeNQuads(ps, outGraph);
        String content = baos.toString();
        outGraph.close();

       
        
        //Boot.getAPI().storeNanopub(np);
        
        //Model mo = ModelFactory.createModelForGraph(ds.getGraph(Node.createURI("a1"))) ;
        //RDFDataMgr.write(System.out, Boot.getAPI().getDatasetGraph(), RDFFormat.TRIG);
        return new StreamingResolution("text/n-quads", content);
    }

    /*
         Model aux = ModelFactory.createOntologyModel();
         aux.setNsPrefixes(Boot.getAPI().getModel().getNsPrefixMap());
         //Nanopub
         Resource np = Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "nanopublication_" + id);
         StmtIterator iter = Boot.getAPI().getModel().listStatements(np, null, (RDFNode) null);
         aux.add(iter.toList());
         aux.setNsPrefix("np", "http://www.nanopub.org/nschema#");
         //Assertion
         Resource assertion = Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "assertion_" + id);
         iter = Boot.getAPI().getModel().listStatements(assertion, null, (RDFNode) null);
         aux.add(iter.toList());
         //Provenance
         Resource prov = Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "provenance_" + id);
         iter = Boot.getAPI().getModel().listStatements(prov, null, (RDFNode) null);
         aux.add(iter.toList());
         //PubInfo
         Resource info = Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "publicationInfo_" + id);
         iter = Boot.getAPI().getModel().listStatements(info, null, (RDFNode) null);
         aux.add(iter.toList());
        
         StringWriter out = new StringWriter();
         aux.write(out, "TURTLE");
         aux.close();
         */
}
