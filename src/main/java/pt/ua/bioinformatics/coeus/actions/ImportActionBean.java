/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.actions;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import org.json.simple.JSONObject;
import pt.ua.bioinformatics.coeus.common.Boot;

/**
 *
 * @author sernadela
 */
@UrlBinding("/api/{apikey}/read/")
public class ImportActionBean implements ActionBean {

    private ActionBeanContext context;
    private String apikey;

    public String getApikey() {
        return apikey;
    }

    public void setApikey(String apikey) {
        this.apikey = apikey;
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
        JSONObject result = new JSONObject();
        try {
            Boot.start();
            if (Boot.getAPI().validateKey(apikey)) {
                HttpServletRequest request = context.getRequest();
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    //InputStream is=request.getInputStream();
                    String data = request.getParameter("data");
                    String base = request.getParameter("base");
                    String lang = request.getParameter("lang");
                    //System.err.println("content: " + data);
                    InputStream is = new ByteArrayInputStream(data.getBytes());
                    Boot.getAPI().readModel(is, null, lang);
                    result.put("status", 100);
                    result.put("message", "[COEUS][API][ConfigActionBean] Read OK ");
                } else {
                    result.put("status", 200);
                    result.put("message", "[COEUS][API][ConfigActionBean] Use POST instead.");
                }
            } else {
                result.put("status", 403);
                result.put("message", "[COEUS][API][Read] Access is forbidden for key " + apikey + ".");
            }
        } catch (Exception ex) {
            result.put("status", 200);
            result.put("message", "[COEUS][API][ConfigActionBean] Read ERROR: " + ex.getLocalizedMessage());
            Logger.getLogger(ConfigActionBean.class.getName()).log(Level.SEVERE, null, ex);
        }

        return new StreamingResolution("application/json", result.toJSONString());
    }

}
