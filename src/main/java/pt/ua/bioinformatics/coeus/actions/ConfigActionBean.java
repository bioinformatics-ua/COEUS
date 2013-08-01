/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.actions;

import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.ontology.OntProperty;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.util.iterator.ExtendedIterator;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import org.json.simple.JSONObject;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;

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

    @DefaultHandler
    public Resolution handle() {
        return new ForwardResolution(NOTFOUND_VIEW);
    }

    public Resolution getconfig() {
        Boot.start();
        return new StreamingResolution("application/json", Config.getFile().toJSONString());
    }

    public Resolution readrdf() throws MalformedURLException, IOException {
        String location = "http://localhost:8080/coeus/resource/";
        //String location ="http://purl.org/dc/elements/1.1/";
        URL url = new URL(location);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        //set linked data content to rdf
        conn.setRequestProperty("Accept", " application/rdf+xml");
        //conn.setRequestProperty("User-Agent", "");
        conn.setInstanceFollowRedirects(true);HttpURLConnection.setFollowRedirects(true);
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

    public Resolution getprop() {

        Config.load();
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

    public Resolution putconfig() {

        //update config.js
        String jsonString = method;
        JSONObject result = updateFile(jsonString, "config.js");
        Config.setLoaded(false);
        Config.load();

        //update predicates.csv
        Set<String> set = new TreeSet<String>();
        JSONObject prefixes = (JSONObject) Config.getFile().get("prefixes");
        for (Object o : prefixes.values()) {
            System.err.println("[COEUS][API][ConfigActionBean] Reading: " + o);
            set.addAll(getOntologyProperties(o.toString()));
        }
        //read local ontology TODO: FIX THAT
        String localOntology=context.getRequest().getScheme()+"://"+context.getRequest().getServerName()+":"+context.getRequest().getServerPort()+context.getRequest().getContextPath()+"/ontology/";
        set.addAll(getOntologyProperties(localOntology));
        
        StringBuilder sb = new StringBuilder();
        for (String s : set) {
            sb.append(s);
        }
        
        updateFile(sb.toString(), "predicates.csv");

        return new StreamingResolution("text/javascript", result.toString());
    }

    public Resolution export() throws FileNotFoundException {
        StringWriter outs = new StringWriter();
        Boot.start();
        if (method.equals("setup.ttl")) {
            Boot.getAPI().getModel().write(outs, "TURTLE");
        } else {
            Boot.getAPI().getModel().write(outs, "RDF/XML");
        }
        return new StreamingResolution("application/rdf+xml", outs.toString());
    }

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

    private JSONObject updateFile(String value, String filename) {
        JSONObject result = new JSONObject();

        System.out.println("[COEUS][API][ConfigActionBean] Saving.. " + filename);

        try {
            FileWriter writer = new FileWriter(Config.getPath() + filename);
            writer.write(value);
            writer.flush();
            writer.close();
            result.put("status", 100);
            result.put("message", "[COEUS][API][ConfigActionBean] " + filename + " updated.");
        } catch (IOException ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] ERROR: " + filename + " not updated, check exception.");
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

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
}
