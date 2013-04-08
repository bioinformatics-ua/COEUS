package pt.ua.bioinformatics.coeus.actions;

import javax.servlet.http.HttpServletResponse;
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
@UrlBinding("/api/{apikey}/info/{id}/{$event}")
public class InfoActionBean implements ActionBean {

    private ActionBeanContext context;
    private String id;
    private String apikey;

    public String getApikey() {
        return apikey;
    }

    public void setApikey(String apikey) {
        this.apikey = apikey;
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
    public Resolution json() {
        Boot.start();

        if (Boot.getAPI().validateKey(apikey)) {
            id = id.replace(":", "_");
            String query = "SELECT ?p ?o WHERE { coeus:" + id + " ?p ?o }";
            return new StreamingResolution("application/json", (String) Boot.getAPI().select(query, "json", false));
        } else {
           // StreamingResolution sr = new StreamingResolution("application/json", "{'status': 403}");
            return new StreamingResolution("text/xml") {
                public void stream(HttpServletResponse response) throws Exception {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                }
            };          
            
        }
    }
}
