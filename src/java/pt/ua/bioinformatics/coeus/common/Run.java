package pt.ua.bioinformatics.coeus.common;

import com.jayway.jsonpath.JsonPath;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 *
 * @author pedrolopes
 */
public class Run {

    /**
     * COEUS importer runner class.
     * <p>
     * Organized in import levels for dependency handling. (This needs
     * refactoring!)
     * </p>
     *
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            // Start build process            
            Boot.start();
            // Test tester example
            testRun(false);

            // Import single resource (threaded) example
            //SingleImport single = new SingleImport("resource_json");
            // Thread t = new Thread(single);
            // t.start();
        } catch (Exception ex) {
            Logger.getLogger(Run.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * COEUS test runner method.
     * <p>
     * This method provides and test case to the test ontology in order to
     * verify all functionalities.
     * </p>
     *
     * @param server if the server is running (test REST API)
     */
    public static void testRun(boolean server) throws MalformedURLException, IOException, ParseException {

        if (Config.isDebug()) System.out.println("Testing - " + Config.getName());
        if (server) {

            String location = "http://localhost:8080/"+Config.getKeyPrefix();
            String writeQuery = location+"/api/" + Config.getApikeys().get(0) + "/write/coeus:uniprot_P51587/coeus:isAssociatedTo,test";
            String readQuery = location+"/api/triple/coeus:uniprot_P51587/coeus:isAssociatedTo/obj";

            //Test REST Read access first to count the result objs
            if (Config.isDebug()) System.out.print("Test REST Read...");
            URL url = new URL(readQuery);
            JSONParser parser = new JSONParser();
            JSONObject json = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));
            List<Object> firstEntries = JsonPath.read(json, "$.results.bindings[*].obj.value");
            if (Config.isDebug()) System.out.println("OK");
            //Test REST Write access to add a new obj    
            if (Config.isDebug()) System.out.print("Test REST Write...");
            url = new URL(writeQuery);
            json = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));
            if (Config.isDebug()) System.out.println(json.get("message"));
            //Test REST Read again to verify the diference
            if (Config.isDebug()) System.out.print("Verifing...");
            url = new URL(readQuery);
            json = (JSONObject) parser.parse(new InputStreamReader(url.openStream()));
            List<Object> lastEntries = JsonPath.read(json, "$.results.bindings[*].obj.value");

            if (firstEntries.size() < lastEntries.size()) {
                if (Config.isDebug()) System.out.println("REST Read/Write OK");
            } else {
                if (Config.isDebug()) System.out.println("OK but REST Write data already exist (try clean sdb)...");
            }

        }
        
        //Test SPARQL Query with the count of the resources associated with the item uniprot_P51587 in the sdb
        if (Config.isDebug()) System.out.print("Test SPARQL Query...");
        String query="SELECT (count(distinct (?resource)) as ?total) {coeus:uniprot_P51587 coeus:isAssociatedTo ?associated . "
                + "?associated coeus:hasConcept ?concept . ?concept coeus:hasResource ?resource}";
        String select = Boot.getAPI().select(query, "js", false);
        JSONParser parser = new JSONParser();
        JSONObject json = (JSONObject) parser.parse(select);
        Object value = JsonPath.read(json, "$.results.bindings[0].total.value");
        if (value.toString().equals("9")) {
            if (Config.isDebug()) System.out.println("OK");
        } else {
            if (Config.isDebug()) System.err.println("Some goes wrong...");
        }


    }
}
