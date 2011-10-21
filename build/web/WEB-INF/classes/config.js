{
    "config": {
        "name": "STREAM",
        "description": "COEUS",
        "keyprefix":"coeus",
        "version": "1.0a",
        "ontology": "http://bioinformatics.ua.pt/diseasecard/diseasecard.owl",
        "setup": "coeus_setup.rdf",
        "sdb":"coeus_sdb.ttl",
        "predicates":"coeus_predicates.csv",
        "built": true,
        "debug": false,
        "environment": "testing"
    },
    "prefixes" : {
        "coeus": "http://bioinformatics.ua.pt/coeus/",
        "owl2xml":"http://www.w3.org/2006/12/owl2-xml#",
        "xsd": "http://www.w3.org/2001/XMLSchema#",
        "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
        "owl": "http://www.w3.org/2002/07/owl#",
        "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "dc": "http://purl.org/dc/elements/1.1/",
        "dailymed":"http://www4.wiwiss.fu-berlin.de/dailymed/resource/dailymed/",
        "drugbank":"http://www4.wiwiss.fu-berlin.de/drugbank/resource/drugbank/",
        "d2r":"http://sites.wiwiss.fu-berlin.de/suhl/bizer/d2r-server/config.rdf#",
        "diseasecard":"http://bioinformatics.ua.pt/diseasecard/"
    }
}