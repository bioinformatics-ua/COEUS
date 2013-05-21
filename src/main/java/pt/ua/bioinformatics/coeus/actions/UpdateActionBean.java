/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.actions;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.RDFNode;
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
@UrlBinding("/api/{apikey}/update/{sub}/{pred}/{old_obj},{new_obj}")
public class UpdateActionBean implements ActionBean {

    private ActionBeanContext context;
    private String apikey;
    private String sub;
    private String pred;
    private String old_obj;
    private String new_obj;
    private JSONObject result = new JSONObject();

    public JSONObject getResult() {
        return result;
    }

    public void setResult(JSONObject result) {
        this.result = result;
    }

    public String getNew_obj() {
        return new_obj;
    }

    public void setNew_obj(String new_obj) {
        this.new_obj = new_obj;
    }

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

    public String getOld_obj() {
        return old_obj;
    }

    public void setOld_obj(String old_obj) {
        this.old_obj = old_obj;
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
     * Update a triple from the KB. <p>Workflow</b><ol>
     * <li></li>
     * </ol></p>
     *
     * @return
     */
    @DefaultHandler
    public Resolution handle() {
        Boot.start();
        if (sub != null && pred != null && old_obj != null && new_obj != null) {
            if (Boot.getAPI().validateKey(apikey)) {
                if (sub.indexOf(":") > 1) {
                    try {
                        if (pred.indexOf(":") > 1) {
                            if (old_obj.contains(":")) {
                                //verify if the obj is a Resource or a Literal
                                if (old_obj.indexOf(":") > 1 && new_obj.indexOf(":") > 1) {
                                    // obj is a Resource

                                    Statement s = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), Boot.getAPI().createResource(PrefixFactory.decode(old_obj)));
                                    if (Boot.getAPI().containsStatement(s)) {

                                        Boot.getAPI().removeStatement(s);
                                        Boot.getAPI().addStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), Boot.getAPI().createResource(PrefixFactory.decode(new_obj)));

                                        result.put("status", 100);
                                        result.put("message", "[COEUS][API][Update] Triples updated in the knowledge base.");

                                    } else {
                                        result.put("status", 201);
                                        result.put("message", "[COEUS][API][Update] Triple do not existe in this model in order to update it.");
                                    }
                                } else {

                                    result.put("status", 203);
                                    result.put("message", "[COEUS][API][Update] " + old_obj + " or " + new_obj + " is an invalid object.");
                                }
                            } else {
                                //obj is a literal

                                Statement s = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), old_obj);
                                if (Boot.getAPI().containsStatement(s)) {

                                    Boot.getAPI().removeStatement(s);
                                    Boot.getAPI().addStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), new_obj);

                                    result.put("status", 100);
                                    result.put("message", "[COEUS][API][Update] Triples updated in the knowledge base.");

                                } else {
                                    result.put("status", 201);
                                    result.put("message", "[COEUS][API][Update] Triple do not existe in this model in order to update it.");
                                }

                            }
                        } else {
                            result.put("status", 202);
                            result.put("message", "[COEUS][API][Update] " + pred + " is an invalid predicate.");
                        }

                    } catch (Exception ex) {
                        if (Config.isDebug()) {
                            System.out.println("[COEUS][UpdateActionBean] Unable to add triple to knowledge base. Invalid request.");
                            Logger.getLogger(UpdateActionBean.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        result.put("status", 200);
                        result.put("message", "[COEUS][API][Update] Unable to remove triples to knowledge base, check exception.");
                        result.put("exception", ex.toString());
                    }
                } else {
                    result.put("status", 201);
                    result.put("message", "[COEUS][API][Update] " + sub + " is an invalid subject.");
                }

            } else {
                result.put("status", 403);
                result.put("message", "[COEUS][API][Update] Access is forbidden for key " + apikey + ".");
            }
        } else {
            result.put("status", 201);
            result.put("message", "[COEUS][API][Update] Incorret access. Please verify the url structure.");
        }

        return new StreamingResolution("text/javascript", result.toString());
    }
}
