package pt.ua.bioinformatics.coeus.actions;

import com.hp.hpl.jena.rdf.model.Literal;
import com.hp.hpl.jena.rdf.model.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import org.json.simple.JSONObject;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;

/**
 *
 * @author pedrolopes
 */
@UrlBinding("/api/{apikey}/write/{sub}/{pred}/{obj}")
public class WriteActionBean implements ActionBean {

    private ActionBeanContext context;
    private String apikey;
    private String sub;
    private String pred;
    private String obj;
    private JSONObject result = new JSONObject();

    public String getObj() {
        return obj;
    }

    public void setObj(String obj) {
        this.obj = obj;
    }

    public JSONObject getResult() {
        return result;
    }

    public void setResult(JSONObject result) {
        this.result = result;
    }

    public String getApikey() {
        return apikey;
    }

    public void setApikey(String apikey) {
        this.apikey = apikey;
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
        if (sub != null && pred != null && obj != null) {
            if (Boot.getAPI().validateKey(apikey)) {
                if (sub.indexOf(":") > 1) {
                    try {

                        if (pred.contains(":")) {
                            String xsd = "http://www.w3.org/2001/XMLSchema#";
                            Statement statToAdd = null;
                            //verify if is a xsd type
                            if (obj.startsWith("xsd:")) {
                                String[] old = obj.split(":", 3);
                                System.err.println(obj);
                                Literal l = Boot.getAPI().getModel().createTypedLiteral(old[2], xsd + old[1]);
                                statToAdd = Boot.getAPI().getModel().createLiteralStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), l);
                            } else if (obj.indexOf(":") > 1) {
                                //is a Resource
                                statToAdd = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), Boot.getAPI().createResource(PrefixFactory.decode(obj)));
                            } else {
                                //is a Literal
                                statToAdd = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), obj);
                            }

                            Boot.getAPI().addStatement(statToAdd);

                            result.put("status", 100);
                            result.put("message", "[COEUS][API][Write] Triples added to knowledge base.");

                        } else {
                            result.put("status", 202);
                            result.put("message", "[COEUS][API][Write] " + pred + " is an invalid predicate.");
                        }


                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            System.out.println("[COEUS][WriteActionBean] Unable to add triple to knowledge base. Invalid request.");
                            Logger.getLogger(WriteActionBean.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        result.put("status", 200);
                        result.put("message", "[COEUS][API][Write] Unable to add triples to knowledge base, check exception.");
                        result.put("exception", ex.toString());
                    }
                } else {
                    result.put("status", 201);
                    result.put("message", "[COEUS][API][Write] " + sub + " is an invalid subject.");
                }
            } else {
                result.put("status", 403);
                result.put("message", "[COEUS][API][Write] Access is forbidden for key " + apikey + ".");
            }
        } else {
            result.put("status", 201);
            result.put("message", "[COEUS][API][Update] Incorret access. Please verify the url structure.");
        }
        return new StreamingResolution("text/javascript", result.toString());
    }
}
