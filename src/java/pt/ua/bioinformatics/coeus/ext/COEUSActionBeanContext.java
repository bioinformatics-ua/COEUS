/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.ext;

import java.util.ArrayList;
import net.sourceforge.stripes.action.ActionBeanContext;
import pt.ua.bioinformatics.diseasecard.domain.Disease;

/**
 * Context Extender for COEUS Default Actions.
 * <p>Enables the creation of custom context actions in ActionBeans, check Stripes Docs for further information.</p>
 * 
 * @author pedrolopes
 */
public class COEUSActionBeanContext extends ActionBeanContext {

    private static final String DISEASE = "disease";

    public void setDisease(String key, Object value) {
        getRequest().getSession().setAttribute(key, value);
    }

    public void setDisease(Object value) {
        getRequest().getSession().setAttribute(DISEASE, value);
    }

    public <T> T getDisease() {
        return (T) getRequest().getSession().getAttribute(DISEASE);
    }

    public <T> T getDisease(String key) {
        return (T) getRequest().getSession().getAttribute(key);
    }

    public <T> T getDiseases() {
        return (T) getRequest().getSession().getAttribute(DISEASE);
    }

    public <T> T getDiseases(String key) {
        return (T) getRequest().getSession().getAttribute(key);
    }
    
    public void setSearchResults(String key, ArrayList<Disease> value) {
        getRequest().getSession().setAttribute(key, value);
    }
    
    public ArrayList<Disease> getSearchResults(String key) {
        return (ArrayList<Disease>) getRequest().getSession().getAttribute(key);
    }

    public void setCurrent(String key, Object value) {
        getRequest().getSession().setAttribute(key, value);
    }

    @SuppressWarnings("unchecked")
    public <T> T getCurrent(String key) {
        return (T) getRequest().getSession().getAttribute(key);
    }
}
