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
import net.sourceforge.stripes.action.UrlBinding;
import pt.ua.bioinformatics.coeus.common.Config;


/**
 *
 * @author sernadela
 */
@UrlBinding("/seed/")
public class SeedActionBean implements ActionBean{
    private static final String VIEW="/setup/index.jsp";
    private String name;
    private ActionBeanContext context;

    @DefaultHandler
    public Resolution handle(){
        setName(Config.getName());
        return new ForwardResolution(VIEW);
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
