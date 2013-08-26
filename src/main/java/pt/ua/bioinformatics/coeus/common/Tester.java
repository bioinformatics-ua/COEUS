/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.common;

import com.jayway.jsonpath.JsonPath;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import pt.ua.bioinformatics.coeus.api.DB;

/**
 * COEUS test runner class.
 *
 * @author sernadela
 */
public class Tester {

    // flag to test the REST server
    static boolean SERVER = true;
    // Server host
    static String HOST = "http://localhost:8080/";

    /**
     * COEUS test runner call.
     * <p>
     * Provides a test scenario in order to verify all functionalities.
     * </p>
     *
     * @param server if the server is running (test REST API)
     */
    public static void main(String[] args) {

        try {
            // clean sdb
            cleanSDB("localhost","3306","coeus", "demo", "demo");
            // Start import process            
            Boot.start();

        } catch (Exception ex) {
            Logger.getLogger(Tester.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        try {
            if (SERVER) {

                String location = HOST + Config.getKeyPrefix();
                String writeQuery = location + "/api/" + Config.getApikeys().get(0) + "/write/coeus:uniprot_P51587/coeus:isAssociatedTo/test";
                String readQuery = location + "/api/triple/coeus:uniprot_P51587/coeus:isAssociatedTo/obj";

                // Test REST Read access first to count the result objs
                int initSize = initRestRead(readQuery);
                // Test REST Write access to add a new obj
                restWrite(writeQuery);
                // Test REST Read again to verify if has new data
                verifyRestRead(readQuery, initSize);
            }
        } catch (Exception ex) {
            Logger.getLogger(Tester.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        try {
            // Test SPARQL Query 
            testSparqlQuery();
        } catch (Exception ex) {
            Logger.getLogger(Tester.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Clean the database data
     *
     * @param dbname
     * @param dbUserName
     * @param dbPassword
     */
    public static boolean cleanSDB(String host,String port, String dbname, String dbUserName, String dbPassword) {

        boolean result=false;
        DB db = new DB(dbname, "jdbc:mysql://"+host+":"+port+"/" + dbname + "?autoReconnect=true&user=" + dbUserName + "&password=" + dbPassword);
        // test db connection
        boolean success = db.connectX();

        if (success) {
            System.out.println("Cleaning sdb...");
            db.update("Truncate table Node", "TRUNCATE TABLE Nodes;");
            db.update("Truncate table Prefixes", "TRUNCATE TABLE Prefixes;");
            db.update("Truncate table Quads", "TRUNCATE TABLE Quads;");
            db.update("Truncate table Triples", "TRUNCATE TABLE Triples;");
            System.out.println("Sdb clean OK\n");
            result=true;
        } else {
            System.err.println("FAIL: Sdb not clean!!");
        }
        return result;
    }

    /**
     * REST Read call to count the result objs
     *
     * @param readQuery
     * @return
     */
    private static int initRestRead(String readQuery) {
        int initSize = 0;
        try {
            if (Config.isDebug()) {
                System.out.print("REST Read...");
            }
            URL url = new URL(readQuery);
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));
            List<Object> firstEntries = JsonPath.read(json, "$.results.bindings[*].obj.value");
            initSize = firstEntries.size();
            if (Config.isDebug()) {
                System.out.println("OK");
            }
        } catch (java.net.ConnectException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (IOException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (ParseException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (Exception ex) {
            Logger.getLogger(Tester.class.getName()).log(Level.SEVERE, null, ex);
        }
        return initSize;
    }

    /**
     * REST Write call to add a new obj to the sdb
     *
     * @param writeQuery
     */
    private static void restWrite(String writeQuery) {
        try {
            if (Config.isDebug()) {
                System.out.print("REST Write...");
            }
            URL url = new URL(writeQuery);
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));
            if (Config.isDebug()) {
                System.out.println(json.get("message"));
            }
        } catch (java.net.ConnectException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (IOException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (ParseException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (Exception ex) {
            Logger.getLogger(Tester.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * REST Read call to test if some obj has inserted.
     *
     * @param readQuery
     * @param initSize
     */
    private static void verifyRestRead(String readQuery, int initSize) {
        int finalSize = 0;
        try {
            if (Config.isDebug()) {
                System.out.print("Verifing results...");
            }
            URL url = new URL(readQuery);
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));
            List<Object> lastEntries = JsonPath.read(json, "$.results.bindings[*].obj.value");
            finalSize = lastEntries.size();

            if (initSize < finalSize) {
                if (Config.isDebug()) {
                    System.out.println("REST Read/Write OK");
                }
            } else {
                if (Config.isDebug()) {
                    System.out.println("OK but REST Write call do not added new data...");
                }
            }
        } catch (java.net.ConnectException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (IOException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (ParseException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (Exception ex) {
            Logger.getLogger(Tester.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    /**
     * Tests SPARQL Query with the count of the resources associated with the
     * Item "uniprot_P51587" in the sdb
     */
    private static void testSparqlQuery() {
        try {
            if (Config.isDebug()) {
                System.out.print("Test SPARQL Query...");
            }
            String query = "SELECT (count(distinct (?resource)) as ?total) {coeus:uniprot_P51587 coeus:isAssociatedTo ?associated . "
                    + "?associated coeus:hasConcept ?concept . ?concept coeus:hasResource ?resource}";
            String select = Boot.getAPI().select(query, "js", false);
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(select);
            Object value = JsonPath.read(json, "$.results.bindings[0].total.value");
            if (value.toString().equals("10")) {
                if (Config.isDebug()) {
                    System.out.println("OK");
                }
            } else {
                if (Config.isDebug()) {
                    System.out.println("Some goes wrong...");
                }
            }
        } catch (ParseException e) {
            if (Config.isDebug()) {
                System.out.println("FAIL: " + e.getLocalizedMessage());
            }
        } catch (Exception ex) {
            Logger.getLogger(Tester.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
