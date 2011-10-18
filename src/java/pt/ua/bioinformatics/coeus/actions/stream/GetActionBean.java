package pt.ua.bioinformatics.coeus.actions.stream;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import pt.ua.bioinformatics.coeus.common.Boot;

/**
 *
 * @author pedrolopes
 */
@UrlBinding("/api/{id}.{$event}")
public class GetActionBean implements ActionBean {

    private ActionBeanContext context;
    private String id;
    private String js_id = "${id}";
    private String js_full = "${full}";
    private String js_type = "${type}";
    private String js_value = "${value}";

    public String getJs_full() {
        return js_full;
    }

    public void setJs_full(String js_full) {
        this.js_full = js_full;
    }

    public String getJs_id() {
        return js_id;
    }

    public void setJs_id(String js_id) {
        this.js_id = js_id;
    }

    public String getJs_type() {
        return js_type;
    }

    public void setJs_type(String js_type) {
        this.js_type = js_type;
    }

    public String getJs_value() {
        return js_value;
    }

    public void setJs_value(String js_value) {
        this.js_value = js_value;
    }

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
    public Resolution doView() {
        Boot.start();
        return new ForwardResolution("/stream/index.jsp");
    }

    public Resolution json() {
        
        Boot.start();
        id = id.replace(":", "_");
        String query = "SELECT ?s WHERE { coeus:" + id + " coeus:isAssociatedTo ?s }";
        return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "json", false));
    }

    public Resolution xml() {
        Boot.start();
        id = id.replace(":", "_");
        String query = "SELECT ?s WHERE { coeus:" + id + " coeus:isAssociatedTo ?s }";
        return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "xml", false));
    }

    public Resolution csv() {
        Boot.start();
        id = id.replace(":", "_");
        String query = "SELECT ?s WHERE { coeus:" + id + " coeus:isAssociatedTo ?s }";
        return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "csv", false));
    }

    public Resolution rdf() {
        Boot.start();
        id = id.replace(":", "_");
        String query = "SELECT ?s WHERE { coeus:" + id + " coeus:isAssociatedTo ?s }";
        return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "rdf", false));
    }

    public Resolution js() {
        Boot.start();
        id = id.replace(":", "_");
        String query = "SELECT ?s WHERE { coeus:" + id + " coeus:isAssociatedTo ?s }";
        return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "js", false));
    }

    public Resolution info() {
        Boot.start();
        id = id.replace(":", "_");
        String query = "SELECT ?p ?o WHERE { coeus:" + id + " ?p ?o }";
        return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "json", false));
    }
}
