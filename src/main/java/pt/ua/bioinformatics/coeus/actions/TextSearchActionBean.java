package pt.ua.bioinformatics.coeus.actions;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.StreamingResolution;
import net.sourceforge.stripes.action.UrlBinding;
import pt.ua.bioinformatics.coeus.common.Boot;

/**
 *
 * @author sernadela
 */
@UrlBinding("/textsearch/query={query}")
public class TextSearchActionBean implements ActionBean {

    private ActionBeanContext context;
    private String query;

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public void setContext(ActionBeanContext context) {
        this.context = context;
    }

    public ActionBeanContext getContext() {
        return context;
    }

    @DefaultHandler
    public Resolution handle() {
        String result;
        String queryString = ""
                + "PREFIX pf: <http://jena.hpl.hp.com/ARQ/property#>"
                + "SELECT ?Text_Match ?Subject_Associated ?Predicate_Associated ?Score {"
                + "    (?Text_Match ?Score ) pf:textMatch '" + query + "*' ."
                + "    ?Subject_Associated ?Predicate_Associated ?Text_Match"
                + "}";
        result=Boot.getAPI().select(queryString, "json", false);
        System.err.println(queryString);
        return new StreamingResolution("application/json", result.toString());
    }
}
