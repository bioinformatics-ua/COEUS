package pt.ua.bioinformatics.coeus.common;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;

/**
 * COEUS configuration loader.
 *
 * @author pedrolopes
 */
public class Config {

    private static boolean loaded = false;
    private static JSONObject file = null;
    private static String name = null;
    private static String description = null;
    private static String ontology = null;
    private static String setup = null;
    private static String sdb = null;
    private static String keyPrefix = null;
    private static String predicates = null;
    private static JSONArray data = new JSONArray();
    private static boolean debug = false;
    private static boolean built = false;
    private static String path = "";
    //private static String environment = "development";
    private static ArrayList<String> apikeys = new ArrayList<String>();

    public static ArrayList<String> getApikeys() {
        return apikeys;
    }

    public static void setApikeys(ArrayList<String> apikeys) {
        Config.apikeys = apikeys;
    }

//    public static String getEnvironment() {
//        return environment;
//    }
//
//    public static void setEnvironment(String environment) {
//        Config.environment = environment;
//    }

    public static String getPath() {
        return path;
    }

    public static void setPath(String path) {
        Config.path = path;
    }

    public static String getKeyPrefix() {
        return keyPrefix;
    }

    public static void setKeyPrefix(String keyPrefix) {
        Config.keyPrefix = keyPrefix;
    }

    public static String getSetup() {
        return setup;
    }

    public static void setSetup(String setup) {
        Config.setup = setup;
    }

    public static boolean isBuilt() {
        return built;
    }

    public static void setBuilt(boolean builder) {
        Config.built = builder;
    }

    public static JSONObject getFile() {
        return file;
    }

    public static String getPredicates() {
        return predicates;
    }

    public static void setPredicates(String predicates) {
        Config.predicates = predicates;
    }

    public static void setFile(JSONObject config) {
        Config.file = config;
    }

    public static String getDescription() {
        return description;
    }

    public static void setDescription(String description) {
        Config.description = description;
    }

    public static String getName() {
        return name;
    }

    public static void setName(String name) {
        Config.name = name;
    }

    public static boolean isLoaded() {
        return loaded;
    }

    public static void setLoaded(boolean loaded) {
        Config.loaded = loaded;
    }

    public static JSONArray getData() {
        return data;
    }

    public static void setData(JSONArray data) {
        Config.data = data;
    }

    public static String getOntology() {
        return ontology;
    }

    public static void setOntology(String ontology) {
        Config.ontology = ontology;
    }

    public static String getSdb() {
        return sdb;
    }

    public static void setSdb(String store) {
        Config.sdb = store;
    }

    public static boolean isDebug() {
        return debug;
    }

    public static void setDebug(boolean debug) {
        Config.debug = debug;
    }

    /**
     * Loads system settings from JavaScript configuration file.
     * <ul>
     * <li><stong>name</strong> seed name</li>
     * <li><stong>description</strong> seed description</li>
     * <li><stong>ontology</strong> seed ontology URI</li>
     * <li><stong>setup</strong> seed setup file named (located on source path
     * root)</li>
     * <li><stong>debug</strong> debug mode on/off</li>
     * <li><stong>built</strong> seed built/not built</li>
     * <li><stong>predicates</strong> seed predicate list (static for
     * performance reasons)</li>
     * <li><stong>environment</strong> seed environment mode (development,
     * testing, production; must match coeus_sdb_*.ttl filename)</li>
     * <li><stong>keyprefix</strong> seed ontology prefix</li>
     * <li><stong>prefixes</strong> SPARQL PREFIX list for data queries</li>
     * </ul>
     *
     * @return
     */
    public static boolean load() {
        if (!loaded) {
            try {
                path = Config.class.getResource("/").getPath();
                JSONParser parser = new JSONParser();
                file = (JSONObject) parser.parse(readFile());
                JSONObject config = (JSONObject) file.get("config");
                name = (String) config.get("name");
                description = (String) config.get("description");
                ontology = (String) config.get("ontology");
                setup = (String) config.get("setup");
                debug = (Boolean) config.get("debug");
                built = (Boolean) config.get("built");
                predicates = (String) config.get("predicates");
//                environment = (String) config.get("environment");
                apikeys.addAll(Arrays.asList(((String) config.get("apikey")).split("\\|")));
                sdb = ((String) config.get("sdb"));//.replace(".ttl", "_" + environment + ".ttl");
                keyPrefix = (String) config.get("keyprefix");
                JSONObject prefixes = (JSONObject) file.get("prefixes");
                for (Object o : prefixes.keySet()) {
                    String jo = (String) o;
                    PrefixFactory.add(jo, prefixes.get(jo).toString());
                }
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Config] Configuration loaded");
                }
                loaded = true;
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Config] Unable to load COEUS Configuration");
                    Logger.getLogger(Config.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        return loaded;
    }

    /**
     * Reads JSON configuration file to simple string.
     *
     * @return
     */
    private static String readFile() {
        byte[] buffer = new byte[(int) new File(path + "config.js").length()];
        try {
            BufferedInputStream f = null;
            try {
                f = new BufferedInputStream(new FileInputStream(path + "config.js"));
                f.read(buffer);
            } finally {
                if (f != null) {
                    try {
                        f.close();
                    } catch (IOException ignored) {
                    }
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(Config.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new String(buffer);
    }
}