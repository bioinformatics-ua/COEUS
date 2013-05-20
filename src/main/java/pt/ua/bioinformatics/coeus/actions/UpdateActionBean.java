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
@UrlBinding("/api/{apikey}/update/{sub}/{pred}/{obj}")
public class UpdateActionBean implements ActionBean {

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
     * Update a triple from the KB. <p>Workflow</b><ol>
     * <li></li>
     * </ol></p>
     *
     * @return
     */
    @DefaultHandler
    public Resolution handle() {
        Boot.start();
        if (Boot.getAPI().validateKey(apikey)) {
            if (sub.indexOf(":") > 1) {
                try {
                    if (pred.indexOf(":") > 1) {
                        if (obj.contains(":")) {
                            //verify if the obj is a Resource or a Literal
                            if (obj.indexOf(":") > 1) {
                                // obj is a Resource

                                ResultSet rs = Boot.getAPI().selectRS("SELECT ?obj {" + sub + " " + pred + " ?obj }", false);

                                while (rs.hasNext()) {
                                    QuerySolution soln = rs.nextSolution();
                                    RDFNode r = soln.get("?obj");

                                    if (r != null) {
                                        //System.err.println("removing object: " + r.toString());
                                        Statement s = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), Boot.getAPI().createResource(r.toString()));
                                        Boot.getAPI().removeStatement(s);
                                    }
                                }
                                Boot.getAPI().addStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), Boot.getAPI().createResource(PrefixFactory.decode(obj)));

                                result.put("status", 100);
                                result.put("message", "[COEUS][API][Update] Triples updated in the knowledge base.");

                            } else {

                                result.put("status", 203);
                                result.put("message", "[COEUS][API][Update] " + obj + " is an invalid object.");
                            }
                        } else {
                            //obj is a literal
                            ResultSet rs = Boot.getAPI().selectRS("SELECT ?obj {" + sub + " " + pred + " ?obj }", false);

                            while (rs.hasNext()) {
                                QuerySolution soln = rs.nextSolution();
                                RDFNode r = soln.get("?obj");

                                if (r != null) {
                                    //System.err.println("removing object: " + r.toString());
                                    Statement s = Boot.getAPI().createStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), r.toString());
                                    Boot.getAPI().removeStatement(s);
                                }
                            }
                            Boot.getAPI().addStatement(Boot.getAPI().createResource(PrefixFactory.decode(sub)), Predicate.get(pred), obj);

                            result.put("status", 100);
                            result.put("message", "[COEUS][API][Update] Triples updated in the knowledge base.");

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

        return new StreamingResolution("text/javascript", result.toString());
    }
}
