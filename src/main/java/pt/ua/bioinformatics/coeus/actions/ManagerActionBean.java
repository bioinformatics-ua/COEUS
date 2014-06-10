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

/**
 * Pages forward manager
 *
 * @author sernadela
 */
@UrlBinding("/manager/{$model}/{method}")
public class ManagerActionBean implements ActionBean {

    private static final String DASHBOARD_VIEW = "/setup/dashboard.jsp";
    private static final String SEEDS_VIEW = "/setup/seeds.jsp";
    private static final String ENTITIES_VIEW = "/setup/entities.jsp";
    private static final String CONCEPTS_VIEW = "/setup/concepts.jsp";
    private static final String RESOURCES_VIEW = "/setup/resources.jsp";
    private static final String SELECTORS_VIEW = "/setup/selectors.jsp";
    private static final String ENVIRONMENTS_VIEW = "/setup/environments.jsp";
    private static final String ENVIRONMENTS_EDIT_VIEW = "/setup/editenvironment.jsp";
    private static final String GRAPH_VIEW = "/setup/graph.jsp";
    private static final String INDEX_VIEW = "/setup/index.jsp";
    private static final String WIZARD_VIEW = "/setup/config.jsp";
    private static final String NANOPUB_VIEW = "/setup/nanopubs.jsp";
    private String method;
    private String model;
    private ActionBeanContext context;

    @DefaultHandler
    public Resolution handle() {
        return new ForwardResolution(INDEX_VIEW);
    }

    public Resolution config() {
        return new ForwardResolution(WIZARD_VIEW);
    }

//    public Resolution graph() {
//        return new ForwardResolution(GRAPH_VIEW);
//    }
    public Resolution environments() {
        if (method != null && method.startsWith("edit")) {
            return new ForwardResolution(ENVIRONMENTS_EDIT_VIEW);
        } else {
            return new ForwardResolution(ENVIRONMENTS_VIEW);
        }
    }

    public Resolution seed() {
        if (method == null) {
            return new ForwardResolution(SEEDS_VIEW);
        } else {
            return new ForwardResolution(DASHBOARD_VIEW);
        }
    }

    public Resolution nanopub() {
        return new ForwardResolution(NANOPUB_VIEW);
    }

    public Resolution entity() {
        return new ForwardResolution(ENTITIES_VIEW);
    }

    public Resolution concept() {
        return new ForwardResolution(CONCEPTS_VIEW);
    }

    public Resolution resource() {
        return new ForwardResolution(RESOURCES_VIEW);
    }

    public Resolution selector() {
        return new ForwardResolution(SELECTORS_VIEW);
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
        this.context = actionBeanContext;
    }

    @Override
    public ActionBeanContext getContext() {
        return context;
    }
}
