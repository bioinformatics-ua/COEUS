/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.actions;

import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.ontology.OntProperty;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Property;
import com.hp.hpl.jena.util.iterator.ExtendedIterator;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeSet;
import java.util.concurrent.ExecutorService;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import pt.ua.bioinformatics.coeus.api.DB;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.common.Worker;
import pt.ua.bioinformatics.coeus.data.Predicate;

/**
 *
 * @author sernadela
 */
@UrlBinding("/config/{$model}/{method}")
public class ConfigActionBean implements ActionBean {

    private static final String NOTFOUND_VIEW = "/setup/404.jsp";
    private String method;
    private String model;
    private ActionBeanContext context;

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    @Override
    public void setContext(ActionBeanContext actionBeanContext) {
        this.context = actionBeanContext;
    }

    @Override
    public ActionBeanContext getContext() {
        return context;
    }

    @DefaultHandler
    public Resolution handle() {
        return new ForwardResolution(NOTFOUND_VIEW);
    }

    /**
     * return the config.js file
     *
     * @return
     */
    public Resolution getconfig() {
        Boot.start();
        return new StreamingResolution("application/json", Config.getFile().toJSONString());
    }

    /**
     * return existent properties that matches with $method
     *
     * @return
     */
    public Resolution properties() {
        JSONArray array = new JSONArray();
        String matchingStr = method;
        //HashMap<String,String> map= PrefixFactory.getPrefixes();
        HashMap<String, Property> map = Predicate.getPredicates();

        for (Entry<String, Property> e : map.entrySet()) {
            String key = e.getKey();
            if (matchingStr != null) {
                if (key.contains(matchingStr)) {
                    array.add(key);
                }
            } else {
                array.add(key);
            }
        }
        //System.out.println(matchingStr);
        //System.out.println(array.toJSONString());
        return new StreamingResolution("application/json", array.toJSONString());
    }

    /**
     * Export the database content
     *
     * @return
     * @throws FileNotFoundException
     */
    public Resolution export() throws FileNotFoundException {
        StringWriter outs = new StringWriter();
        Boot.start();
        if (method.endsWith(".ttl")) {
            Boot.getAPI().getModel().write(outs, "TURTLE");
        } else {
            Boot.getAPI().getModel().write(outs, "RDF/XML");
        }
        return new StreamingResolution("application/rdf+xml", outs.toString());
    }

    /**
     * Build (Boot.build() call in a different thread)
     *
     * @return
     */
    public Resolution build() {
        JSONObject result = new JSONObject();
        String value = method;
        try {

            ExecutorService executor = (ExecutorService) context.getServletContext().getAttribute("INTEGRATION_EXECUTOR");
            Runnable worker = new Worker("worker" + System.currentTimeMillis());
            executor.execute(worker);

            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] Build done.");
        } catch (Exception e) {
            result.put("status", 201);
            result.put("message", "[COEUS][API][ConfigActionBean] Build fail. Exception: " + e);
        }
        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * Change built property in config.js file. The method value only can be
     * true or false.
     *
     * @return
     */
    public Resolution changebuilt() {
        JSONObject result = new JSONObject();
        try {
            JSONObject f = Config.getFile();
            JSONObject config = (JSONObject) f.get("config");

            config.put("built", Boolean.parseBoolean(method));
            f.put("config", config);

            updateFile(f.toJSONString(), Config.getPath() + "config.js");
            //apply values
            Boot.resetConfig();

            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] Built property changed.");
        } catch (Exception e) {
            result.put("status", 201);
            result.put("message", "[COEUS][API][ConfigActionBean] Built not property changed. Exception: " + e);
        }
        return new StreamingResolution("application/json", result.toJSONString());
    }

//    public Resolution executor(){
//        JSONObject result = new JSONObject();
//        ExecutorService executor = (ExecutorService )context.getServletContext().getAttribute("INTEGRATION_EXECUTOR");
//
//        result.put("executor.isShutdown()", executor.isShutdown());
//        result.put("executor.isTerminated()", executor.isTerminated());
//        return new StreamingResolution("application/json", result.toJSONString());
//    }
    /**
     * Cleans the DB of one environment (method)
     *
     * @return
     */
    public Resolution cleandb() {
        JSONObject result = new JSONObject();
        try {
            //get map.js file
            String environment = "env_" + method;
            String path = Config.getPath() + environment + "/";
            String map = path + "map.js";
            JSONParser parser = new JSONParser();
            String json = readToString(map);
            result = (JSONObject) parser.parse(json);
            int index = result.get("$sdb:jdbcURL").toString().lastIndexOf("/");
            String dbName = result.get("$sdb:jdbcURL").toString().substring(index);
            DB db = new DB(dbName, result.get("$sdb:jdbcURL") + "&user=" + result.get("$sdb:sdbUser").toString() + "&password=" + result.get("$sdb:sdbPassword").toString());
            // test db connection
            boolean success = db.connectX();

            if (success) {
                db.update("Truncate table Node", "TRUNCATE TABLE Nodes;");
                db.update("Truncate table Prefixes", "TRUNCATE TABLE Prefixes;");
                db.update("Truncate table Quads", "TRUNCATE TABLE Quads;");
                db.update("Truncate table Triples", "TRUNCATE TABLE Triples;");
                System.out.println("[COEUS][API][ConfigActionBean] Sdb clean OK\n");
                result.put("status", 100);
                result.put("message", "[COEUS][API][ConfigActionBean] DB Cleaned in environment:  " + method);
            } else {
                result.put("status", 200);
                result.put("message", "[COEUS][API][ConfigActionBean] ERROR: Clean DB, check exception.");
            }

        } catch (IOException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: Clean DB, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: Clean DB, check parse exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * List all environments (i.e., all folders started by 'env_' string)
     *
     * @return
     */
    public Resolution listenv() {
        JSONObject result = new JSONObject();
        File src = new File(ConfigActionBean.class.getResource("/").getPath());
        String env[] = src.list(new FilenameFilter() {
            @Override
            public boolean accept(File dir, String name) {
                if (dir.isDirectory() && name.startsWith("env_")) {
                    return true;
                } else {
                    return false;
                }
            }
        });
        Map<String, List<String>> m = new HashMap<String, List<String>>();
        List<String> l = new ArrayList<String>();
        l.addAll(Arrays.asList(env));
        m.put("environments", l);
        result.putAll(m);

        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * Do the mapping from map.js to the configuration files.
     *
     * @param path
     * @throws ParseException
     */
    public void updateFilesFromMap(String path) throws ParseException, IOException {
        JSONParser parser = new JSONParser();
        JSONObject map = (JSONObject) parser.parse(readToString(path + "map.js"));

        //ensures that files (pubby, sdb and joseki) are clean
        copyFolder(new File(Config.getPath() + "init"), new File(path), new File(path + "map.js"));

        File src = new File(path);
        //list all the directory contents
        String files[] = src.list();
        for (String file : files) {
            if (!file.endsWith("map.js")) {
                String readString = readToString(path + file);
                for (Iterator it = map.entrySet().iterator(); it.hasNext();) {
                    Map.Entry e = (Map.Entry) it.next();
                    //System.out.println(e.getKey().toString() + " " + e.getValue().toString());
                    readString = readString.replace(e.getKey().toString(), e.getValue().toString());
                }
                System.out.println(file);
                updateFile(readString, path + file);
            }
        }
    }

    /**
     * Update a Environment:
     * <p>Copy all values from map.js to do the mapping in the configuration
     * files.</p>
     * <p>Copy files to the root dir and change the environment key in
     * config.js</p>
     *
     * @return
     */
    public Resolution upenv() {
        JSONObject result = new JSONObject();
        try {
            Boot.start();
            String path = Config.getPath() + "env_" + method + "/";

            updateFilesFromMap(path);
            changeEnvironment(path, Config.getPath(), "env_" + method);

            //Load new settings
            Boot.resetConfig();
            Boot.resetStorage();
            //TODO: FIX THAT - NEEDS SERVERS RESTART TO APPLY NEW CONFIGS 

            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] Environment updated: " + method);

        } catch (Exception ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: Evironment " + method + " not updated, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }

        //Boot.start();
        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * Change the environment: Copy files to the root dir and update the
     * environment key in config.js
     *
     * @param src
     * @param dest
     * @param environment
     * @throws IOException
     */
    public void changeEnvironment(String src, String dest, String environment) throws IOException {
        //copy all files from enviroment to root dir
        copyFolder(new File(src), new File(dest), null);
        JSONObject f = changeConfigValue("config", "environment", environment.split("env_", 2)[1]);
        //System.err.println(f.toJSONString());
        updateFile(f.toJSONString(), Config.getPath() + "config.js");
    }

    /**
     * Create a new environment according to the init directory (i.e., copy all
     * files to the new directory)
     *
     * @return
     */
    public Resolution newenv() {
        JSONObject result = new JSONObject();
        try {
            Boot.start();
            String name = "env_" + method;
            String envStr = Config.getPath() + name;
            String initStr = Config.getPath() + "init";
            File env = new File(envStr);
            if (env.exists()) {
                result.put("status", 200);
                result.put("message", "[COEUS][API][ConfigActionBean] ERROR: " + method + " already exists.");
                return new StreamingResolution("application/json", result.toJSONString());
            }
            File init = new File(initStr);

            copyFolder(init, env, null);
            //change to this env
            changeEnvironment(envStr, Config.getPath(), name);
            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] Environment created: " + method);
        } catch (IOException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: " + method + " not created, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }

        //Boot.start();
        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * Returns a map.js file in the environment (method)
     *
     * @return
     */
    public Resolution getmap() {
        JSONObject result = new JSONObject();
        try {
            Boot.start();
            String environment = "env_" + method;
            String path = Config.getPath() + environment + "/";
            String map = path + "map.js";
            JSONParser parser = new JSONParser();
            String json = readToString(map);
            result = (JSONObject) parser.parse(json);
        } catch (Exception ex) {
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * Receives a map.js file with only db information to create the DB
     * structure.
     *
     * @return
     */
    public Resolution db() {
        JSONObject result = new JSONObject();
        try {
            Boot.start();

            JSONParser parser = new JSONParser();
            System.out.println(method);
            JSONObject db = (JSONObject) parser.parse(method);
            //create the DB if not exists
            DB creator = new DB();
            creator.createDB(db.get("$sdb:jdbcURL").toString(), db.get("$sdb:sdbUser").toString(), db.get("$sdb:sdbPassword").toString());

//            String environment = "env_" + Config.getEnvironment();
//            String path = Config.getPath() + environment + "/";
//            String map = path + "map.js";
//            //update map.js file
//            result = updateFile(method, map);
//            //update files on the environment
//            updateFilesFromMap(path);
//            //change it to use
//            changeEnvironment(path, Config.getPath(), environment);
            //apply values
//            Boot.resetConfig();
            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] DB created.");

        } catch (ParseException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: On parse map.js, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: On creating database, check exception: " + ex);
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: Please, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * Receives a map.js file and update it in according to the environment key
     * in config.js.
     *
     * @return
     */
    public Resolution pubby() {
        JSONObject result = new JSONObject();
        try {
            Boot.start();

            JSONParser parser = new JSONParser();
            System.out.println(method);
            JSONObject db = (JSONObject) parser.parse(method);
            //create the DB if not exists
            //DB creator = new DB();
            //creator.createDB(db.get("$sdb:jdbcURL").toString(), db.get("$sdb:sdbUser").toString(), db.get("$sdb:sdbPassword").toString());

            String environment = "env_" + Config.getEnvironment();
            String path = Config.getPath() + environment + "/";
            String map = path + "map.js";
            //update map.js file
            result = updateFile(method, map);
            //update files on the environment
            updateFilesFromMap(path);
            //change it to use
            changeEnvironment(path, Config.getPath(), environment);
            //apply values
            Boot.resetConfig();

        } catch (ParseException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: On parse map.js, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: On update map.js, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }
        return new StreamingResolution("application/json", result.toJSONString());
    }

    /**
     * Delete a environment.
     *
     * @return
     */
    public Resolution delenv() {
        JSONObject result = new JSONObject();
        try {
            Boot.start();
            String envStr = Config.getPath() + "env_" + method;
            File env = new File(envStr);
            if (env.exists()) {
                delete(env);
            }
            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] Environment deleted: " + method);
        } catch (IOException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: " + method + " not deleted, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new StreamingResolution("application/json", result.toJSONString());
    }

    public Resolution readrdf() throws MalformedURLException, IOException {
        String location = "http://localhost:8080/coeus/resource/";
        //String location ="http://purl.org/dc/elements/1.1/";
        URL url = new URL(location);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        //set linked data content to rdf
        conn.setRequestProperty("Accept", " application/rdf+xml");
        //conn.setRequestProperty("User-Agent", "");
        conn.setInstanceFollowRedirects(true);
        HttpURLConnection.setFollowRedirects(true);
        //conn.setRequestProperty("Content-Type", "application/rdf+xml");
        //HttpURLConnection conn=conn.getInputStream();


        StringBuilder sb = new StringBuilder();
        String line;
        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();

        Map<String, List<String>> map = conn.getHeaderFields();
        for (Map.Entry<String, List<String>> entry : map.entrySet()) {
            System.out.println(entry.getKey() + " : " + entry.getValue());
        }

        System.out.println(context.getRequest().getServletPath());
        System.out.println(context.getRequest().getServerName());
        return new StreamingResolution("text/javascript", sb.toString());
    }

    /**
     * List all Ontology Proprieties.
     *
     * @return
     */
    public Resolution getprop() {

        Boot.start();
        Set<String> set = new TreeSet<String>();
        StringBuilder sb = new StringBuilder();
        //get all proprieties for each prefix
        JSONObject prefixes = (JSONObject) Config.getFile().get("prefixes");
        for (Object o : prefixes.values()) {
            System.err.println("Reading: " + o);
            set.addAll(getOntologyProperties(o.toString()));
        }

        for (String s : set) {
            sb.append(s);
        }

        return new StreamingResolution("text/javascript", sb.toString());
    }

    /**
     * Update the config.js file and Load all Object Proprieties to the
     * predicates.csv file according to the prefixes section on config.js.
     *
     * @return
     */
    public Resolution putconfig() {

        //update config.js
        String jsonString = method;
        JSONObject result = updateFile(jsonString, Config.getPath() + "config.js");
        Boot.resetConfig();

        //update predicates.csv
        Set<String> set = new TreeSet<String>();
        JSONObject prefixes = (JSONObject) Config.getFile().get("prefixes");
        for (Object o : prefixes.values()) {
            System.err.println("[COEUS][API][ConfigActionBean] Reading: " + o);
            set.addAll(getOntologyProperties(o.toString()));
        }
        //read local ontology TODO: FIX THAT
        String localOntology = context.getRequest().getScheme() + "://" + context.getRequest().getServerName() + ":" + context.getRequest().getServerPort() + context.getRequest().getContextPath() + "/ontology/";
        set.addAll(getOntologyProperties(localOntology));

        StringBuilder sb = new StringBuilder();
        for (String s : set) {
            sb.append(s);
        }

        updateFile(sb.toString(), Config.getPath() + "predicates.csv");

        return new StreamingResolution("text/javascript", result.toString());
    }

    /**
     * Change the key-value in the top key of the config.js file
     *
     * @param domain
     * @param key
     * @param value
     * @return
     */
    public JSONObject changeConfigValue(String topKey, String key, String value) {

        JSONObject f = Config.getFile();
        JSONObject config = (JSONObject) f.get(topKey);

        Map<String, String> m = new HashMap<String, String>();
        for (Iterator it = config.entrySet().iterator(); it.hasNext();) {
            Entry<String, String> e = (Entry<String, String>) it.next();
            m.put(e.getKey(), e.getValue());
        }
        m.put(key, value);
        f.put(topKey, m);
        return f;
    }

    /**
     * Update a existing file (writing the string value)
     *
     * @param value
     * @param filename
     * @return
     */
    private JSONObject updateFile(String value, String filename) {
        JSONObject result = new JSONObject();

        try {
            FileWriter writer = new FileWriter(filename);
            writer.write(value);
            writer.flush();
            writer.close();
            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] " + filename + " updated.");

            System.out.println("[COEUS][API][ConfigActionBean] Saved: " + filename);
        } catch (Exception ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: " + filename + " not updated, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Return all ontology properties from location URL.
     *
     * @param location
     * @return
     */
    public Set<String> getOntologyProperties(String location) {
        Set<String> set = new HashSet<String>();
        try {
            //auxiliar model
            OntModel auxModel = ModelFactory.createOntologyModel();
            auxModel.read(location);
            ExtendedIterator<OntProperty> op = auxModel.listOntProperties();

            while (op.hasNext()) {
                OntProperty prop = op.next();
                //if (prop.toString().startsWith(location)) {
                set.add(prop.toString() + "\n");
                //}
            }
        } catch (Exception e) {
            System.err.println("[COEUS][API][ConfigActionBean] ERROR in read model at: " + location);
        }
        return set;
    }

    /**
     * Copy a directory.
     *
     * @param src
     * @param dest
     * @throws IOException
     */
    public static void copyFolder(File src, File dest, File skipFile)
            throws IOException {

        if (src.isDirectory()) {

            //if directory not exists, create it
            if (!dest.exists()) {
                dest.mkdir();
                System.out.println("[COEUS][API][ConfigActionBean] Directory copied from "
                        + src + "  to " + dest);
            }

            //list all the directory contents
            String files[] = src.list();

            for (String file : files) {
                //construct the src and dest file structure
                File srcFile = new File(src, file);
                File destFile = new File(dest, file);
                //recursive copy
                copyFolder(srcFile, destFile, skipFile);
            }

        } else {
            if (skipFile == null || !(skipFile.getName().equals(src.getName()))) {
                //if file, then copy it
                //Use bytes stream to support all file types
                InputStream in = new FileInputStream(src);
                OutputStream out = new FileOutputStream(dest);

                byte[] buffer = new byte[1024];

                int length;
                //copy the file content in bytes 
                while ((length = in.read(buffer)) > 0) {
                    out.write(buffer, 0, length);
                }

                in.close();
                out.close();
                System.out.println("[COEUS][API][ConfigActionBean] File copied from " + src + " to " + dest);
            }
        }
    }

    /**
     * Delete a File or Directory.
     *
     * @param file
     * @throws IOException
     */
    public static void delete(File file)
            throws IOException {

        if (file.isDirectory()) {

            //directory is empty, then delete it
            if (file.list().length == 0) {

                file.delete();
                System.out.println("[COEUS][API][ConfigActionBean] Directory is deleted : "
                        + file.getAbsolutePath());

            } else {

                //list all the directory contents
                String files[] = file.list();

                for (String temp : files) {
                    //construct the file structure
                    File fileDelete = new File(file, temp);

                    //recursive delete
                    delete(fileDelete);
                }

                //check the directory again, if empty then delete it
                if (file.list().length == 0) {
                    file.delete();
                    System.out.println("[COEUS][API][ConfigActionBean] Directory is deleted : "
                            + file.getAbsolutePath());
                }
            }

        } else {
            //if file, then delete it
            file.delete();
            System.out.println("[COEUS][API][ConfigActionBean] File is deleted : " + file.getAbsolutePath());
        }
    }

    /**
     * Read and Convert a File to a String
     *
     * @param filename
     * @return
     */
    public String readToString(String filename) throws IOException {
        StringBuilder sb = new StringBuilder();

        BufferedReader br = new BufferedReader(new FileReader(filename));
        String line = br.readLine();

        while (line != null) {
            sb.append(line);
            sb.append('\n');
            line = br.readLine();
        }
        br.close();
        return sb.toString();
    }
}
