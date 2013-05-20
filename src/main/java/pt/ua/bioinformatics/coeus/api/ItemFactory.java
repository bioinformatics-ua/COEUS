package pt.ua.bioinformatics.coeus.api;

/**
 * Utility class for Item transformation tasks.
 *
 * @author pedrolopes
 */
public class ItemFactory {

    /**
     * Converts a COEUS-formatted item name into a single token, usable on any
     * other method.
     *
     * @param item the Item to be converted.
     * @return the converted token.
     */
    public static String getTokenFromItem(String item) {
        String token = "";
        String check = "";
        if (item.contains("_")) {
            String[] full = item.split("\\_");
            check = full[1];
        } else {
            check = item;
        }

        if (check.contains("~")) {
            String[] tmp = check.split("~");
            token = tmp[0];
        } else {
            token = check;
        }
        return token;
    }
}
