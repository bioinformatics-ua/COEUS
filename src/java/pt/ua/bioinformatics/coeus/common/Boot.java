package pt.ua.bioinformatics.coeus.common;

import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.data.Storage;

/**
 * Seed launcher.
 * 
 * @author pedrolopes
 */
public class Boot {

    private static boolean started = false;
    private static API api = null;

    public static boolean isStarted() {
        return started;
    }

    public static void setStarted(boolean started) {
        Boot.started = started;
    }

    public static API getAPI() {
        return api;
    }

    public static void setAPI(API api) {
        Boot.api = api;
    }

    /**
     * Starts the configured COEUS instance.
     * <p><b>Built workflow</b><ol>
     *  <li>Connect to COEUS Data SDB</li>
     *  <li>Load Predicate information for further usage</li>
     * </ol></p>
     * <p><b>Unbuilt workflow</b><ol>
     *  <li>Load Storage information (connect, ontology, setup, predicates)</li>
     *  <li>Build instance</li>
     *  <li>Save and restart</li>
     * </ol></p>
     */
    public static void start() {
        if (!started) {
            try {
                try {
                    Config.load();
                } catch (Exception ex) {
                    if (Config.isDebug()) {
                        System.out.println("[COEUS][Boot] Unable to load configuration");
                    }
                    Logger.getLogger(Boot.class.getName()).log(Level.SEVERE, null, ex);
                }
                if (!Config.isBuilt()) {
                    Storage.load();
                    api = new API();
                    Storage.loadPredicates();
                    Builder.build();
                    Builder.save();
                    //remove
                    Config.setBuilt(true);
                    start();
                } else {
                    Storage.connect();
                    api = new API();
                    Storage.loadPredicates();
                    System.out.println("\n\t[COEUS] " + Config.getName() + " Online\n");
                }

                started = true;
            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][Boot] Unable to start COEUS instance");
                }
                Logger.getLogger(Boot.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
        }
    }

    /** 
     * Starts Seed for importing data from a single Resource.
     * 
     * @param resource 
     */
    public static void singleImport(String resource) {
        try {
            Config.load();
            Storage.connectX();
            api = new API();
            Storage.loadPredicates();
            Builder.build(resource);
        } catch (Exception ex) {
            Logger.getLogger(Boot.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
