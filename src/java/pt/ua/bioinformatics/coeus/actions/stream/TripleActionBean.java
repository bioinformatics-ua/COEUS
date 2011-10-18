package pt.ua.bioinformatics.coeus.actions.stream;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import pt.ua.bioinformatics.coeus.common.Boot;

/**
 *
 * @author pedrolopes
 */
@UrlBinding("/api/triple/{sub=s}/{pred=p}/{obj=oj}/{format=json}")
public class TripleActionBean implements ActionBean {

    private ActionBeanContext context;
    private String sub;
    private String pred;
    private String obj;
    private String format = "json";
    private String js_id = "${id}";
    private String js_full = "${full}";
    private String js_type = "${type}";
    private String js_value = "${value}";

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

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

    public String getObj() {
        return obj;
    }

    public void setObj(String obj) {
        this.obj = obj;
    }

    public String getPred() {
        return pred;
    }

    public void setPred(String pred) {
        this.pred = pred;
    }

    public String getSub() {
        return sub;
    }

    public void setSub(String sub) {
        this.sub = sub;
    }

    public void setContext(ActionBeanContext context) {
        this.context = context;
    }

    public ActionBeanContext getContext() {
        return context;
    }

    @DefaultHandler
    public Resolution handle() {
        Boot.start();
        return new StreamingResolution("application/json", (String) Boot.getAPI().getTriple(sub, pred, obj, format));
    }
}
