package pt.ua.bioinformatics.coeus.actions;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import pt.ua.bioinformatics.coeus.common.Config;

/**
 *
 * @author pedrolopes
 */
@UrlBinding("/manager/entity/{query}")
public class EntityActionBean implements ActionBean {
    private static final String VIEW="/setup/listentities.jsp";
    private static final String VIEWADD="/setup/addentity.jsp";
    private ActionBeanContext context;
    private String sub;
    private String pred;
    private String query;
    
    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
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

        if(query==null)
        return new ForwardResolution(VIEW);
        else if(query.equals("add")) return new ForwardResolution(VIEWADD);
        else {
            return new StreamingResolution("application/json", Config.getFile().toJSONString());
        }
    }
}
