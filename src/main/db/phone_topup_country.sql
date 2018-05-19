CREATE DATABASE  IF NOT EXISTS `genericappdb` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `genericappdb`;
-- MySQL dump 10.13  Distrib 5.6.19, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: genericappdb
-- ------------------------------------------------------
-- Server version	5.6.20-enterprise-commercial-advanced

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `phone_topup_country`
--

DROP TABLE IF EXISTS `phone_topup_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `phone_topup_country` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(255) NOT NULL,
  `ISO` varchar(255) NOT NULL,
  `PHONE_CODE` varchar(255) NOT NULL,
  `AVAILABLE_IN_DING` bit(1) NOT NULL,
  `AVAILABLE_IN_MOBITOPUP` bit(1) NOT NULL,
  `MOBITOPUP_COUNTRY_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_topup_country`
--

LOCK TABLES `phone_topup_country` WRITE;
/*!40000 ALTER TABLE `phone_topup_country` DISABLE KEYS */;
INSERT INTO `phone_topup_country` VALUES (1,'Afghanistan','AF','93','','',1),(2,'Albania','AL','355','','',129),(3,'Anguilla','AI','1264','','',2),(4,'Antigua','AG','1268','','\0',NULL),(5,'Argentina','AR','54','','\0',NULL),(6,'Armenia','AM','374','','',99),(7,'Aruba','AW','297','','',101),(8,'Bangladesh','BD','880','','',4),(9,'Barbados','BB','1246','','',7),(10,'Belarus','BY','375','','\0',NULL),(11,'Belize','BZ','501','','\0',NULL),(12,'Benin','BJ','229','','',8),(13,'Bermuda','BM','1441','','\0',NULL),(14,'Bhutan','BT','975','','\0',NULL),(15,'Bolivia','BO','591','','',9),(16,'Bonaire','AN','599','','\0',NULL),(17,'Brazil','BR','55','','',10),(18,'British Virgin Islands','VG','1284','','',11),(19,'Burundi','BI','257','','',79),(20,'Cambodia','KH','855','','',80),(21,'Cameroon','CM','237','','',12),(22,'Cayman Islands','KY','1345','','',13),(23,'Central African Republic','CF','236','','',17),(24,'China','CN','86','','',19),(25,'Colombia','CO','57','','',20),(26,'Costa Rica','CR','506','','',81),(27,'Cuba','CU','53','','',22),(28,'Curacao','CW','599','','\0',NULL),(29,'Cyprus','CY','357','','',83),(30,'Democratic Republic of the Congo','CD','243','','\0',NULL),(31,'Dominica','DM','1767','','',23),(32,'Dominican Republic','DO','18','','',78),(33,'Ecuador','EC','593','','',24),(34,'Egypt','EG','20','','',25),(35,'El Salvador','SV','503','','',26),(36,'Estonia','EE','372','','\0',NULL),(37,'Fiji','FJ','679','','',28),(38,'French Guiana','GF','594','','\0',NULL),(39,'Gabon','GA','241','','\0',NULL),(40,'Gambia','GM','220','','',125),(41,'Georgia','GE','995','','\0',NULL),(42,'Germany','DE','49','','\0',NULL),(43,'Ghana','GH','233','','',29),(44,'Grenada','GD','1473','','',30),(45,'Guadeloupe','GP','590','','\0',NULL),(46,'Guatemala','GT','502','','',31),(47,'Guinea','GN','224','','',109),(48,'Guinea Bissau','GW','245','','',84),(49,'Guyana','GY','592','','',32),(50,'Haiti','HT','509','','',33),(51,'Honduras','HN','504','','',34),(52,'India','IN','91','','',35),(53,'Indonesia','ID','62','','',36),(54,'Ivory Coast','CI','225','','',38),(55,'Jamaica','JM','1876','','',39),(56,'Kenya','KE','254','','',42),(57,'Kuwait','KW','965','','\0',NULL),(58,'Laos','LA','856','','',43),(59,'Liberia','LR','231','','',85),(60,'Lithuania','LT','370','','\0',NULL),(61,'Madagascar','MG','261','','',44),(62,'Malaysia','MY','60','','',45),(63,'Mali','ML','223','','',46),(64,'Martinique','MQ','596','','\0',NULL),(65,'Mexico','MX','52','','',47),(66,'Moldova','MD','373','','\0',NULL),(67,'Montserrat','MS','1664','','',48),(68,'Morocco','MA','212','','',49),(69,'Nauru','NR','674','','\0',NULL),(70,'Nepal','NP','977','','',51),(71,'Nicaragua','NI','505','','',52),(72,'Niger','NE','227','','',53),(73,'Nigeria','NG','234','','',54),(74,'Pakistan','PK','92','','',55),(75,'Palestine','PS','972','','',56),(76,'Panama','PA','507','','',57),(77,'Paraguay','PY','595','','',115),(78,'Peru','PE','51','','',58),(79,'Philippines','PH','63','','',59),(80,'Poland','PL','48','','',60),(81,'Puerto Rico','PR','1','','\0',NULL),(82,'Republic of the Congo','CG','242','','\0',NULL),(83,'Romania','RO','407','','',90),(84,'Russia','RU','7','','',16),(85,'Rwanda','RW','250','','',89),(86,'Senegal','SN','221','','',61),(87,'Serbia','RS','381','','\0',NULL),(88,'Somalia','SO','252','','',91),(89,'Somaliland','SO','252','','\0',NULL),(90,'Spain','ES','34','','',94),(91,'Sri Lanka','LK','94','','',62),(92,'St. Kitts','KN','1869','','\0',NULL),(93,'St. Lucia','LC','1758','','\0',NULL),(94,'St. Vincent','VC','1784','','\0',NULL),(95,'Sudan','SD','249','','',63),(96,'Suriname','SR','597','','',64),(97,'Swaziland','SZ','268','','',119),(98,'Syria','SY','963','','',65),(99,'Tanzania','TZ','255','','',66),(100,'Tonga','TO','676','','\0',NULL),(101,'Trinidad and Tobago','TT','1868','','',121),(102,'Tunisia','TN','216','','',68),(103,'Turks and Caicos','TC','1649','','',70),(104,'Uganda','UG','256','','',87),(105,'Ukraine','UA','380','','',5),(106,'United Kingdom','GB','44','','\0',NULL),(107,'United States','US','1','','\0',NULL),(108,'Uruguay','UY','598','','\0',NULL),(109,'Vanuatu','VU','678','','\0',NULL),(110,'Vietnam','VN','84','','',74),(111,'Yemen','YE','967','','',75),(112,'Zambia','ZM','260','','',98),(113,'Zimbabwe','ZW','263','','',88),(114,'Antigua and Barbuda','AG','1268','\0','',3),(115,'Burkina Faso','BF','226','\0','',123),(116,'Chile','CL','56','\0','',18),(117,'Congo','CG','242','\0','',21),(118,'Democratic Republic Congo','CD','243','\0','',82),(119,'France','FR','33','\0','',96),(120,'Iraq','IQ','964','\0','',37),(121,'Kazakhstan','KZ','7','\0','',41),(122,'Lebanon','LB','961','\0','',95),(123,'Mozambique','MZ','258','\0','',50),(124,'Netherlands Antilles','AN','599','\0','',131),(125,'Sierra Leone','SL','232','\0','',127),(126,'South Africa','ZA','27','\0','',97),(127,'St Lucia','LC','1758','\0','',77),(128,'St Vincent and Grenadines','VC','1784','\0','',76),(129,'Thailand','TH','66','\0','',67),(130,'Togo','TG','228','\0','',133),(131,'Turkey','TR','90','\0','',69),(132,'USA','US','1','\0','',72),(133,'Venezuela','VE','58','\0','',73);
/*!40000 ALTER TABLE `phone_topup_country` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-05-26 11:53:12
