# ************************************************************
# COEUS
# Semantic Web Application Framework
#
# Default triplestore database schema
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


USE coeus;

# Dump of table Nodes
# ------------------------------------------------------------

CREATE TABLE `Nodes` (
  `hash` bigint(20) NOT NULL DEFAULT '0',
  `lex` longtext CHARACTER SET utf8 COLLATE utf8_bin,
  `lang` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `datatype` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `type` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table Prefixes
# ------------------------------------------------------------

CREATE TABLE `Prefixes` (
  `prefix` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `uri` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table Quads
# ------------------------------------------------------------

CREATE TABLE `Quads` (
  `g` bigint(20) NOT NULL,
  `s` bigint(20) NOT NULL,
  `p` bigint(20) NOT NULL,
  `o` bigint(20) NOT NULL,
  PRIMARY KEY (`g`,`s`,`p`,`o`),
  KEY `SubjPredObj` (`s`,`p`,`o`),
  KEY `PredObjSubj` (`p`,`o`,`s`),
  KEY `ObjSubjPred` (`o`,`s`,`p`),
  KEY `GraPredObj` (`g`,`p`,`o`),
  KEY `GraObjSubj` (`g`,`o`,`s`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table triples
# ------------------------------------------------------------

CREATE TABLE `Triples` (
  `s` bigint(20) NOT NULL,
  `p` bigint(20) NOT NULL,
  `o` bigint(20) NOT NULL,
  PRIMARY KEY (`s`,`p`,`o`),
  KEY `ObjSubj` (`o`,`s`),
  KEY `PredObj` (`p`,`o`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
