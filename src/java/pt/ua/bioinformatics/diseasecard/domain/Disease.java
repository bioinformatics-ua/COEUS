package pt.ua.bioinformatics.diseasecard.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import pt.ua.bioinformatics.coeus.domain.Item;

/**
 *
 * @author pedrolopes
 */
public class Disease {

    private int id;
    private String name;
    private String omimId;
    private String location;

    private ArrayList<String> genes = new ArrayList<String>();
    private ArrayList<String> names = new ArrayList<String>();
    private ArrayList<Disease> genotypes = new ArrayList<Disease>();
    private ArrayList<Disease> phenotypes = new ArrayList<Disease>();

   
    public ArrayList<String> getGenes() {
        return genes;
    }

    public String getOmimId() {
        return omimId;
    }

    public void setOmimId(String omim_id) {
        this.omimId = omim_id;
    }

    public void setGenes(ArrayList<String> genes) {
        this.genes = genes;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public ArrayList<Disease> getPhenotypes() {
        return phenotypes;
    }

    public void setPhenotypes(ArrayList<Disease> phenotypes) {
        this.phenotypes = phenotypes;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ArrayList<String> getNames() {
        return names;
    }

    public void setNames(ArrayList<String> names) {
        this.names = names;
    }

    /**
     * Loads Disease information from SDB based on its key - OMIM code.
     * 
     * @param key 
     */
    public Disease(int key) {
        this.id = key;
        this.omimId = String.valueOf(key);
        // this.omim = String.valueOf(key);
        try {

        } catch (Exception ex) {
            Logger.getLogger(Item.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Disease(String name, String omim) {
        this.name = name;
        this.genotypes = new ArrayList<Disease>();
        this.phenotypes = new ArrayList<Disease>();
        this.names = new ArrayList<String>();
    }

    public ArrayList<Disease> getGenotypes() {
        return genotypes;
    }

    public void setGenotypes(ArrayList<Disease> genotypes) {
        this.genotypes = genotypes;
    }

    @Override
    public String toString() {
        String response = "";

        response += this.omimId + "\t" + this.name;
        for (Disease s : genotypes) {
            response += "\n\t" + s.getName() + " > " + s.getOmimId();
        }
        response += "\n\tGenes";

        return response;
    }
}
