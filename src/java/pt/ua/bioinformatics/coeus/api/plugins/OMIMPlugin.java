package pt.ua.bioinformatics.coeus.api.plugins;

import au.com.bytecode.opencsv.CSVReader;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import pt.ua.bioinformatics.coeus.api.API;
import pt.ua.bioinformatics.coeus.api.PrefixFactory;
import pt.ua.bioinformatics.coeus.common.Boot;
import pt.ua.bioinformatics.coeus.common.Config;
import pt.ua.bioinformatics.coeus.data.Predicate;
import pt.ua.bioinformatics.coeus.domain.Resource;
import pt.ua.bioinformatics.diseasecard.domain.Disease;

/**
 * DiseaseCard plugin for OMIM data handling.
 * <p>Generates initial gene and disease dataset based on OMIM's morbid map.
 * </p>
 * 
 * @author pedrolopes
 */
public class OMIMPlugin {

    private Resource res;
    private API api;
    private HashMap<String, Disease> diseases;
    private HashMap<String, Disease> genotypes;

    public HashMap<String, Disease> getGenotypes() {
        return genotypes;
    }

    public void setGenotypes(HashMap<String, Disease> genotypes) {
        this.genotypes = genotypes;
    }

    public HashMap<String, Disease> getDiseases() {
        return diseases;
    }

    public void setDiseases(HashMap<String, Disease> diseases) {
        this.diseases = diseases;
    }

    public Resource getRes() {
        return res;
    }

    public void setRes(Resource res) {
        this.res = res;
    }

    public OMIMPlugin(Resource res) {
        this.res = res;
        this.diseases = new HashMap<String, Disease>();
        this.genotypes = new HashMap<String, Disease>();
        this.api = Boot.getAPI();
    }

    /**
     * OMIMPlugin controller.
     * <p><b>Workflow:</b><ul>
     *  <li>Load genotype information from OMIM genemap</li>
     *  <li>Load phenotype information from OMIM morbidmap</li>
     *  <li>Import loaded dataset into COEUS SDB</li>
     * </ul></p>
     *
     */
    public void itemize() {
        if (loadGenotype() && loadPhenotype()) {
            triplify();
        }
    }

    /**
     * Loads genotype information from OMIM genemap into internal memory.
     *
     * @return success of the operation.
     */
    private boolean loadGenotype() {
        boolean success = true;
        try {
            //URL u = new URL("ftp://ftp.ncbi.nih.gov/repository/OMIM/ARCHIVE/genemap");
            URL u = new URL("http://localhost/~pedrolopes/omim/genemap_small");
            BufferedReader in = new BufferedReader(new InputStreamReader(u.openStream()));
            CSVReader reader = new CSVReader(in, '|');
            List<String[]> genemap = reader.readAll();
            for (String[] genes : genemap) {
                Disease d = new Disease(genes[7], genes[9]);
                d.setLocation(genes[4]);
                genotypes.put(d.getOmimId(), d);
                String[] genelist = genes[5].split(", ");
                d.getGenes().addAll(Arrays.asList(genelist));
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][OMIM] Unable to load genotype information from OMIM");
                Logger.getLogger(OMIMPlugin.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;

    }

    /**
     * Loads phenotype information from OMIM morbid into internal memory.
     *
     * @return success of the operation.
     */
    private boolean loadPhenotype() {
        boolean success = false;
        try {
            //URL u = new URL("ftp://ftp.ncbi.nih.gov/repository/OMIM/ARCHIVE/morbidmap");            
            URL u = new URL("http://localhost/~pedrolopes/omim/morbidmap_small");
            BufferedReader in = new BufferedReader(new InputStreamReader(u.openStream()));
            CSVReader reader = new CSVReader(in, '|');
            List<String[]> morbidmap = reader.readAll();
            Pattern p = Pattern.compile("[0-9]{6}");

            for (String[] disease : morbidmap) {
                Disease d;
                Matcher m = p.matcher(disease[0]);
                String pheno_omim = "";
                String dis_name = "";

                try {
                    if (m.find()) {
                        pheno_omim = m.group(0);
                        dis_name = disease[0].substring(0, disease[0].length() - 14);

                        // check if disease is already on list
                        if (diseases.containsKey(pheno_omim)) {
                            d = diseases.get(pheno_omim);
                            d.getNames().add(dis_name);
                            Disease genotype = genotypes.get(disease[2]);
                            if (!d.getGenotypes().contains(genotype)) {
                                d.getGenotypes().add(genotype);
                            }
                            if (!genotype.getPhenotypes().contains(d)) {
                                genotype.getPhenotypes().add(d);
                            }
                            String[] genelist = disease[1].split(", ");
                            d.getGenes().addAll(Arrays.asList(genelist));
                        } else {
                            d = new Disease(dis_name, pheno_omim);
                            d.setLocation(disease[3]);
                            d.getNames().add(dis_name);
                            diseases.put(pheno_omim, d);
                            Disease genotype = genotypes.get(disease[2]);
                            if (!d.getGenotypes().contains(genotype)) {
                                d.getGenotypes().add(genotype);
                            }
                            if (!genotype.getPhenotypes().contains(d)) {
                                genotype.getPhenotypes().add(d);
                            }
                            String[] genelist = disease[1].split(", ");
                            d.getGenes().addAll(Arrays.asList(genelist));
                        }
                        // not a phenotype, add to only genotypes list
                    } else {
                        Disease genotype = genotypes.get(disease[2]);
                        d = new Disease(disease[0], genotype.getOmimId());
                        d.getNames().add(disease[0]);
                        d.setLocation(disease[3]);
                        if (!d.getGenotypes().contains(genotype)) {
                            d.getGenotypes().add(genotype);
                        }
                        if (!genotype.getPhenotypes().contains(d)) {
                            genotype.getPhenotypes().add(d);
                        }
                        diseases.put(d.getOmimId(), d);
                    }
                } catch (Exception ex) {
                    if (Config.isDebug()) {
                        System.out.println("[COEUS][OMIM] Unable to load phenotype information from OMIM for " + disease[0]);
                        Logger.getLogger(OMIMPlugin.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
            success = true;
        } catch (Exception ex) {
            if (Config.isDebug()) {
                System.out.println("[COEUS][OMIM] Unable to load phenotype information from OMIM");
                Logger.getLogger(OMIMPlugin.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return success;
    }

    /**
     * Loads the in-memory data into COEUS SDB.
     * <p><b>Workflow</b><br /><ul>
     *  <li>Loads genotypes</li>
     *  <li>Loads genes for each genotype</li>     
     *  <li>Loads genotypes for each genotype</li>
     *  <li>Loads genes for each phenotype</li>
     * </ul></p>
     *
     */
    public void triplify() {
        for (Disease genotype : genotypes.values()) {
            if (!genotype.getOmimId().equals("")) {
                try {
                    String[] itemTmp = res.getIsResourceOf().getLabel().split("_");
                    com.hp.hpl.jena.rdf.model.Resource geno_item = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + itemTmp[1] + "_" + genotype.getOmimId());
                    com.hp.hpl.jena.rdf.model.Resource geno_obj = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "Item");
                    api.addStatement(geno_item, Predicate.get("rdf:type"), geno_obj);

                    // set Item label
                    api.addStatement(geno_item, Predicate.get("rdfs:label"), api.createResource("item_" + genotype.getOmimId()));

                    // associate Item with Concept
                    com.hp.hpl.jena.rdf.model.Resource con = api.getResource(res.getIsResourceOf().getUri());
                    api.addStatement(geno_item, Predicate.get("coeus:hasConcept"), con);
                    api.addStatement(con, Predicate.get("coeus:isConceptOf"), geno_item);

                    // add name/comment
                    api.addStatement(geno_item, Predicate.get("rdfs:comment"), genotype.getName());
                    api.addStatement(geno_item, Predicate.get("dc:description"), genotype.getName());
                    for (String name : genotype.getNames()) {
                        api.addStatement(geno_item, Predicate.get("diseasecard:name"), name);
                    }

                    api.addStatement(geno_item, Predicate.get("diseasecard:omim"), genotype.getOmimId());
                    api.addStatement(geno_item, Predicate.get("diseasecard:chromosomalLocation"), genotype.getLocation());

                    triplifyGenes(genotype.getGenes(), geno_item);

                    for (Disease phenotype : genotype.getPhenotypes()) {
                        com.hp.hpl.jena.rdf.model.Resource pheno_item = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + itemTmp[1] + "_" + phenotype.getOmimId());
                        com.hp.hpl.jena.rdf.model.Resource pheno_obj = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "Item");
                        api.addStatement(pheno_item, Predicate.get("rdf:type"), pheno_obj);

                        // set Item label
                        api.addStatement(pheno_item, Predicate.get("rdfs:label"), api.createResource("item_" + phenotype.getOmimId()));

                        // associate Item with Concept
                        com.hp.hpl.jena.rdf.model.Resource pheno_concept = api.getResource(res.getIsResourceOf().getUri());
                        api.addStatement(pheno_item, Predicate.get("coeus:hasConcept"), pheno_concept);
                        api.addStatement(pheno_concept, Predicate.get("coeus:isConceptOf"), pheno_item);

                        // add name/comment
                        api.addStatement(pheno_item, Predicate.get("rdfs:comment"), phenotype.getName());
                        api.addStatement(pheno_item, Predicate.get("dc:description"), phenotype.getName());
                        for (String name : phenotype.getNames()) {
                            api.addStatement(pheno_item, Predicate.get("diseasecard:name"), name);
                        }
                        api.addStatement(pheno_item, Predicate.get("diseasecard:omim"), phenotype.getOmimId());
                        api.addStatement(pheno_item, Predicate.get("diseasecard:chromosomalLocation"), phenotype.getLocation());

                        //add diseasecard-specific info
                        api.addStatement(pheno_item, Predicate.get("diseasecard:phenotype"), "true");
                        api.addStatement(pheno_item, Predicate.get("diseasecard:hasGenotype"), geno_item);
                        api.addStatement(geno_item, Predicate.get("diseasecard:hasPhenotype"), pheno_item);

                        triplifyGenes(phenotype.getGenes(), pheno_item);
                    }

                    api.addStatement(geno_item, Predicate.get("diseasecard:genotype"), "true");
                } catch (Exception ex) {
                    if (Config.isDebug()) {
                        System.out.println("[COEUS][OMIM] Unable to triplify inmemory data");
                        Logger.getLogger(OMIMPlugin.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        }
    }

    /**
     * Handles gene writing into COEUS SDB.
     *
     * @param genes the list of genes to insert.
     * @param item the item where the genes will be associated (coeus:isAssociatedTo).
     */
    private void triplifyGenes(ArrayList<String> genes, com.hp.hpl.jena.rdf.model.Resource item) {
        for (String gene : genes) {
            try {
                com.hp.hpl.jena.rdf.model.Resource gene_item = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "hgnc_" + gene);
                com.hp.hpl.jena.rdf.model.Resource gene_obj = api.createResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "Item");
                api.addStatement(gene_item, Predicate.get("rdf:type"), gene_obj);

                // set Item label
                api.addStatement(gene_item, Predicate.get("rdfs:label"), api.createResource("item_" + gene));

                // set Item title
                api.addStatement(gene_item, Predicate.get("dc:title"), gene.toUpperCase());

                // associate Item with Concept
                com.hp.hpl.jena.rdf.model.Resource gene_concept = api.getResource(PrefixFactory.getURIForPrefix(Config.getKeyPrefix()) + "concept_HGNC");
                api.addStatement(gene_item, Predicate.get("coeus:hasConcept"), gene_concept);
                api.addStatement(gene_concept, Predicate.get("coeus:isConceptOf"), gene_item);
                api.addStatement(gene_item, Predicate.get("coeus:isAssociatedTo"), item);
                api.addStatement(item, Predicate.get("coeus:isAssociatedTo"), gene_item);

            } catch (Exception ex) {
                if (Config.isDebug()) {
                    System.out.println("[COEUS][OMIM] Unable to triplify gene information");
                    Logger.getLogger(OMIMPlugin.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
}
