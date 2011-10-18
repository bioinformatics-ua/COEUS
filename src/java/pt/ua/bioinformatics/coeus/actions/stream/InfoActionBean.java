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
@UrlBinding("/api/info/{id}/{$event}")
public class InfoActionBean implements ActionBean {

    private ActionBeanContext context;
    private String id;
    
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
    public Resolution json() {
        Boot.start();
        id = id.replace(":", "_");
        String query = "SELECT ?p ?o WHERE { coeus:" + id + " ?p ?o }";
        return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "json", false));
    }
}
