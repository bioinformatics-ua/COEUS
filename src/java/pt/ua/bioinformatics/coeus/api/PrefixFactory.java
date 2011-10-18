package pt.ua.bioinformatics.coeus.api;

import java.util.HashMap;

/**
 * Utility class for Prefix information and transformations.
 *
 * @author pedrolopes
 */
public class PrefixFactory {

    public static HashMap<String, String> prefixes = new HashMap<String, String>();

    public static HashMap<String, String> getPrefixes() {
        return prefixes;
    }

    public static void setPrefixes(HashMap<String, String> prefixes) {
        PrefixFactory.prefixes = prefixes;
    }

    /**
     * Encodes a full URI to a shortned RDF string.
     * <p>
     *  <b>Sample</b><br />
     *  http://bioinformatics.ua.pt/coeus/Resource encodes to coeus:Resource.
     * </p>
     * @param what the encoded string.
     * @return
     */
    public static String encode(String uri) {
        String prefix = getPrefixForURI(uri);
        //System.out.println("\t" + prefix);
        return uri.replace(prefixes.get(prefix), prefix + ":");// + ":" + value;
    }

    /**
     * Decodes a shortned RDF String to a full URI.
     * <p>
     *  <b>Sample</b><br />
     *  coeus:Resource decodes to http://bioinformatics.ua.pt/coeus/Resource.
     * </p>
     * @param what the encoded string.
     * @return
     */
    public static String decode(String what) {
        String[] tmp = what.split(":");
        return prefixes.get(tmp[0]) + tmp[1];
    }

    /**
     * Adds a new prefix to in-memory prefix map.
     *
     * @param prefix a String with the prefix.
     * @param uri the prefix URI.
     */
    public static void add(String prefix, String uri) {
        prefixes.put(prefix, uri);
    }

    /**
     * Shorthand for prefix map access.
     * 
     * @param what prefix to URI for.
     * @return the URI.
     */
    public static String getURIForPrefix(String what) {
        return prefixes.get(what);
    }

    /**
     * Transforms a given URI into a prefix from the prefix map.
     *
     * @param uri the prefix URI.
     * @return a String with the prefix.
     */
    public static String getPrefixForURI(String uri) {
        String prefix = "";
        for (String s : prefixes.values()) {
            if (uri.contains(s)) {
                prefix = getKeyForValue(prefixes, s);
            }
        }
        return prefix;
    }

    /**
     * Finds the correct key in the prefix HashMap for the given value.
     * 
     * @param hm HashMap with prefix set.
     * @param value prefix short identifier.
     * @return
     */
    private static String getKeyForValue(HashMap<String, String> hm, String value) {
        String list = "";
        for (String o : hm.keySet()) {
            if (hm.get(o).equals(value)) {
                list = (String) o;
            }
        }
        return list;
    }

    /**
     * Generates PREFIX set for SPARQL querying.
     *
     * @return a String with the PREFIX set.
     */
    public static String allToString() {
        String p = "";
        for (String o : prefixes.keySet()) {
            p += "PREFIX " + o + ": " + "<" + prefixes.get(o).toString() + ">\n";
        }
        return p;
    }
}
