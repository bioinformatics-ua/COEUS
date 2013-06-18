/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
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
 * @author sernadela
 */
@UrlBinding("/api/{apikey}/delete/{sub}/{pred}/{obj}")
public class DeleteActionBean implements ActionBean {

    private ActionBeanContext context;
    private String apikey;
    private String sub;
    private String pred;
    private String obj;
    private JSONObject result = new JSONObject();

    public String getApikey() {
        return apikey;
    }

    public void setApikey(String apikey) {
        this.apikey = apikey;
    }

    public String getSub() {
        return sub;
    }

    public void setSub(String sub) {
        this.sub = sub;
    }

    public String getPred() {
        return pred;
    }

    public void setPred(String pred) {
        this.pred = pred;
    }

    public String getObj() {
        return obj;
    }

    public void setObj(String obj) {
        this.obj = obj;
    }

    @Override
    public void setContext(ActionBeanContext abc) {
        this.context = abc;
    }

    @Override
    public ActionBeanContext getContext() {
        return this.context;
    }

    /**
     * Delete a triple from the KB. <p>Workflow</b><ol>
     * <li>Check if obj is a Resource or a Literal</li>
     * <li>Create the statement depending on the obj</li>
     * <li>Verify if the statement exists in the kb</li>
     * <li>If exist try to remove the statement</li>
     * <li>Finally check if has been deleted in the KB.</li>
     * </ol></p>
     *
     * @return
     */
    @DefaultHandler
    public Resolution handle() {
        Boot.start();
        if (sub != null && pred != null && obj != null) {
            if (Boot.getAPI().validateKey(apikey)) {
                if (sub.indexOf(":") > 1) {
                    try {
                        if (pred.indexOf(":") > 1) {
                            
                            // test obj
                            String xsd = "http://www.w3.org/2001/XMLSchema#";
                            Statement statToRemove = null;
                            //verify if is a xsd type
                            if (obj.startsWith("xsd:")) {
                                String[] old = obj.split(":", 3);
                                Literal l = Boot.getAPI().getModel().createTypedLiteral(old[2], xsd + old[1]);
                                statToRemove = Boot.getAPI().getModel().createLiteralStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), l);
                            } else if (obj.indexOf(":") > 1) {
                                //is a Resource
                                statToRemove = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), Boot.getAPI().createResource(PrefixFactory.decode(obj)));
                            } else {
                                //is a Literal
                                statToRemove = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), obj);
                            }

                            if (Boot.getAPI().containsStatement(statToRemove)) {
                                
                                Boot.getAPI().removeStatement(statToRemove);

                                result.put("status", 100);
                                result.put("message", "[COEUS][API][Delete] Triples removed from the knowledge base.");

                            } else {
                                result.put("status", 201);
                                result.put("message", "[COEUS][API][Delete] Triple do not existe in this model in order to remove it.");
                            }
                            
                        } else {
                            result.put("status", 202);
                            result.put("message", "[COEUS][API][Delete] " + pred + " is an invalid predicate.");
                        }

                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            System.out.println("[COEUS][DeleteActionBean] Unable to add triple to knowledge base. Invalid request.");
                            Logger.getLogger(DeleteActionBean.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        result.put("status", 200);
                        result.put("message", "[COEUS][API][Delete] Unable to remove triples to knowledge base, check exception.");
                        result.put("exception", ex.toString());
                    }
                } else {
                    result.put("status", 201);
                    result.put("message", "[COEUS][API][Delete] " + sub + " is an invalid subject.");
                }

            } else {
                result.put("status", 403);
                result.put("message", "[COEUS][API][Delete] Access is forbidden for key " + apikey + ".");
            }
        } else {
            result.put("status", 201);
            result.put("message", "[COEUS][API][Update] Incorret access. Please verify the url structure.");
        }

        return new StreamingResolution("text/javascript", result.toString());
    }
}
