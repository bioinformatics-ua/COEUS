package pt.ua.bioinformatics.coeus.data.connect;

import au.com.bytecode.opencsv.CSVReader;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
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
 * Data factory for transforming CSV data into RDF items using generic Triplify.
 *
 * @author pedrolopes
 */
public class CSVFactory implements ResourceFactory {

    private Resource res;
    private static CSVReader reader;
    private Triplify rdfizer = null;
    private URL u;
    private BufferedReader in;
    private List<String[]> list;

    public static CSVReader getReader() {
        return reader;
    }

    public static void setReader(CSVReader reader) {
        CSVFactory.reader = reader;
    }

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public CSVFactory(Resource r) {
        this.res = r;
    }

    /**
     * Reads CSV data according to Resource information.
     * <p>Workflow</b><ol>
     *  <li>Check if resource is starter/extends</li>
     *  <li>Load CSV resource into URL and to CSVReader</li>
     *  <li>Start Triplify with factory Resource</li>
     *  <li>Get data for Item key into Triplify</li>
     *  <li>Load data for each InheritedResource property into Triplify hashmap based on CSV columns</li>
     *  <li>Itemize single item</li>
     * </ol></p>
     */
    public void read() {
        if (res.getMethod().equals("complete")) {
            try {
                ArrayList<String> extensions;
                if (res.getExtension().equals("")) {
                    extensions = res.getExtended();
                } else {
                    extensions = res.getExtended(res.getExtension());
                }
                for (String l : extensions) {
                    u = new URL(res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(l)));
                    in = new BufferedReader(new InputStreamReader(u.openStream()));
                    reader = new CSVReader(in, '\t', '"', 1);
                    list = reader.readAll();
                    try {
                        for (String[] s : list) {
                            rdfizer = new Triplify(res, PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + ConceptFactory.getTokenFromConcept(res.getExtendsConcept()) + ItemFactory.getTokenFromItem(l));
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    int col = Integer.parseInt(Character.toString(c.getQuery().charAt(0)));
                                    rdfizer.add(inside, s[col]);
                                }
                            }
                            rdfizer.complete();
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][CSVFactory] unable to " + res.getMethod() + " data for " + res.getUri());
                    Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("map")) {
            try {
                // load extension data
                ArrayList<String> extensions = res.getExtended();

                for (String item : extensions) {
                    u = new URL(res.getEndpoint());
                    in = new BufferedReader(new InputStreamReader(u.openStream()));
                    reader = new CSVReader(in, '\t', '"', 1);
                    list = reader.readAll();
                    try {
                        rdfizer = new Triplify(res, item);
                        InheritedResource key = (InheritedResource) res.getHasKey();
                        for (String[] entry : list) {
                            int column = Integer.parseInt(Character.toString(key.getQuery().charAt(0)));
                            rdfizer.getMap().add(entry[column]);
                        }
                        rdfizer.map();
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][SQLFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("cache")) {
            try {
                if (res.getExtendsConcept().equals(res.getIsResourceOf().getUri())) {
                    u = new URL(res.getEndpoint());
                    in = new BufferedReader(new InputStreamReader(u.openStream()));
                    reader = new CSVReader(in, '\t', '"', 1);
                    list = reader.readAll();
                    try {
                        for (String[] s : list) {
                            InheritedResource key = (InheritedResource) res.getHasKey();
                            rdfizer = new Triplify(res);
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    int col = Integer.parseInt(Character.toString(c.getQuery().charAt(0)));
                                    rdfizer.add(inside, s[col]);
                                }
                            }
                            int column = Integer.parseInt(Character.toString(key.getQuery().charAt(0)));
                            if (key.getRegex() == null) {
                                rdfizer.itemize(s[column]);
                            } else {
                                Pattern p = Pattern.compile(key.getRegex());
                                Matcher m = p.matcher(s[column]);
                                if (m.find()) {
                                    rdfizer.itemize(m.group());
                                }
                            }
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                } else {
                    // load extension data from resource Extension
                    ArrayList<String> extensions;
                    if (res.getExtension().equals("")) {
                        extensions = res.getExtended();
                    } else {
                        extensions = res.getExtended(res.getExtension());
                    }
                    for (String l : extensions) {
                        u = new URL(res.getEndpoint().replace("#replace#", ItemFactory.getTokenFromItem(l)));
                        in = new BufferedReader(new InputStreamReader(u.openStream()));
                        reader = new CSVReader(in, '\t', '"', 1);
                        list = reader.readAll();
                        try {
                            for (String[] s : list) {
                                InheritedResource key = (InheritedResource) res.getHasKey();
                                rdfizer = new Triplify(res, l);
                                for (Object o : res.getLoadsFrom()) {
                                    InheritedResource c = (InheritedResource) o;
                                    String[] tmp = c.getProperty().split("\\|");
                                    for (String inside : tmp) {
                                        int col = Integer.parseInt(Character.toString(c.getQuery().charAt(0)));
                                        rdfizer.add(inside, s[col]);
                                    }
                                }
                                int column = Integer.parseInt(Character.toString(key.getQuery().charAt(0)));
                                if (key.getRegex() == null) {
                                    rdfizer.itemize(s[column]);
                                } else {
                                    Pattern p = Pattern.compile(key.getRegex());
                                    Matcher m = p.matcher(s[column]);
                                    if (m.find()) {
                                        rdfizer.itemize(m.group());
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            if (Config.isDebug()) {
                                Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][CSVFactory] unable to " + res.getMethod() + " data for " + res.getUri());
                    Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    /**
     * Updates the resource coeus:built property once the resource finished building.
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
                Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
}
