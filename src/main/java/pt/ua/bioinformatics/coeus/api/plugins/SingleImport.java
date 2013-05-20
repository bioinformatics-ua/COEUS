package pt.ua.bioinformatics.coeus.api.plugins;

import pt.ua.bioinformatics.coeus.common.Boot;

/**
 * Single thread handler for importing single resources.
 *
 * @author pedrolopes
 */
public class SingleImport implements Runnable {

    private String resource;

    public SingleImport(String res) {
        this.resource = res;
    }

    /**
     * Launch single Resource import process.
     */
    public void run() {
        Boot.singleImport(resource);
    }
}
