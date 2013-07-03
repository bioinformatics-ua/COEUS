/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.actions;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 *
 * @author sernadela
 */
@UrlBinding("/manager/{model}/{method}")
public class ManagerActionBean implements ActionBean {

    private static final String INDEX_VIEW = "/setup/index.jsp";
    private static final String SEEDS_VIEW = "/setup/seeds.jsp";
    private static final String SEEDS_ADD_VIEW = "/setup/addseed.jsp";
    private static final String ENTITY_ADD_VIEW = "/setup/addentity.jsp";
    private static final String ENTITIES_VIEW = "/setup/entities.jsp";
    private static final String CONCEPT_ADD_VIEW = "/setup/addconcept.jsp";
    private static final String CONCEPTS_VIEW = "/setup/concepts.jsp";
    private static final String NOTFOUND_VIEW = "/setup/404.jsp";
    private String method;
    private String model;
    private ActionBeanContext context;

    @DefaultHandler
    public Resolution handle() {


        if (model.equals("entity")) {
            if (method.startsWith("add") | method.startsWith("edit")) {
                return new ForwardResolution(ENTITY_ADD_VIEW);
            } else {
                return new ForwardResolution(ENTITIES_VIEW);
            }
        } else if (model.equals("concept")) {
            if (method.startsWith("add") | method.startsWith("edit")) {
                return new ForwardResolution(CONCEPT_ADD_VIEW);
            } else {
                return new ForwardResolution(CONCEPTS_VIEW);
            }
        } 
        else if (model.equals("seed")) {
            if(method==null) return new ForwardResolution(SEEDS_VIEW);
            else if (method.equals("add") | method.startsWith("edit")) return new ForwardResolution(SEEDS_ADD_VIEW);
            else return new ForwardResolution(INDEX_VIEW);
            
        }else {
            return new ForwardResolution(NOTFOUND_VIEW);
        }

        //setName(Config.getName());
        /*if(model==null) return new ForwardResolution(SEEDS_VIEW);
         //else if(model.equals("seeds")) {return new ForwardResolution(SEEDS);}
         else{
         if(model.equals("entity")){ 
         if(method.equals("add"))
         return new ForwardResolution(ENTITY_ADD_VIEW);
         else return new ForwardResolution(ENTITIES_VIEW);
         }
         else if(model.equals("concept")){ 
         if(method.equals("add"))
         return new ForwardResolution(CONCEPT_ADD_VIEW);
         else return new ForwardResolution(CONCEPTS_VIEW);
         }
         else {return new ForwardResolution(INDEX_VIEW);}
         //Boot.start();
         //return new StreamingResolution("application/json", Config.getFile().toJSONString());
         */
    
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
        this.context=actionBeanContext;}

    @Override
        public ActionBeanContext getContext() {
        return context;
    }
    

}
