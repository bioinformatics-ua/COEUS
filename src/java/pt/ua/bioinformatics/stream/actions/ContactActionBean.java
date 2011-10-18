package pt.ua.bioinformatics.stream.actions;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;

/**
 *
 * @author pedrolopes
 */
@UrlBinding("/contact")
public class ContactActionBean implements ActionBean {

    private ActionBeanContext context;
    
    public void setContext(ActionBeanContext context) {
        this.context = context;
    }

    public ActionBeanContext getContext() {
        return context;
    }

    @DefaultHandler
    public Resolution doView() {
        return new ForwardResolution("/contact.jsp");
    }
}
