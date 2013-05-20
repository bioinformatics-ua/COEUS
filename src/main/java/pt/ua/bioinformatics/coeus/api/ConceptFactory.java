package pt.ua.bioinformatics.coeus.api;

/**
 * Utility class for Concept transformation tasks.
 *
 * @author pedrolopes
 */
public class ConceptFactory {

    /**
     * Converts a COEUS-formatted item name into a single token, usable on any
     * other method.
     *
     * @param item the Item to be converted.
     * @return the converted token.
     */
    public static String getTokenFromConcept(String item) {
        String check = "";
        if (item.contains("_")) {
            String[] full = item.split("\\_");
            check = full[1];
        } else {
            check = item;
        }
        return check.toLowerCase() + "_";
    }
}
