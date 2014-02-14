package pt.ua.bioinformatics.coeus.actions;

import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Property;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.StmtIterator;
import java.io.StringWriter;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.api.plugins.Nanopublication;
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
        
        String output;
        Boot.start();
        Model aux=ModelFactory.createOntologyModel();
        aux.setNsPrefixes(Boot.getAPI().getModel().getNsPrefixMap());

        //Nanopub
        Resource np=Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix())+"nanopublication_"+id);
        StmtIterator iter=Boot.getAPI().getModel().listStatements(np, null, (RDFNode)null);
        aux.add(iter.toList());
        aux.setNsPrefix("np", "http://www.nanopub.org/nschema#");
        for (String prefix : aux.getNsPrefixMap().keySet()) {
            //aux.removeNsPrefix(prefix);
        }
        
        //Assertion
        Resource assertion=Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix())+"assertion_"+id);
        iter=Boot.getAPI().getModel().listStatements(assertion, null, (RDFNode)null);
        aux.add(iter.toList());
        
        //Provenance
        Resource prov=Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix())+"provenance_"+id);
        iter=Boot.getAPI().getModel().listStatements(prov, null, (RDFNode)null);
        aux.add(iter.toList());
        
        //PubInfo
        Resource info=Boot.getAPI().createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix())+"publicationInfo_"+id);
        iter=Boot.getAPI().getModel().listStatements(info, null, (RDFNode)null);
        aux.add(iter.toList());

        StringWriter out = new StringWriter();
        aux.write(out, "TURTLE");
        aux.close();
        

        
        output=out.toString();
        
        //nano = new Nanopublication(id);
        return new StreamingResolution("text/turtle",output);
    }
    
//    private String generate() {
//        String result = "";
//        nano.load();
//        result += "@prefix coeus: http://bioinformatics.ua.pt/coeus/ .\n@prefix nanoadr: http://bioinformatics.ua.pt/nanoadr/resource/ .\n@prefix np: http://www.nanopub.org/nschema# .\n@prefix owl2xml http://www.w3.org/2006/12/owl2-xml# .\n@prefix xsd: http://www.w3.org/2001/XMLSchema# .\n@prefix rdfs: http://www.w3.org/2000/01/rdf-schema# .\n@prefix owl: http://www.w3.org/2002/07/owl# .\n@prefix rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns# .\n@prefix dc: http://purl.org/dc/elements/1.1/ .\n";
//        result += "\n{\n";
//        result += "\t: a np:Nanopublication ;\n";
//        result += "\t\tnp:hasAssertion nanoadr:assertion_" + id + " ;\n";
//        result += "\t\tnp:hasProvenance nanoadr:provenance_" + id + " ;\n";
//        result += "\t\tnp:hasPublicationInfo nanoadr:pubinfo_" + id + " .\n";
//        result += "}\n\n";
//        result += "nanoadr:assertion_" + id + " {\n";
//        for(String s : nano.getAssertion().keySet()) {
//            result += "\t" + s + " " +  nano.getAssertion().get(s) + " ;\n";
//        }
//        
//        result = result.substring(0, result.length()-2) + ".\n}\n\n";
//        result += "nanoadr:provenance_" + id + " {\n";
//        for(String s : nano.getProvenance().keySet()) {
//            result += "\t" + s + " " +  nano.getProvenance().get(s) + " ;\n";
//        }
//        result = result.substring(0, result.length()-2) + ".\n}\n\n";
//        result += "nanoadr:pubinfo_" + id + " {\n";for(String s : nano.getPublication().keySet()) {
//            result += "\t" + s + " " +  nano.getPublication().get(s) + " ;\n";
//        }
//        result = result.substring(0, result.length()-2) + ".\n}";
//        
//        return result;
//    }
}
