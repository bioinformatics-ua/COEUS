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
@UrlBinding("/manager/home/{param}")
public class ManagerActionBean implements ActionBean{
    private static final String VIEW="/setup/index.jsp";
    private String name;
    private String param;
    private ActionBeanContext context;

    @DefaultHandler
    public Resolution handle() throws ParseException{
        setName(Config.getName());
        if(param==null)
        return new ForwardResolution(VIEW);
        else {
            Boot.start();
            return new StreamingResolution("application/json", Config.getFile().toJSONString());
        }
    }
    
    public String getParam() {
        return param;
    }

    public void setParam(String param) {
        this.param = param;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public void setContext(ActionBeanContext actionBeanContext) {
        this.context=actionBeanContext;}

    @Override
    public ActionBeanContext getContext() {
        return context;
    }
    

}
