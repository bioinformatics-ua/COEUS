/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pt.ua.bioinformatics.coeus.actions;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.StringWriter;
import java.io.Writer;
import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import pt.ua.bioinformatics.coeus.common.Boot;

/**
 *
 * @author sernadela
 */
@UrlBinding("/manager/{$model}/{method}")
public class ManagerActionBean implements ActionBean {

    private static final String INDEX_VIEW = "/setup/index.jsp";
    private static final String SEEDS_VIEW = "/setup/seeds.jsp";
    private static final String SEEDS_ADD_VIEW = "/setup/addseed.jsp";
    private static final String ENTITY_ADD_VIEW = "/setup/addentity.jsp";
    private static final String ENTITIES_VIEW = "/setup/entities.jsp";
    private static final String CONCEPT_ADD_VIEW = "/setup/addconcept.jsp";
    private static final String CONCEPTS_VIEW = "/setup/concepts.jsp";
    private static final String RESOURCE_ADD_VIEW = "/setup/addresource.jsp";
    private static final String RESOURCES_VIEW = "/setup/resources.jsp";
    private static final String NOTFOUND_VIEW = "/setup/404.jsp";
    private String method;
    private String model;
    private ActionBeanContext context;

    @DefaultHandler
    public Resolution handle() {
        return new ForwardResolution(NOTFOUND_VIEW);

    }

    public Resolution export() throws FileNotFoundException {
        StringWriter outs = new StringWriter();
        Boot.start();
        if (method.equals("setup.ttl")) {
            Boot.getAPI().getModel().write(outs, "TURTLE");
        } else {
            Boot.getAPI().getModel().write(outs, "RDF/XML");
        }
        return new StreamingResolution("application/rdf+xml", outs.toString());
    }

    public Resolution seed() {
        if (method == null) {
            return new ForwardResolution(SEEDS_VIEW);
        } else if (method.equals("add") | method.startsWith("edit")) {
            return new ForwardResolution(SEEDS_ADD_VIEW);
        } else {
            return new ForwardResolution(INDEX_VIEW);
        }
    }

    public Resolution entity() {
        if (method.startsWith("add") | method.startsWith("edit")) {
            return new ForwardResolution(ENTITY_ADD_VIEW);
        } else {
            return new ForwardResolution(ENTITIES_VIEW);
        }
    }

    public Resolution concept() {
        if (method.startsWith("add") | method.startsWith("edit")) {
            return new ForwardResolution(CONCEPT_ADD_VIEW);
        } else {
            return new ForwardResolution(CONCEPTS_VIEW);
        }
    }

    public Resolution resource() {
        if (method.startsWith("add") | method.startsWith("edit")) {
            return new ForwardResolution(RESOURCE_ADD_VIEW);
        } else {
            return new ForwardResolution(RESOURCES_VIEW);
        }
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
