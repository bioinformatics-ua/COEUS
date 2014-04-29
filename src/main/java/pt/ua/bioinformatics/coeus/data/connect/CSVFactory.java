package pt.ua.bioinformatics.coeus.data.connect;

import au.com.bytecode.opencsv.CSVReader;
import com.hp.hpl.jena.rdf.model.Statement;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
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
    private boolean hasError = false;

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
     * <li>Check if resource is starter/extends</li>
     * <li>Load CSV resource into URL and to CSVReader</li>
     * <li>Start Triplify with factory Resource</li>
     * <li>Get data for Item key into Triplify</li>
     * <li>Load data for each InheritedResource property into Triplify hashmap
     * based on CSV columns</li>
     * <li>Itemize single item</li>
     * </ol></p>
     */
    public void read() {
        char defaultCsvQuotes = '"';
        int defaultCsvHeader = 1;
        if (res.getMethod().equals("complete")) {
            try {
                HashMap<String, String> extensions;
                if (res.getExtension().equals("")) {
                    extensions = res.getExtended();
                } else {
                    extensions = res.getExtended(res.getExtension());
                }
                for (String l : extensions.keySet()) {
                    u = new URL(res.getEndpoint().replace("#replace#", URLEncoder.encode(ItemFactory.getTokenFromItem(l), "UTF-8")));
                    in = new BufferedReader(new InputStreamReader(u.openStream()));
                    //try to guess the delimiter 
                    //if the resource query has no value apply defaults
                    if (res.getQuery() == null || res.getQuery().equals("")) {
                        char csvDelimiter = guessDelimiter(u, defaultCsvQuotes, defaultCsvHeader);
                        reader = new CSVReader(in, csvDelimiter, defaultCsvQuotes, defaultCsvHeader);
                    } else {
                        String[] csvKeys = res.getQuery().split("\\|");
                        char queryQuotes = csvKeys[1].charAt(0);
                        char queryLinesSkip = csvKeys[0].charAt(0);
                        char querySeparator = guessDelimiter(u, queryQuotes, Integer.parseInt(queryLinesSkip+""));

                        System.out.println(res.getQuery() + " - " +querySeparator+ queryQuotes + queryLinesSkip);
                        reader = new CSVReader(in, querySeparator, queryQuotes, Integer.parseInt(queryLinesSkip+""));
                    }
                    list = reader.readAll();
                    try {
                        //System.out.println("size: "+list.size());
                        for (String[] s : list) {
                            //Displays the content
                        //    System.out.println("");
                        //    for (String string : s) {
                        //        System.out.print(string+" - ");
                        //    }
                            rdfizer = new Triplify(res, PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + ConceptFactory.getTokenFromConcept(res.getExtendsConcept()) + ItemFactory.getTokenFromItem(extensions.get(l)));
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    int col = Integer.parseInt(c.getQuery());
                                    rdfizer.add(inside, s[col]);
                                }
                            }
                            rdfizer.complete();
                        }
                    } catch (Exception ex) {
                        if (Config.isDebug()) { saveError(ex);
                            Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][CSVFactory] unable to " + res.getMethod() + " data for " + res.getUri());
                    Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("map")) {
            try {
                // load extension data
                HashMap<String, String> extensions = res.getExtended();

                for (String item : extensions.keySet()) {
                    u = new URL(res.getEndpoint());
                    in = new BufferedReader(new InputStreamReader(u.openStream()));
                    //try to guess the delimiter 
                    //if the resource query has no value apply defaults
                    if (res.getQuery() == null || res.getQuery().equals("")) {
                        char csvDelimiter = guessDelimiter(u, defaultCsvQuotes, defaultCsvHeader);
                        reader = new CSVReader(in, csvDelimiter, defaultCsvQuotes, defaultCsvHeader);
                    } else {
                        String[] csvKeys = res.getQuery().split("\\|");
                        char queryQuotes = csvKeys[1].charAt(0);
                        char queryLinesSkip = csvKeys[0].charAt(0);
                        char querySeparator = guessDelimiter(u, queryQuotes, Integer.parseInt(queryLinesSkip+""));

                        //System.out.println(res.getQuery() + " - " +querySeparator+ queryQuotes + queryLinesSkip);
                        reader = new CSVReader(in, querySeparator, queryQuotes, Integer.parseInt(queryLinesSkip+""));
                    }
                    list = reader.readAll();
                    try {
                        rdfizer = new Triplify(res, extensions.get(item));
                        InheritedResource key = (InheritedResource) res.getHasKey();
                        for (String[] entry : list) {
                            int column = Integer.parseInt(key.getQuery());
                            rdfizer.getMap().add(entry[column]);
                        }
                        rdfizer.map();
                    } catch (Exception ex) {
                        if (Config.isDebug()) { saveError(ex);
                            Logger.getLogger(SQLFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][CSVFactory] unable to load data for " + res.getUri());
                    Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else if (res.getMethod().equals("cache")) {
            try {
                if (res.getExtendsConcept().equals(res.getIsResourceOf().getUri())) {
                    u = new URL(res.getEndpoint());
                    in = new BufferedReader(new InputStreamReader(u.openStream()));
                    //try to guess the delimiter 
                    //if the resource query has no value apply defaults
                    if (res.getQuery() == null || res.getQuery().equals("")) {
                        char csvDelimiter = guessDelimiter(u, defaultCsvQuotes, defaultCsvHeader);
                        reader = new CSVReader(in, csvDelimiter, defaultCsvQuotes, defaultCsvHeader);
                    } else {
                        String[] csvKeys = res.getQuery().split("\\|");
                        char queryQuotes = csvKeys[1].charAt(0);
                        char queryLinesSkip = csvKeys[0].charAt(0);
                        char querySeparator = guessDelimiter(u, queryQuotes, Integer.parseInt(queryLinesSkip+""));

                        System.out.println(res.getQuery() + " - " +querySeparator+ queryQuotes + queryLinesSkip);
                        reader = new CSVReader(in, querySeparator, queryQuotes, Integer.parseInt(queryLinesSkip+""));
                    }
                    list = reader.readAll();
                    try {
                        System.out.println("size: "+list.size());
                        for (String[] s : list) {
                            //Displays the content
                            //System.out.println("");
                            //for (String string : s) {
                            //    System.out.print(string+" - ");
                            //}
                            
                            InheritedResource key = (InheritedResource) res.getHasKey();
                            rdfizer = new Triplify(res);
                            for (Object o : res.getLoadsFrom()) {
                                InheritedResource c = (InheritedResource) o;
                                String[] tmp = c.getProperty().split("\\|");
                                for (String inside : tmp) {
                                    int col = Integer.parseInt(c.getQuery());
                                    rdfizer.add(inside, s[col]);
                                }
                            }
                            int column = Integer.parseInt(key.getQuery());
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
                        if (Config.isDebug()) { saveError(ex);
                            Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                } else {
                    // load extension data from resource Extension
                    HashMap<String, String> extensions;
                    if (res.getExtension().equals("")) {
                        extensions = res.getExtended();
                    } else {
                        extensions = res.getExtended(res.getExtension());
                    }
                    for (String item : extensions.keySet()) {
                        u = new URL(res.getEndpoint().replace("#replace#", URLEncoder.encode(ItemFactory.getTokenFromItem(item), "UTF-8")));
                        in = new BufferedReader(new InputStreamReader(u.openStream()));

                        //try to guess the delimiter 
                        //if the resource query has no value apply defaults
                        if (res.getQuery() == null || res.getQuery().equals("")) {
                            char csvDelimiter = guessDelimiter(u, defaultCsvQuotes, defaultCsvHeader);
                            reader = new CSVReader(in, csvDelimiter, defaultCsvQuotes, defaultCsvHeader);
                        } else {
                            String[] csvKeys = res.getQuery().split("\\|");
                            char queryQuotes = csvKeys[1].charAt(0);
                            char queryLinesSkip = csvKeys[0].charAt(0);
                            char querySeparator = guessDelimiter(u, queryQuotes, Integer.parseInt(queryLinesSkip+""));

                            //System.out.println(res.getQuery() + " - " + querySeparator + queryQuotes + queryLinesSkip);
                            reader = new CSVReader(in, querySeparator, queryQuotes, Integer.parseInt(queryLinesSkip+""));
                        }

                        list = reader.readAll();
                        try {
                            //System.out.println("size: "+list.size());
                            for (String[] s : list) {
                            //Displays the content
                            //System.out.println("");
                            //for (String string : s) {
                            //    System.out.print(string+" ");
                            //}
                                InheritedResource key = (InheritedResource) res.getHasKey();
                                rdfizer = new Triplify(res, extensions.get(item));
                                for (Object o : res.getLoadsFrom()) {
                                    InheritedResource c = (InheritedResource) o;
                                    String[] tmp = c.getProperty().split("\\|");
                                    for (String inside : tmp) {
                                        int col = Integer.parseInt(c.getQuery());
                                        rdfizer.add(inside, s[col]);
                                    }
                                }
                                int column = Integer.parseInt(key.getQuery());
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
                            if (Config.isDebug()) { saveError(ex);
                                Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                if (Config.isDebug()) { saveError(ex);
                    System.out.println("[COEUS][CSVFactory] unable to " + res.getMethod() + " data for " + res.getUri());
                    Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
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
            //only change built property if there are no errors
            if (hasError == false) {
                API api = Boot.getAPI();
                com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
                Statement statementToRemove = api.getModel().createLiteralStatement(resource, Predicate.get("coeus:built"), false);
                api.removeStatement(statementToRemove);
                api.addStatement(resource, Predicate.get("coeus:built"), true);
            }
            success = true;
            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Saved resource " + res.getUri());
            }
        } catch (Exception ex) {
            if (Config.isDebug()) { saveError(ex);
                System.out.println("[COEUS][API] Unable to save resource " + res.getUri());
                Logger.getLogger(CSVFactory.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }
    
    private void saveError(Exception ex) {
        try {
            API api = Boot.getAPI();
            com.hp.hpl.jena.rdf.model.Resource resource = api.getResource(this.res.getUri());
            Statement statement=api.getModel().createLiteralStatement(resource, Predicate.get("dc:coverage"), "ERROR: "+ex.getMessage()+". For more information, please see the application server log.");
            api.addStatement(statement);
            hasError = true;

            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Saved error on resource " + res.getUri());
            }
        } catch (Exception e) {
            if (Config.isDebug()) { 
                System.out.println("[COEUS][API] Unable to save error on resource " + res.getUri());
                Logger.getLogger(XMLFactory.class.getName()).log(Level.SEVERE, null, e);
            }
        }
    }

    /**
     * Try to guess the csv delimiter. If fail returns the default ',' otherwise
     * return the delimiter.
     *
     * @param urlLocation
     * @param quotes
     * @param headerSkip
     * @return
     */
    public char guessDelimiter(URL urlLocation, char quotes, int headerSkip) {
        char failReturn = ',';
        //popular delimiters by order 
        char[] delimiters = {'\t', ';', ' ', '.'};
        List<Integer> columsSizeDetected = new ArrayList<Integer>();
        int minColums = 1;
        int linesToCheck = 4;

        for (int a = 0; a < delimiters.length; a++) {
            boolean b = true;
            try {

                BufferedReader br = new BufferedReader(new InputStreamReader(urlLocation.openStream()));
                CSVReader testReader = new CSVReader(br, delimiters[a], quotes, headerSkip);
                columsSizeDetected.clear();
                //System.err.println("    TEST: " +delimiters[a]);

                for (int i = 0; i < linesToCheck; i++) {
                    String[] rows = testReader.readNext();
                    columsSizeDetected.add(rows.length);
                    //System.err.println(delimiters[a] + " -rows: " + rows.length);
                }

                // test the colums size in each line
                for (int i = 0; i < linesToCheck - 1; i++) {
                    if (columsSizeDetected.get(i) <= minColums) {
                        b = false;
                    }
                    if (!columsSizeDetected.get(i).equals(columsSizeDetected.get(i + 1))) {
                        b = false;
                    }
                }

            } catch (Exception e) {
                b = false;
            }

            if (b) {
                //System.err.println("Finded:" + delimiters[a]);
                return delimiters[a];
            }
        }

        return failReturn;
    }
}
