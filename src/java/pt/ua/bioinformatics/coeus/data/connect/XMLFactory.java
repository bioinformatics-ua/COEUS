package pt.ua.bioinformatics.coeus.data.connect;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.ConceptFactory;
import pt.ua.bioinformatics.coeus.api.ItemFactory;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.data.Triplify;
import pt.ua.bioinformatics.coeus.domain.InheritedResource;
import pt.ua.bioinformatics.coeus.domain.Resource;

/**
 * Data factory for transforming XML data into RDF items using generic Triplify.
 *
 * @author pedrolopes
 */
public class XMLFactory implements ResourceFactory {

    private Resource res;
    private DocumentBuilderFactory domFactory;
    private URL u;
    private DocumentBuilder builder;
    private Document doc;
    private XPathFactory factory;
    private XPath xpath;
    private NodeList entries;
    private Triplify rdfizer;

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public XMLFactory(Resource r) {
        this.res = r;
    }

    /**
     * Reads XML data according to Resource information. <p>Workflow</b><ol>
     * <li>Check if resource is starter/extends</li> <li>Load XML resource into
     * URL and Document</li> <li>Start Triplify with factory Resource</li>
     * <li>Get data for Item key into Triplify</li> <li>Load data for each
     * InheritedResource property into Triplify hashmap based on XPath
     * queries</li> <li>Itemize single item</li> </ol></p>
     */
    public void read() {
        if (res.getMethod().equals("map")) {
            // TODO
        } else if (res.getMethod().equals("cache")) {
            try {
                if (res.getExtendsConcept().equals(res.getIsResourceOf().getUri())) {
                    domFactory = DocumentBuilderFactory.newInstance();
                    u = new URL(res.getEndpoint());
                    domFactory.setNamespaceAware(false);
                    builder = domFactory.newDocumentBuilder();
                    try {
                        doc = builder.parse(u.openStream());
                        factory = XPathFactory.newInstance();
                        xpath = factory.newXPath();
                        entries = (NodeList) xpath.evaluate(res.getQuery(), doc, XPathConstants.NODESET);
                        for (int i = 0; i < entries.getLength(); i++) {
                            Node n = entries.item(i);
                            InheritedResource key = (InheritedResource) res.getHasKey();
                            rdfizer = new Triplify(res);
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    XPath x_element = factory.newXPath();
                                    Node element = (Node) x_element.evaluate(c.getQuery(), n, XPathConstants.NODE);
                                    rdfizer.add(inside, element.getTextContent());
                                }
                            }
                            XPath x_key = factory.newXPath();
                            
                            Node xmlkey = (Node) x_key.evaluate(key.getQuery(), n, XPathConstants.NODE);
                            if (key.getRegex() == null) {
                                rdfizer.itemize(xmlkey.getTextContent());
                            } else {
                                Pattern p = Pattern.compile(key.getRegex());
                                Matcher m = p.matcher(xmlkey.getTextContent());
                                if (m.find()) {
                                    rdfizer.itemize(m.group());
                                }
                            }
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                } else {
                    // load extension data
                    HashMap<String, String> extensions;
                    if (res.getExtension().equals("")) {
                        extensions = res.getExtended();
                    } else {
                        extensions = res.getExtended(res.getExtension());
                    }
                    for (String item : extensions.keySet()) {
                        domFactory = DocumentBuilderFactory.newInstance();
                        u = new URL(res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(item)));
                        domFactory.setNamespaceAware(false);
                        builder = domFactory.newDocumentBuilder();
                        try {
                            doc = builder.parse(u.openStream());
                            factory = XPathFactory.newInstance();
                            xpath = factory.newXPath();
                            entries = (NodeList) xpath.evaluate(res.getQuery(), doc, XPathConstants.NODESET);
                            for (int i = 0; i < entries.getLength(); i++) {
                                Node n = entries.item(i);
                                InheritedResource key = (InheritedResource) res.getHasKey();
                                rdfizer = new Triplify(res, extensions.get(item));
                                for (Object o : res.getLoadsFrom()) {
                                    InheritedResource c = (InheritedResource) o;
                                    String[] tmp = c.getProperty().split("\\|");
                                    for (String inside : tmp) {
                                        XPath x_element = factory.newXPath();
                                        NodeList element = (NodeList) x_element.evaluate(c.getQuery(), n, XPathConstants.NODE);
                                        if (element != null) {
                                            if (element.getLength() > 1) {
                                                for (int k = 0; k < element.getLength(); k++) {
                                                    try {
                                                        rdfizer.add(inside, element.item(k).getTextContent());
                                                    } catch (Exception ex) {
                                                        if (Config.isDebug()) {
                                                            Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
                                                        }
                                                    }
                                                }
                                            } else {
                                                Node e = (Node) element;
                                                rdfizer.add(inside, e.getTextContent());
                                            }


                                        }
                                    }
                                }
                                XPath x_key = factory.newXPath();
                                Node xmlkey = (Node) x_key.evaluate(key.getQuery(), n, XPathConstants.NODE);
                                if (key.getRegex() == null) {
                                    rdfizer.itemize(xmlkey.getTextContent());
                                } else {
                                    Pattern p = Pattern.compile(key.getRegex());
                                    Matcher m = p.matcher(xmlkey.getTextContent());
                                    if (m.find()) {
                                        rdfizer.itemize(m.group());
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            if (Config.isDebug()) {
                                Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][XMLFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("complete")) {
            try {
                HashMap<String, String> extensions;
                if (res.getExtension().equals("")) {
                    extensions = res.getExtended();
                } else {
                    extensions = res.getExtended(res.getExtension());
                }
                for (String item : extensions.keySet()) {
                    domFactory = DocumentBuilderFactory.newInstance();
                    u = new URL(res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(item)));
                    domFactory.setNamespaceAware(false);
                    builder = domFactory.newDocumentBuilder();
                    try {
                        doc = builder.parse(u.openStream());
                        factory = XPathFactory.newInstance();
                        xpath = factory.newXPath();
                        entries = (NodeList) xpath.evaluate(res.getQuery(), doc, XPathConstants.NODESET);
                        for (int i = 0; i < entries.getLength(); i++) {
                            Node n = entries.item(i);
                            rdfizer = new Triplify(res, PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + ConceptFactory.getTokenFromConcept(res.getExtendsConcept()) + ItemFactory.getTokenFromItem(extensions.get(item)));
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    XPath x_element = factory.newXPath();
                                    NodeList element = (NodeList) x_element.evaluate(c.getQuery(), n, XPathConstants.NODE);
                                    if (element != null) {
                                        for (int k = 0; k < element.getLength(); k++) {
                                            try {
                                                rdfizer.add(inside, element.item(k).getTextContent());
                                            } catch (Exception ex) {
                                                if (Config.isDebug()) {
                                                    Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            rdfizer.complete();
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][XMLFactory] unable to complete data for " + res.getUri());
                    Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    /**
     * Updates the resource coeus:built property once the resource finished
     * building.
     *
     * @return success of the operation
     */
    public boolean save() {
        boolean success = false;
        try {
            API api = Boot.getAPI();
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
            api.addStatement(resource, Predicate.get("coeus:built"), true);
            success = true;
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Saved resource " + res.getUri());
            }
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][API] Unable to save resource " + res.getUri());
                Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
}
