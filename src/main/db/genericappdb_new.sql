CREATE DATABASE  IF NOT EXISTS `genericappdb_new` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `genericappdb_new`;
-- MySQL dump 10.13  Distrib 5.6.19, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: genericappdb_new
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
-- Table structure for table `calling_card_price`
--

DROP TABLE IF EXISTS `calling_card_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calling_card_price` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ACTIVE` bit(1) NOT NULL,
  `COUNTRY` varchar(255) NOT NULL,
  `CREATED_DATE` datetime NOT NULL,
  `LANDLINE_PRICE` float NOT NULL,
  `MOBILE_PRICE` float NOT NULL,
  `UPDATED_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calling_card_price`
--

LOCK TABLES `calling_card_price` WRITE;
/*!40000 ALTER TABLE `calling_card_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `calling_card_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_balance_report`
--

DROP TABLE IF EXISTS `customer_balance_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_balance_report` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `balance` decimal(19,2) NOT NULL,
  `day` date NOT NULL,
  `topup` decimal(19,2) NOT NULL,
  `customer_id` int(10) unsigned NOT NULL,
  `sales` decimal(19,2) NOT NULL,
  `transactions` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_poanv4yuut7gxdjxy97ieyw2o` (`customer_id`,`day`),
  CONSTRAINT `FK_3bggjke3ilu9434hlp6kruf4m` FOREIGN KEY (`customer_id`) REFERENCES `t_master_customerinfo` (`Customer_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=25835 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_balance_report`
--

LOCK TABLES `customer_balance_report` WRITE;
/*!40000 ALTER TABLE `customer_balance_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_balance_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_feature`
--

DROP TABLE IF EXISTS `customer_feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer_feature` (
  `FEATURE_ID` int(11) NOT NULL,
  `CUSTOMER_ID` int(10) unsigned NOT NULL,
  KEY `FK_jwid1aoo7j08j0dh1by8efeqc` (`CUSTOMER_ID`),
  KEY `FK_2sd929ooprmjdcmr4b9mfubhe` (`FEATURE_ID`),
  CONSTRAINT `FK_2sd929ooprmjdcmr4b9mfubhe` FOREIGN KEY (`FEATURE_ID`) REFERENCES `feature` (`ID`),
  CONSTRAINT `FK_jwid1aoo7j08j0dh1by8efeqc` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_feature`
--

LOCK TABLES `customer_feature` WRITE;
/*!40000 ALTER TABLE `customer_feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feature`
--

DROP TABLE IF EXISTS `feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feature` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ACTIVE` bit(1) NOT NULL,
  `TITLE` varchar(255) NOT NULL,
  `FEATURE_TYPE` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feature`
--

LOCK TABLES `feature` WRITE;
/*!40000 ALTER TABLE `feature` DISABLE KEYS */;
INSERT INTO `feature` VALUES (1,'','Calling Cards',0),(2,'','Mobile Vouchers',1),(3,'','Transfer-To',2),(4,'','Ding',3),(5,'','SIMS',4),(6,'','Bulk Upload',5),(7,'','Mobile Unlocking',6),(8,'','Pinless Calling Cards',7),(9,'','Credit Limit',8),(10,'','Print by confirm',9),(11,'','Mobitopup',10),(12,'','Local Mobile Vouchers',11),(13,'','EezeeTel Pinless',12);
/*!40000 ALTER TABLE `feature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_balance_report`
--

DROP TABLE IF EXISTS `group_balance_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_balance_report` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `balance` decimal(19,2) NOT NULL,
  `day` date NOT NULL,
  `sales` decimal(19,2) NOT NULL,
  `topup` decimal(19,2) NOT NULL,
  `transactions` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_iu6sgy6710atv67cu68qavkv3` (`group_id`,`day`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_balance_report`
--

LOCK TABLES `group_balance_report` WRITE;
/*!40000 ALTER TABLE `group_balance_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_balance_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_transaction_balance`
--

DROP TABLE IF EXISTS `group_transaction_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_transaction_balance` (
  `TRANSACTION_ID` bigint(20) NOT NULL,
  `BALANCE_AFTER` decimal(19,2) NOT NULL,
  `BALANCE_BEFORE` decimal(19,2) NOT NULL,
  PRIMARY KEY (`TRANSACTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_transaction_balance`
--

LOCK TABLES `group_transaction_balance` WRITE;
/*!40000 ALTER TABLE `group_transaction_balance` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_transaction_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mobile_unlocking`
--

DROP TABLE IF EXISTS `mobile_unlocking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_unlocking` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ACTIVE` bit(1) NOT NULL,
  `PURCHASE_PRICE` decimal(19,2) NOT NULL,
  `TITLE` varchar(255) NOT NULL,
  `SUPPLIER_ID` int(10) unsigned NOT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  `TRANSACTION_CONDITION` varchar(2550) DEFAULT NULL,
  `DELIVERY_TIME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_2ivoc6p6ix9oqnukm245y7naj` (`SUPPLIER_ID`),
  CONSTRAINT `FK_2ivoc6p6ix9oqnukm245y7naj` FOREIGN KEY (`SUPPLIER_ID`) REFERENCES `t_master_supplierinfo` (`Supplier_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobile_unlocking`
--

LOCK TABLES `mobile_unlocking` WRITE;
/*!40000 ALTER TABLE `mobile_unlocking` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobile_unlocking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mobile_unlocking_commission`
--

DROP TABLE IF EXISTS `mobile_unlocking_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_unlocking_commission` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `COMMISSION` decimal(19,2) NOT NULL,
  `CREATED_DATE` datetime NOT NULL,
  `UPDATED_DATE` datetime DEFAULT NULL,
  `GROUP_ID` int(10) unsigned NOT NULL,
  `MOBILE_UNLOCKING_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_tjk4d4c0hsfws6eacv9jtx33v` (`GROUP_ID`),
  KEY `FK_dl073ervu0a3kw8rqpfd8nhr7` (`MOBILE_UNLOCKING_ID`),
  CONSTRAINT `FK_dl073ervu0a3kw8rqpfd8nhr7` FOREIGN KEY (`MOBILE_UNLOCKING_ID`) REFERENCES `mobile_unlocking` (`ID`),
  CONSTRAINT `FK_tjk4d4c0hsfws6eacv9jtx33v` FOREIGN KEY (`GROUP_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=358 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobile_unlocking_commission`
--

LOCK TABLES `mobile_unlocking_commission` WRITE;
/*!40000 ALTER TABLE `mobile_unlocking_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobile_unlocking_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mobile_unlocking_customer_commission`
--

DROP TABLE IF EXISTS `mobile_unlocking_customer_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_unlocking_customer_commission` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `AGENT_COMMISSION` decimal(19,2) NOT NULL,
  `CREATED_DATE` datetime NOT NULL,
  `GROUP_COMMISSION` decimal(19,2) NOT NULL,
  `UPDATED_DATE` datetime DEFAULT NULL,
  `CUSTOMER_ID` int(10) unsigned NOT NULL,
  `MOBILE_UNLOCKING_COMMISSION_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `mobile_commission_uniqe_key` (`CUSTOMER_ID`,`MOBILE_UNLOCKING_COMMISSION_ID`),
  KEY `FK_hyy72b7dbrb11t5514grx3jbp` (`MOBILE_UNLOCKING_COMMISSION_ID`),
  CONSTRAINT `FK_5wsogdlkuaqn5wkbbmdajyyls` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_hyy72b7dbrb11t5514grx3jbp` FOREIGN KEY (`MOBILE_UNLOCKING_COMMISSION_ID`) REFERENCES `mobile_unlocking_commission` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16657 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobile_unlocking_customer_commission`
--

LOCK TABLES `mobile_unlocking_customer_commission` WRITE;
/*!40000 ALTER TABLE `mobile_unlocking_customer_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobile_unlocking_customer_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mobile_unlocking_order`
--

DROP TABLE IF EXISTS `mobile_unlocking_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobile_unlocking_order` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TRANSACTION_ID` bigint(20) NOT NULL,
  `IMEI` varchar(255) NOT NULL,
  `CODE` varchar(255) DEFAULT NULL,
  `CUSTOMER_EMAIL` varchar(255) DEFAULT NULL,
  `MOBILE_NUMBER` varchar(255) DEFAULT NULL,
  `STATUS` int(11) NOT NULL,
  `MOBILE_UNLOCKING_ID` int(11) NOT NULL,
  `CUSTOMER_ID` int(10) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `ASSIGNED_ID` varchar(50) DEFAULT NULL,
  `PRICE` decimal(19,2) NOT NULL,
  `EEZEETEL_COMMISSION` decimal(19,2) NOT NULL,
  `GROUP_COMMISSION` decimal(19,2) NOT NULL,
  `AGENT_COMMISSION` decimal(19,2) NOT NULL,
  `SELLING_PRICE` decimal(19,2) NOT NULL,
  `CREATED_DATE` datetime NOT NULL,
  `UPDATED_DATE` datetime DEFAULT NULL,
  `NOTES` varchar(255) DEFAULT NULL,
  `POST_PROCESSING_STAGE` bit(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_sabm5tsbg4inmsibrt8s799d8` (`ASSIGNED_ID`),
  KEY `FK_d4i7y001w9o1hwhx3oqfx0be1` (`MOBILE_UNLOCKING_ID`),
  KEY `FK_t8a595aqh8by9xwcpfpf81k93` (`USER_ID`),
  CONSTRAINT `FK_d4i7y001w9o1hwhx3oqfx0be1` FOREIGN KEY (`MOBILE_UNLOCKING_ID`) REFERENCES `mobile_unlocking` (`ID`),
  CONSTRAINT `FK_sabm5tsbg4inmsibrt8s799d8` FOREIGN KEY (`ASSIGNED_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t8a595aqh8by9xwcpfpf81k93` FOREIGN KEY (`USER_ID`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobile_unlocking_order`
--

LOCK TABLES `mobile_unlocking_order` WRITE;
/*!40000 ALTER TABLE `mobile_unlocking_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobile_unlocking_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mobitopup_transaction`
--

DROP TABLE IF EXISTS `mobitopup_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mobitopup_transaction` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `AUTH_KEY` varchar(255) NOT NULL,
  `ERROR_CODE` int(11) DEFAULT NULL,
  `ERROR_TEXT` varchar(255) DEFAULT NULL,
  `CUSTOMER_ID` int(10) unsigned NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `TRANSACTION_ID` bigint(20) NOT NULL,
  `TRANSACTION_TIME` datetime NOT NULL,
  `DESTINATION_PHONE` varchar(255) NOT NULL,
  `REQUESTER_PHONE` varchar(255) NOT NULL,
  `CURRENCY` varchar(255) DEFAULT NULL,
  `LOCAL_CURRENCY` varchar(255) DEFAULT NULL,
  `NETWORK` varchar(255) DEFAULT NULL,
  `NETWORK_ID` varchar(255) DEFAULT NULL,
  `BALANCE` decimal(19,2) DEFAULT NULL,
  `PRICE` decimal(19,2) DEFAULT NULL,
  `RETAIL_PRICE` decimal(19,2) DEFAULT NULL,
  `EEZEETEL_COMMISSION` decimal(19,2) DEFAULT NULL,
  `GROUP_COMMISSION` decimal(19,2) DEFAULT NULL,
  `AGENT_COMMISSION` decimal(19,2) DEFAULT NULL,
  `CUSTOMER_COMMISSION` decimal(19,2) DEFAULT NULL,
  `MESSAGE` varchar(255) DEFAULT NULL,
  `ORDER_ID` bigint(20) DEFAULT NULL,
  `PRODUCT_REQUESTED` varchar(255) NOT NULL,
  `PRODUCT_SENT` varchar(255) DEFAULT NULL,
  `RESPONSE` text,
  `SENDER_SMS` varchar(255) DEFAULT NULL,
  `SMS_SENT` varchar(255) DEFAULT NULL,
  `COUNTRY_ID` int(11) DEFAULT NULL,
  `POST_PROCESSING_STAGE` bit(1) DEFAULT NULL,
  `PINLESS` bit(1) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_e0je779vj9jy07j7ph78mgk9x` (`USER_ID`),
  KEY `FK_e0je779vj9jy07j7ph78mgk9y` (`CUSTOMER_ID`),
  KEY `FK_b4m2wv5upuiyt2rxfhhqfn2ot` (`COUNTRY_ID`),
  KEY `FK_77gmje7g58smfo76wue1donyj` (`TRANSACTION_ID`),
  CONSTRAINT `FK_77gmje7g58smfo76wue1donyj` FOREIGN KEY (`TRANSACTION_ID`) REFERENCES `group_transaction_balance` (`TRANSACTION_ID`),
  CONSTRAINT `FK_b4m2wv5upuiyt2rxfhhqfn2ot` FOREIGN KEY (`COUNTRY_ID`) REFERENCES `phone_topup_country` (`ID`),
  CONSTRAINT `FK_e0je779vj9jy07j7ph78mgk9x` FOREIGN KEY (`USER_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_e0je779vj9jy07j7ph78mgk9y` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=521 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobitopup_transaction`
--

LOCK TABLES `mobitopup_transaction` WRITE;
/*!40000 ALTER TABLE `mobitopup_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobitopup_transaction` ENABLE KEYS */;
UNLOCK TABLES;

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
/*!40000 ALTER TABLE `phone_topup_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pinless_customer_commission`
--

DROP TABLE IF EXISTS `pinless_customer_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pinless_customer_commission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_percent` int(11) NOT NULL DEFAULT '0',
  `group_percent` int(11) NOT NULL DEFAULT '5',
  `customer_id` int(10) unsigned NOT NULL,
  `group_commission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_1xvuy2dw2rbl4oixk0stov4e5` (`customer_id`),
  KEY `FK_hatjgjh2wfbqqbh62o414dsvf` (`group_commission_id`),
  CONSTRAINT `FK_1xvuy2dw2rbl4oixk0stov4e5` FOREIGN KEY (`customer_id`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_hatjgjh2wfbqqbh62o414dsvf` FOREIGN KEY (`group_commission_id`) REFERENCES `pinless_group_commission` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pinless_customer_commission`
--

LOCK TABLES `pinless_customer_commission` WRITE;
/*!40000 ALTER TABLE `pinless_customer_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `pinless_customer_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pinless_group_commission`
--

DROP TABLE IF EXISTS `pinless_group_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pinless_group_commission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `percent` int(11) NOT NULL DEFAULT '3',
  `group_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_mytmnr9kf3wni7cvw28dr2msf` (`group_id`),
  CONSTRAINT `FK_mytmnr9kf3wni7cvw28dr2msf` FOREIGN KEY (`group_id`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pinless_group_commission`
--

LOCK TABLES `pinless_group_commission` WRITE;
/*!40000 ALTER TABLE `pinless_group_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `pinless_group_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pinless_transaction`
--

DROP TABLE IF EXISTS `pinless_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pinless_transaction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auth_key` varchar(255) NOT NULL,
  `error_code` int(11) DEFAULT NULL,
  `error_text` varchar(255) DEFAULT NULL,
  `customer_id` int(10) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `transaction_id` bigint(20) NOT NULL,
  `transaction_time` datetime NOT NULL,
  `destination_phone` varchar(255) NOT NULL,
  `requester_phone` varchar(255) NOT NULL,
  `currency` varchar(255) DEFAULT NULL,
  `local_currency` varchar(255) DEFAULT NULL,
  `network` varchar(255) DEFAULT NULL,
  `network_id` varchar(255) DEFAULT NULL,
  `balance` decimal(19,2) DEFAULT NULL,
  `price` decimal(19,2) DEFAULT NULL,
  `retail_price` decimal(19,2) DEFAULT NULL,
  `eezeetel_commission` decimal(19,2) DEFAULT NULL,
  `group_commission` decimal(19,2) DEFAULT NULL,
  `agent_commission` decimal(19,2) DEFAULT NULL,
  `customer_commission` decimal(19,2) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  `post_processing_stage` bit(1) DEFAULT NULL,
  `product_requested` varchar(255) NOT NULL,
  `product_sent` varchar(255) DEFAULT NULL,
  `response` text,
  `sender_sms` varchar(255) DEFAULT NULL,
  `sms_sent` varchar(255) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_egvm3u386m0wenuww1q8fjkip` (`country_id`),
  KEY `FK_lbij6y6jrt51vl8556h0uawy9` (`transaction_id`),
  CONSTRAINT `FK_egvm3u386m0wenuww1q8fjkip` FOREIGN KEY (`country_id`) REFERENCES `phone_topup_country` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pinless_transaction`
--

LOCK TABLES `pinless_transaction` WRITE;
/*!40000 ALTER TABLE `pinless_transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `pinless_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_log`
--

DROP TABLE IF EXISTS `request_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `request_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `hex` varchar(255) NOT NULL,
  `request_key` bigint(20) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_jxgdi6fufsf6e294936t7irvy` (`user_id`,`request_key`),
  CONSTRAINT `FK_5wgnk62j6xtsteuqfvutel7jc` FOREIGN KEY (`user_id`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_log`
--

LOCK TABLES `request_log` WRITE;
/*!40000 ALTER TABLE `request_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `request_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setting`
--

DROP TABLE IF EXISTS `setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `setting` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TYPE` int(11) NOT NULL,
  `VALUE` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UK_jg81nrednlnh6grjah7k4scxu` (`TYPE`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setting`
--

LOCK TABLES `setting` WRITE;
/*!40000 ALTER TABLE `setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_agent_commission`
--

DROP TABLE IF EXISTS `t_agent_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_agent_commission` (
  `Agent_ID` varchar(50) NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL DEFAULT '0',
  `CommissionType` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'True - Percentage basis.  False - Real Value',
  `Commission` float unsigned NOT NULL,
  `Active_Status` tinyint(3) unsigned NOT NULL,
  `Created_By` varchar(50) NOT NULL,
  `Creation_Time` datetime NOT NULL,
  `Last_Modified_Time` datetime NOT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Agent_ID`,`Product_ID`) USING BTREE,
  KEY `FK_t_agent_commission_3` (`Created_By`),
  KEY `FK_t_agent_commission_2` (`Product_ID`),
  CONSTRAINT `FK_t_agent_commission_1` FOREIGN KEY (`Created_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_agent_commission_2` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_agent_commission`
--

LOCK TABLES `t_agent_commission` WRITE;
/*!40000 ALTER TABLE `t_agent_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_agent_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_b2c_customer_credit`
--

DROP TABLE IF EXISTS `t_b2c_customer_credit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_b2c_customer_credit` (
  `Credit_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Credit_ID_Status` tinyint(4) NOT NULL,
  `Credit_or_Debit` tinyint(4) NOT NULL,
  `Mobile_Phone` varchar(255) NOT NULL,
  `Notes` varchar(255) DEFAULT NULL,
  `Payment_Amount` float NOT NULL,
  `Payment_Date` datetime DEFAULT NULL,
  `Payment_Details` varchar(255) DEFAULT NULL,
  `Payment_Type` tinyint(4) NOT NULL,
  `Email_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Credit_ID`),
  KEY `FK_kk92pjkyd8ojp1rfotigl13da` (`Email_ID`),
  CONSTRAINT `FK_kk92pjkyd8ojp1rfotigl13da` FOREIGN KEY (`Email_ID`) REFERENCES `t_master_b2c_users` (`EMail_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_b2c_customer_credit`
--

LOCK TABLES `t_b2c_customer_credit` WRITE;
/*!40000 ALTER TABLE `t_b2c_customer_credit` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_b2c_customer_credit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_b2c_transactions`
--

DROP TABLE IF EXISTS `t_b2c_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_b2c_transactions` (
  `Sequence_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `Agent_Price` float NOT NULL,
  `Batch_Sequence_ID` int(11) NOT NULL,
  `Batch_Unit_Price` float NOT NULL,
  `Committed` tinyint(4) NOT NULL,
  `Mobile_Phone` varchar(255) NOT NULL,
  `Post_Processing_Stage` tinyint(4) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Transaction_ID` bigint(20) NOT NULL,
  `Transaction_Time` datetime NOT NULL,
  `Unit_Group_Price` float NOT NULL,
  `Unit_Purchase_Price` float NOT NULL,
  `Email_ID` varchar(255) NOT NULL,
  `Product_ID` int(11) NOT NULL,
  PRIMARY KEY (`Sequence_ID`),
  KEY `FK_eq5hnv87sd1cq7cruhxwdwjff` (`Email_ID`),
  CONSTRAINT `FK_eq5hnv87sd1cq7cruhxwdwjff` FOREIGN KEY (`Email_ID`) REFERENCES `t_master_b2c_users` (`EMail_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_b2c_transactions`
--

LOCK TABLES `t_b2c_transactions` WRITE;
/*!40000 ALTER TABLE `t_b2c_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_b2c_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_batch_information`
--

DROP TABLE IF EXISTS `t_batch_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_batch_information` (
  `SequenceID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Batch_ID` varchar(50) NOT NULL,
  `Supplier_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `Sale_Info_ID` int(10) unsigned NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `Available_Quantity` int(10) unsigned NOT NULL DEFAULT '0',
  `Unit_Purchase_Price` float unsigned NOT NULL,
  `Batch_Arrival_Date` date NOT NULL,
  `Batch_Expiry_Date` date NOT NULL,
  `Batch_Entry_Time` datetime NOT NULL,
  `Batch_Created_By` varchar(50) NOT NULL,
  `Batch_Activated_By_Supplier` tinyint(3) unsigned NOT NULL,
  `Batch_Ready_To_Sell` tinyint(3) unsigned NOT NULL,
  `IsBatchActive` tinyint(3) unsigned NOT NULL,
  `Additional_Info` varchar(50) DEFAULT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `Batch_File_Path` varchar(512) NOT NULL,
  `Batch_Upload_Status` varchar(50) DEFAULT NULL,
  `LastModifiedTime` datetime NOT NULL,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  `Probable_Sale_Price` float unsigned DEFAULT '0',
  `Batch_Cost` float unsigned NOT NULL DEFAULT '0',
  `Paid_To_Supplier` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Payment_Date_To_Supplier` datetime DEFAULT NULL,
  `Last_Touch_Time` datetime DEFAULT NULL,
  PRIMARY KEY (`SequenceID`),
  KEY `FK_t_batch_information_1` (`Product_ID`),
  KEY `FK_t_batch_information_2` (`Batch_Created_By`),
  KEY `FK_t_batch_information_3` (`Sale_Info_ID`),
  KEY `FK_t_batch_information_4` (`Supplier_ID`),
  CONSTRAINT `FK_t_batch_information_1` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`),
  CONSTRAINT `FK_t_batch_information_2` FOREIGN KEY (`Batch_Created_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_batch_information_3` FOREIGN KEY (`Sale_Info_ID`) REFERENCES `t_master_productsaleinfo` (`Sale_Info_ID`),
  CONSTRAINT `FK_t_batch_information_4` FOREIGN KEY (`Supplier_ID`) REFERENCES `t_master_supplierinfo` (`Supplier_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23799 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_batch_information`
--

LOCK TABLES `t_batch_information` WRITE;
/*!40000 ALTER TABLE `t_batch_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_batch_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_card_info`
--

DROP TABLE IF EXISTS `t_card_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_card_info` (
  `SequenceID` bigint(100) unsigned NOT NULL AUTO_INCREMENT,
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `card_id` varchar(20) NOT NULL,
  `card_pin` varchar(20) NOT NULL,
  `Transaction_ID` bigint(100) unsigned DEFAULT NULL,
  `IsSold` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`SequenceID`),
  UNIQUE KEY `Unique_Value` (`Product_ID`,`card_id`,`card_pin`),
  KEY `FK_t_card_info_1` (`Batch_Sequence_ID`),
  KEY `FK_t_card_info_transaction_id` (`Transaction_ID`),
  CONSTRAINT `FK_t_card_info_1` FOREIGN KEY (`Batch_Sequence_ID`) REFERENCES `t_batch_information` (`SequenceID`),
  CONSTRAINT `FK_t_card_info_2` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4798493 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_card_info`
--

LOCK TABLES `t_card_info` WRITE;
/*!40000 ALTER TABLE `t_card_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_card_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_credit_requests`
--

DROP TABLE IF EXISTS `t_credit_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_credit_requests` (
  `Request_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Request_Type` tinyint(3) unsigned NOT NULL COMMENT '1 - Credit, 2 - Pay Debt',
  `Customer_ID` int(10) unsigned NOT NULL,
  `Request_Date` datetime NOT NULL,
  `Request_Amount` float unsigned NOT NULL,
  `Amount_Already_Paid` tinyint(3) unsigned NOT NULL,
  `Payment_Type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Bank_ID` int(10) unsigned NOT NULL DEFAULT '1',
  `Payment_Date` datetime DEFAULT NULL,
  `Requested_By` varchar(50) NOT NULL,
  `Request_Details` varchar(100) NOT NULL,
  `Approved_Amount` float unsigned DEFAULT NULL,
  `Approved_By` varchar(50) DEFAULT NULL,
  `Approval_Date` datetime DEFAULT NULL,
  `Approver_Comments` varchar(100) DEFAULT '',
  `Request_Status` tinyint(3) unsigned NOT NULL COMMENT '1 - Submitted, 2 - Approved, 3 - Partial Approved, 4 - Pending Approval, 5 - Rejected, 6 - Adjusted To Previous Debt',
  `Credit_ID_List` varchar(100) DEFAULT '',
  `Agent_Approved` tinyint(3) unsigned DEFAULT NULL COMMENT '2 - Approved, 3 - Partial Approved, 5 - Rejected',
  `Agent_Approved_Amount` float unsigned DEFAULT NULL,
  `Agent_Comments` varchar(100) DEFAULT NULL,
  `Agent_Approved_Time` datetime DEFAULT NULL,
  `Agent_Name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Request_ID`),
  KEY `FK_t_credit_requests_1` (`Requested_By`),
  KEY `FK_t_credit_requests_2` (`Approved_By`),
  KEY `FK_t_credit_requests_3` (`Customer_ID`),
  KEY `FK_t_credit_requests_4` (`Bank_ID`),
  CONSTRAINT `FK_t_credit_requests_1` FOREIGN KEY (`Requested_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_credit_requests_3` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_credit_requests_4` FOREIGN KEY (`Bank_ID`) REFERENCES `t_master_banks` (`Sequence_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=96877 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_credit_requests`
--

LOCK TABLES `t_credit_requests` WRITE;
/*!40000 ALTER TABLE `t_credit_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_credit_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_customer_commission`
--

DROP TABLE IF EXISTS `t_customer_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_customer_commission` (
  `Customer_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `CommissionType` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'True - Percentage basis.  False - Real Value',
  `Commission` float NOT NULL,
  `Active_Status` tinyint(3) unsigned NOT NULL,
  `Created_By` varchar(50) NOT NULL,
  `Creation_Time` datetime NOT NULL,
  `Last_Modified_Time` datetime NOT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  `Agent_Commission` float unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Customer_ID`,`Product_ID`),
  KEY `FK_t_customer_commission_2` (`Product_ID`),
  KEY `FK_t_customer_commission_3` (`Created_By`),
  CONSTRAINT `FK_t_customer_commission_1` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_customer_commission_2` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`),
  CONSTRAINT `FK_t_customer_commission_3` FOREIGN KEY (`Created_By`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_customer_commission`
--

LOCK TABLES `t_customer_commission` WRITE;
/*!40000 ALTER TABLE `t_customer_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_customer_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_customer_group_commissions`
--

DROP TABLE IF EXISTS `t_customer_group_commissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_customer_group_commissions` (
  `Customer_Group_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `CommissionType` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'True - Percentage basis.  False - Real Value',
  `Commission` float NOT NULL,
  `Active_Status` tinyint(3) unsigned NOT NULL,
  `Created_By` varchar(50) NOT NULL,
  `Creation_Time` datetime NOT NULL,
  `Last_Modified_Time` datetime NOT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Customer_Group_ID`,`Product_ID`),
  KEY `forigen_key_1` (`Product_ID`),
  KEY `foreign_key_2` (`Customer_Group_ID`),
  CONSTRAINT `foreign_key_2` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `forigen_key_1` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_customer_group_commissions`
--

LOCK TABLES `t_customer_group_commissions` WRITE;
/*!40000 ALTER TABLE `t_customer_group_commissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_customer_group_commissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_customer_users`
--

DROP TABLE IF EXISTS `t_customer_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_customer_users` (
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_Login_ID` varchar(50) NOT NULL,
  `Description` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Customer_ID`,`User_Login_ID`),
  KEY `FK_t_customer_users_2` (`User_Login_ID`),
  CONSTRAINT `FK_t_customer_users_1` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_customer_users_2` FOREIGN KEY (`User_Login_ID`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_customer_users`
--

LOCK TABLES `t_customer_users` WRITE;
/*!40000 ALTER TABLE `t_customer_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_customer_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_dialy_batch_log`
--

DROP TABLE IF EXISTS `t_dialy_batch_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_dialy_batch_log` (
  `Log_Date` datetime NOT NULL,
  `Batch_Sequence_ID` int(11) NOT NULL,
  `Available_Quantity` int(11) NOT NULL,
  PRIMARY KEY (`Log_Date`,`Batch_Sequence_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_dialy_batch_log`
--

LOCK TABLES `t_dialy_batch_log` WRITE;
/*!40000 ALTER TABLE `t_dialy_batch_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_dialy_batch_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_ding_transactions`
--

DROP TABLE IF EXISTS `t_ding_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_ding_transactions` (
  `Sequence_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Transaction_ID` bigint(20) unsigned NOT NULL,
  `Ding_Transaction_ID` bigint(20) unsigned NOT NULL,
  `Error_Code` int(10) unsigned NOT NULL,
  `Error_Text` varchar(100) NOT NULL,
  `Requester_Phone` varchar(50) DEFAULT NULL,
  `Destination_Phone` varchar(16) NOT NULL,
  `Originating_Currency` varchar(10) DEFAULT NULL,
  `Destination_Currency` varchar(10) DEFAULT NULL,
  `Destination_Country` varchar(50) DEFAULT NULL,
  `Destination_Country_ID` varchar(5) DEFAULT NULL,
  `Destination_Operator` varchar(50) DEFAULT NULL,
  `Destination_Operator_ID` varchar(50) DEFAULT NULL,
  `Operator_Reference_Info` varchar(100) DEFAULT NULL,
  `SMS_Sent` varchar(5) NOT NULL,
  `SMS_Text` varchar(100) DEFAULT NULL,
  `Authentication_Key` varchar(50) DEFAULT NULL,
  `CID1` varchar(50) DEFAULT NULL,
  `CID2` varchar(50) DEFAULT NULL,
  `CID3` varchar(50) DEFAULT NULL,
  `Product_Requested` float unsigned NOT NULL,
  `Product_Sent` float unsigned NOT NULL,
  `Wholesale_Price` float unsigned DEFAULT NULL,
  `Retail_Price` float unsigned DEFAULT NULL,
  `EezeeTel_Balance` float unsigned NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Transaction_Time` datetime NOT NULL,
  `Transaction_Status` tinyint(3) unsigned NOT NULL,
  `Cost_To_Customer` float unsigned NOT NULL,
  `Cost_To_Agent` float unsigned NOT NULL,
  `Cost_To_EezeeTel` float unsigned NOT NULL,
  `Cost_To_Group` float unsigned NOT NULL,
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Sequence_ID`),
  KEY `fk_customerinfo_idx` (`Customer_ID`),
  KEY `fk_usersinfo_idx` (`User_ID`),
  KEY `FK_b62xv7qnb67sft0esd6bt7mie` (`Transaction_ID`),
  CONSTRAINT `fk_customerinfo` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usersinfo` FOREIGN KEY (`User_ID`) REFERENCES `t_master_users` (`User_Login_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=34356 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_ding_transactions`
--

LOCK TABLES `t_ding_transactions` WRITE;
/*!40000 ALTER TABLE `t_ding_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_ding_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_expense_types`
--

DROP TABLE IF EXISTS `t_expense_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_expense_types` (
  `Expense_Type_ID` tinyint(4) NOT NULL AUTO_INCREMENT,
  `Expense_Type` varchar(50) NOT NULL,
  `IsActive` tinyint(4) NOT NULL,
  PRIMARY KEY (`Expense_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_expense_types`
--

LOCK TABLES `t_expense_types` WRITE;
/*!40000 ALTER TABLE `t_expense_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_expense_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_batch_information`
--

DROP TABLE IF EXISTS `t_history_batch_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_batch_information` (
  `SequenceID` int(10) unsigned NOT NULL DEFAULT '0',
  `Batch_ID` varchar(50) NOT NULL,
  `Supplier_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `Sale_Info_ID` int(10) unsigned NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `Available_Quantity` int(10) unsigned NOT NULL DEFAULT '0',
  `Unit_Purchase_Price` float unsigned NOT NULL,
  `Batch_Arrival_Date` date NOT NULL,
  `Batch_Expiry_Date` date NOT NULL,
  `Batch_Entry_Time` datetime NOT NULL,
  `Batch_Created_By` varchar(50) NOT NULL,
  `Batch_Activated_By_Supplier` tinyint(3) unsigned NOT NULL,
  `Batch_Ready_To_Sell` tinyint(3) unsigned NOT NULL,
  `IsBatchActive` tinyint(3) unsigned NOT NULL,
  `Additional_Info` varchar(50) DEFAULT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `Batch_File_Path` varchar(512) NOT NULL,
  `Batch_Upload_Status` varchar(50) DEFAULT NULL,
  `LastModifiedTime` datetime NOT NULL,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  `Probable_Sale_Price` float unsigned DEFAULT '0',
  `Batch_Cost` float unsigned NOT NULL DEFAULT '0',
  `Paid_To_Supplier` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Payment_Date_To_Supplier` datetime DEFAULT NULL,
  `Last_Touch_Time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_batch_information`
--

LOCK TABLES `t_history_batch_information` WRITE;
/*!40000 ALTER TABLE `t_history_batch_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_batch_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_card_info`
--

DROP TABLE IF EXISTS `t_history_card_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_card_info` (
  `SequenceID` bigint(100) unsigned NOT NULL DEFAULT '0',
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `card_id` varchar(20) NOT NULL,
  `card_pin` varchar(20) NOT NULL,
  `Transaction_ID` bigint(100) unsigned DEFAULT NULL,
  `IsSold` tinyint(3) unsigned NOT NULL DEFAULT '0',
  KEY `index_t_history_card_info_sequence_id` (`SequenceID`),
  KEY `index_t_history_card_info_batch_sequence_id` (`Batch_Sequence_ID`),
  KEY `index_t_history_card_info_product_id` (`Product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_card_info`
--

LOCK TABLES `t_history_card_info` WRITE;
/*!40000 ALTER TABLE `t_history_card_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_card_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_card_info_old`
--

DROP TABLE IF EXISTS `t_history_card_info_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_card_info_old` (
  `SequenceID` bigint(100) unsigned NOT NULL DEFAULT '0',
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `card_id` varchar(20) NOT NULL,
  `card_pin` varchar(20) NOT NULL,
  `Transaction_ID` bigint(100) unsigned DEFAULT NULL,
  `IsSold` tinyint(3) unsigned NOT NULL DEFAULT '0',
  KEY `index_t_history_card_info_old_product_id` (`Product_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_card_info_old`
--

LOCK TABLES `t_history_card_info_old` WRITE;
/*!40000 ALTER TABLE `t_history_card_info_old` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_card_info_old` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_transaction_balance`
--

DROP TABLE IF EXISTS `t_history_transaction_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_transaction_balance` (
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Balance_Before_Transaction` float NOT NULL,
  `Balance_After_Transaction` float NOT NULL,
  PRIMARY KEY (`Transaction_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_transaction_balance`
--

LOCK TABLES `t_history_transaction_balance` WRITE;
/*!40000 ALTER TABLE `t_history_transaction_balance` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_transaction_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_transactions`
--

DROP TABLE IF EXISTS `t_history_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_transactions` (
  `Sequence_ID` bigint(100) unsigned NOT NULL DEFAULT '0',
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `Unit_Purchase_Price` float unsigned NOT NULL DEFAULT '0',
  `Secondary_Transaction_Price` float unsigned NOT NULL DEFAULT '0',
  `Committed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Transaction_Time` datetime NOT NULL,
  `Unit_Group_Price` float unsigned NOT NULL,
  `Batch_Unit_Price` float unsigned NOT NULL,
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0',
  KEY `FK_history_transaction_batch` (`Batch_Sequence_ID`),
  KEY `transaction_index` (`Transaction_ID`),
  KEY `index_t_history_transaction_product_id` (`Product_ID`),
  KEY `index_t_history_transaction_customer_id` (`Customer_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_transactions`
--

LOCK TABLES `t_history_transactions` WRITE;
/*!40000 ALTER TABLE `t_history_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_transactions_2010_05_31__2013_01_01`
--

DROP TABLE IF EXISTS `t_history_transactions_2010_05_31__2013_01_01`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_transactions_2010_05_31__2013_01_01` (
  `Sequence_ID` bigint(100) unsigned NOT NULL DEFAULT '0',
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `Unit_Purchase_Price` float unsigned NOT NULL DEFAULT '0',
  `Secondary_Transaction_Price` float unsigned NOT NULL DEFAULT '0',
  `Committed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Transaction_Time` datetime NOT NULL,
  `Unit_Group_Price` float unsigned NOT NULL,
  `Batch_Unit_Price` float unsigned NOT NULL,
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0',
  KEY `FK_history_transaction_2010_batch` (`Batch_Sequence_ID`),
  KEY `FK_history_transaction_2010_product` (`Product_ID`),
  KEY `FK_history_transaction_2010_transaction_id` (`Transaction_ID`),
  KEY `FK_history_transaction_2010_committed` (`Committed`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_transactions_2010_05_31__2013_01_01`
--

LOCK TABLES `t_history_transactions_2010_05_31__2013_01_01` WRITE;
/*!40000 ALTER TABLE `t_history_transactions_2010_05_31__2013_01_01` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_transactions_2010_05_31__2013_01_01` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_transferto_transactions`
--

DROP TABLE IF EXISTS `t_history_transferto_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_transferto_transactions` (
  `Sequence_ID` bigint(20) unsigned NOT NULL DEFAULT '0',
  `Transaction_ID` bigint(20) unsigned NOT NULL,
  `TransferTo_Transaction_ID` bigint(20) unsigned NOT NULL,
  `Error_Code` int(10) unsigned NOT NULL,
  `Error_Text` varchar(100) NOT NULL,
  `Requester_Phone` varchar(16) NOT NULL,
  `Destination_Phone` varchar(16) NOT NULL,
  `Originating_Currency` varchar(10) NOT NULL,
  `Destination_Currency` varchar(10) NOT NULL,
  `Destination_Country` varchar(50) NOT NULL,
  `Destination_Country_ID` varchar(5) NOT NULL,
  `Destination_Operator` varchar(50) NOT NULL,
  `Destination_Operator_ID` varchar(50) NOT NULL,
  `Operator_Reference_Info` varchar(100) NOT NULL,
  `SMS_Sent` varchar(5) NOT NULL,
  `SMS_Text` varchar(100) DEFAULT NULL,
  `Authentication_Key` varchar(50) NOT NULL,
  `CID1` varchar(50) DEFAULT NULL,
  `CID2` varchar(50) DEFAULT NULL,
  `CID3` varchar(50) DEFAULT NULL,
  `Product_Requested` float unsigned NOT NULL,
  `Product_Sent` float unsigned NOT NULL,
  `Wholesale_Price` float unsigned NOT NULL,
  `Retail_Price` float unsigned NOT NULL,
  `EezeeTel_Balance` float unsigned NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Transaction_Time` datetime NOT NULL,
  `Transaction_Status` tinyint(3) unsigned NOT NULL,
  `Cost_To_Customer` float unsigned NOT NULL,
  `Cost_To_Agent` float unsigned NOT NULL,
  `Cost_To_EezeeTel` float unsigned NOT NULL,
  `Cost_To_Group` float unsigned NOT NULL,
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_transferto_transactions`
--

LOCK TABLES `t_history_transferto_transactions` WRITE;
/*!40000 ALTER TABLE `t_history_transferto_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_transferto_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_history_user_log`
--

DROP TABLE IF EXISTS `t_history_user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_user_log` (
  `User_Login_ID` varchar(50) NOT NULL,
  `Login_Time` datetime NOT NULL,
  `Logout_Time` datetime DEFAULT NULL,
  `Login_Status` tinyint(3) unsigned NOT NULL,
  `SessionID` varchar(128) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_history_user_log`
--

LOCK TABLES `t_history_user_log` WRITE;
/*!40000 ALTER TABLE `t_history_user_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_history_user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_b2c_users`
--

DROP TABLE IF EXISTS `t_master_b2c_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_b2c_users` (
  `EMail_ID` varchar(255) NOT NULL,
  `Address_Line_1` varchar(255) DEFAULT NULL,
  `Address_Line_2` varchar(255) DEFAULT NULL,
  `Address_Line_3` varchar(255) DEFAULT NULL,
  `Alternate_Phone` varchar(255) DEFAULT NULL,
  `City` varchar(255) DEFAULT NULL,
  `Country` varchar(255) DEFAULT NULL,
  `Customer_Balance` float NOT NULL,
  `Is_Verifited` tinyint(4) NOT NULL,
  `Mobile_Phone` varchar(255) NOT NULL,
  `Notes` varchar(255) DEFAULT NULL,
  `Password` varchar(255) NOT NULL,
  `Password_2` varchar(255) NOT NULL,
  `Postal_Code` varchar(255) DEFAULT NULL,
  `State` varchar(255) DEFAULT NULL,
  `User_Active_Status` smallint(6) NOT NULL,
  `User_Created_By` varchar(255) NOT NULL,
  `User_Creation_Time` datetime NOT NULL,
  `User_First_Name` varchar(255) NOT NULL,
  `User_Last_Name` varchar(255) NOT NULL,
  `User_Middle_Name` varchar(255) DEFAULT NULL,
  `User_Modified_Time` datetime NOT NULL,
  `Verification_Code` varchar(255) NOT NULL,
  `Verified_Or_Joined_On` datetime NOT NULL,
  `Customer_Group_ID` int(11) NOT NULL,
  `User_Type_And_Privilege` smallint(6) NOT NULL,
  PRIMARY KEY (`EMail_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_b2c_users`
--

LOCK TABLES `t_master_b2c_users` WRITE;
/*!40000 ALTER TABLE `t_master_b2c_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_b2c_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_banks`
--

DROP TABLE IF EXISTS `t_master_banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_banks` (
  `Sequence_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Bank_Name` varchar(50) NOT NULL,
  `Active_Bank` tinyint(3) unsigned NOT NULL,
  `Banking_Since` datetime NOT NULL,
  `Customer_Group_ID` int(10) unsigned NOT NULL DEFAULT '1',
  `Sort_Code` varchar(50) DEFAULT NULL,
  `Account_Number` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Sequence_ID`),
  KEY `fk_1_customer_group_id` (`Customer_Group_ID`),
  CONSTRAINT `fk_1_customer_group_id` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_banks`
--

LOCK TABLES `t_master_banks` WRITE;
/*!40000 ALTER TABLE `t_master_banks` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_banks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_countries`
--

DROP TABLE IF EXISTS `t_master_countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_countries` (
  `Country_Name` varchar(100) NOT NULL,
  PRIMARY KEY (`Country_Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_countries`
--

LOCK TABLES `t_master_countries` WRITE;
/*!40000 ALTER TABLE `t_master_countries` DISABLE KEYS */;
INSERT INTO `t_master_countries` VALUES ('United Kingdom', 'Ukraine', 'Lebanon');
/*!40000 ALTER TABLE `t_master_countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_customer_credit`
--

DROP TABLE IF EXISTS `t_master_customer_credit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_customer_credit` (
  `Credit_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Customer_ID` int(10) unsigned NOT NULL,
  `Payment_Type` tinyint(3) unsigned NOT NULL COMMENT '1 - cash, 2 - check, 3 - bank deposit, 4 - online transfer, 5 - card',
  `Payment_Details` varchar(200) DEFAULT NULL,
  `Payment_Amount` float unsigned NOT NULL,
  `Payment_Date` datetime DEFAULT NULL,
  `Collected_By` varchar(50) NOT NULL,
  `Entered_By` varchar(50) NOT NULL,
  `Entered_Time` datetime NOT NULL,
  `Credit_or_Debit` tinyint(3) unsigned NOT NULL COMMENT '1 - credit (customer paid), 2 - debit (customer NOT paid, but allowed to buy cards)',
  `Credit_ID_Status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '1 - pending verification, 2 - processed',
  `Notes` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`Credit_ID`),
  KEY `FK_t_master_customer_credit_1` (`Customer_ID`),
  KEY `FK_t_master_customer_credit_2` (`Entered_By`),
  KEY `FK_t_master_customer_credit_3` (`Collected_By`),
  CONSTRAINT `FK_t_master_customer_credit_1` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_master_customer_credit_2` FOREIGN KEY (`Collected_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_customer_credit_3` FOREIGN KEY (`Entered_By`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=118872 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_customer_credit`
--

LOCK TABLES `t_master_customer_credit` WRITE;
/*!40000 ALTER TABLE `t_master_customer_credit` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_customer_credit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_customer_group_credit`
--

DROP TABLE IF EXISTS `t_master_customer_group_credit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_customer_group_credit` (
  `Group_Credit_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Customer_Group_ID` int(10) unsigned NOT NULL,
  `Payment_Type` tinyint(3) unsigned NOT NULL COMMENT '1 - cash, 2 - check, 3 - bank deposit, 4 - online transfer, 5 - card',
  `Payment_Details` varchar(200) DEFAULT NULL,
  `Payment_Amount` float unsigned NOT NULL,
  `Payment_Date` datetime DEFAULT NULL,
  `Collected_By` varchar(50) NOT NULL,
  `Entered_By` varchar(50) NOT NULL,
  `Entered_Time` datetime NOT NULL,
  `Credit_or_Debit` tinyint(3) unsigned NOT NULL COMMENT '1 - credit (customer paid), 2 - debit (customer NOT paid, but allowed to buy cards)',
  `Credit_ID_Status` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '1 - pending verification, 2 - processed',
  `Notes` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`Group_Credit_ID`),
  KEY `foreign_key_1` (`Customer_Group_ID`),
  KEY `FK_t_master_customer_group_credit_2` (`Collected_By`),
  KEY `FK_t_master_customer_group_credit_3` (`Entered_By`),
  CONSTRAINT `FK_t_master_customer_group_credit_2` FOREIGN KEY (`Collected_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_customer_group_credit_3` FOREIGN KEY (`Entered_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `foreign_key_1` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1251 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_customer_group_credit`
--

LOCK TABLES `t_master_customer_group_credit` WRITE;
/*!40000 ALTER TABLE `t_master_customer_group_credit` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_customer_group_credit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_customer_groups`
--

DROP TABLE IF EXISTS `t_master_customer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_customer_groups` (
  `Customer_Group_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Customer_Group_Name` varchar(50) NOT NULL,
  `Customer_Since` datetime NOT NULL,
  `Created_By` varchar(50) DEFAULT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `IsActive` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Customer_Group_Balance` float unsigned NOT NULL DEFAULT '0',
  `Check_Aganinst_Group_Balance` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `Default_Customer_ID` int(10) unsigned DEFAULT NULL,
  `Apply_Default_Customer_Percentages` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `Group_Address` varchar(50) NOT NULL,
  `Group_City` varchar(50) NOT NULL,
  `Group_PinCode` varchar(10) NOT NULL,
  `Group_Phone` varchar(15) NOT NULL,
  `Group_Mobile` varchar(15) NOT NULL,
  `Group_Email_ID` varchar(50) NOT NULL,
  `Company_Reg_No` varchar(20) NOT NULL,
  `VAT_Reg_No` varchar(20) NOT NULL,
  `Sell_At_Face_Value` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `STYLE` int(11) DEFAULT '0',
  PRIMARY KEY (`Customer_Group_ID`) USING BTREE,
  KEY `FK_t_master_customer_groups_2` (`Created_By`),
  KEY `FK_t_master_customer_groups_3` (`Default_Customer_ID`),
  CONSTRAINT `FK_t_master_customer_groups_1` FOREIGN KEY (`Default_Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_master_customer_groups_2` FOREIGN KEY (`Created_By`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_customer_groups`
--

LOCK TABLES `t_master_customer_groups` WRITE;
/*!40000 ALTER TABLE `t_master_customer_groups` DISABLE KEYS */;
INSERT INTO `t_master_customer_groups` VALUES (1,'EEZEE TEL LTD','2018-01-05 19:18:51',NULL,NULL,1,0,0,NULL,0,'8, TALGARTHWALK','WESTHENDON','NW97HW','02082009345','02070960075','contact@eezeetel.com','7181873','991581286',0,0);
/*!40000 ALTER TABLE `t_master_customer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_customerinfo`
--

DROP TABLE IF EXISTS `t_master_customerinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_customerinfo` (
  `Customer_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Customer_Company_Name` varchar(50) NOT NULL,
  `Customer_Type_ID` smallint(5) unsigned NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Address_Line_1` varchar(50) DEFAULT NULL,
  `Address_Line_2` varchar(50) DEFAULT NULL,
  `Address_Line_3` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Postal_Code` varchar(20) DEFAULT NULL,
  `Country` varchar(20) DEFAULT NULL,
  `Primary_Phone` varchar(50) DEFAULT NULL,
  `Secondary_Phone` varchar(50) DEFAULT NULL,
  `Mobile_Phone` varchar(50) DEFAULT NULL,
  `Website_Address` varchar(100) DEFAULT NULL,
  `Email_ID` varchar(100) DEFAULT NULL,
  `Customer_Balance` float NOT NULL DEFAULT '0',
  `Created_By_User_ID` varchar(50) NOT NULL,
  `Customer_Introduced_By` varchar(50) NOT NULL,
  `Active_Status` smallint(5) unsigned NOT NULL,
  `Last_Modified_Time` datetime NOT NULL,
  `Creation_Time` datetime NOT NULL,
  `Notes` longtext,
  `Login_Start_Time` time NOT NULL DEFAULT '04:00:00',
  `Login_End_Time` time NOT NULL DEFAULT '23:45:00',
  `Customer_Group_ID` int(10) unsigned DEFAULT NULL,
  `Customer_Feature_ID` int(10) unsigned DEFAULT '1',
  `Special_Printer_Customer` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Allow_Credit` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Customer_ID`),
  KEY `FK_T_Master_CustomerInfo_T_Master_Users` (`Created_By_User_ID`),
  KEY `FK_T_Master_CustomerInfo_T_Master_CustomerType` (`Customer_Type_ID`),
  KEY `FK_t_master_customerinfo_2` (`Customer_Introduced_By`),
  KEY `FK_t_master_customerinfo_4` (`Customer_Group_ID`),
  CONSTRAINT `FK_T_Master_CustomerInfo_T_Master_CustomerType` FOREIGN KEY (`Customer_Type_ID`) REFERENCES `t_master_customertype` (`Customer_Type_ID`),
  CONSTRAINT `FK_t_master_customerinfo_2` FOREIGN KEY (`Customer_Introduced_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_customerinfo_3` FOREIGN KEY (`Created_By_User_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_customerinfo_4` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1058 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_customerinfo`
--

LOCK TABLES `t_master_customerinfo` WRITE;
/*!40000 ALTER TABLE `t_master_customerinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_customerinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_customerinfo_old`
--

DROP TABLE IF EXISTS `t_master_customerinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_customerinfo_old` (
  `Customer_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Customer_Company_Name` varchar(50) NOT NULL,
  `Customer_Type_ID` smallint(5) unsigned NOT NULL,
  `First_Name` varchar(50) NOT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Middle_Name` varchar(50) DEFAULT NULL,
  `Address_Line_1` varchar(50) DEFAULT NULL,
  `Address_Line_2` varchar(50) DEFAULT NULL,
  `Address_Line_3` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Postal_Code` varchar(20) DEFAULT NULL,
  `Country` varchar(20) DEFAULT NULL,
  `Primary_Phone` varchar(50) DEFAULT NULL,
  `Secondary_Phone` varchar(50) DEFAULT NULL,
  `Mobile_Phone` varchar(50) DEFAULT NULL,
  `Website_Address` varchar(100) DEFAULT NULL,
  `Email_ID` varchar(100) DEFAULT NULL,
  `Customer_Balance` float NOT NULL DEFAULT '0',
  `Created_By_User_ID` varchar(50) NOT NULL,
  `Customer_Introduced_By` varchar(50) NOT NULL,
  `Active_Status` smallint(5) unsigned NOT NULL,
  `Last_Modified_Time` datetime NOT NULL,
  `Creation_Time` datetime NOT NULL,
  `Notes` longtext,
  `Login_Start_Time` time NOT NULL DEFAULT '04:00:00',
  `Login_End_Time` time NOT NULL DEFAULT '23:45:00',
  `Customer_Group_ID` int(10) unsigned DEFAULT NULL,
  `Customer_Feature_ID` int(10) unsigned DEFAULT NULL,
  `Special_Printer_Customer` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Allow_Credit` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Customer_ID`),
  KEY `FK_T_Master_CustomerInfo_T_Master_CustomerType` (`Customer_Type_ID`),
  KEY `FK_t_master_customerinfo_2` (`Customer_Introduced_By`),
  KEY `FK_t_master_customerinfo_4` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1051 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_customerinfo_old`
--

LOCK TABLES `t_master_customerinfo_old` WRITE;
/*!40000 ALTER TABLE `t_master_customerinfo_old` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_customerinfo_old` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_customertype`
--

DROP TABLE IF EXISTS `t_master_customertype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_customertype` (
  `Customer_Type_ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `Customer_Type` varchar(50) NOT NULL,
  `Customer_Type_Description` varchar(50) DEFAULT NULL,
  `Customer_Type_Active_Status` smallint(5) unsigned NOT NULL,
  `Notes` longtext,
  `Reserved_1` smallint(5) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Customer_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_customertype`
--

LOCK TABLES `t_master_customertype` WRITE;
/*!40000 ALTER TABLE `t_master_customertype` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_customertype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_expenses`
--

DROP TABLE IF EXISTS `t_master_expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_expenses` (
  `Expense_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Expense_Type` tinyint(4) NOT NULL,
  `Expense_Purpose` varchar(50) NOT NULL,
  `Payment_Date` datetime NOT NULL,
  `Receipt_Path` varchar(100) DEFAULT NULL,
  `Payment_Amount` float NOT NULL,
  PRIMARY KEY (`Expense_ID`),
  KEY `t_expense_type_id_idx` (`Expense_Type`),
  CONSTRAINT `t_expense_type_id` FOREIGN KEY (`Expense_Type`) REFERENCES `t_expense_types` (`Expense_Type_ID`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_expenses`
--

LOCK TABLES `t_master_expenses` WRITE;
/*!40000 ALTER TABLE `t_master_expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_product_category`
--

DROP TABLE IF EXISTS `t_master_product_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_product_category` (
  `Product_Category_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Product_Category_Name` varchar(50) NOT NULL,
  `Product_Category_Description` varchar(50) DEFAULT NULL,
  `Is_Active` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`Product_Category_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_product_category`
--

LOCK TABLES `t_master_product_category` WRITE;
/*!40000 ALTER TABLE `t_master_product_category` DISABLE KEYS */;
INSERT INTO `t_master_product_category` VALUES (1,'Calling Cards','World calling cards',1),(2,'Mobile Vouchers','Mobile Vouchers',1),(3,'World Mobile Topup','World Mobile Topup',1),(4,'Local Mobile Voucher','Local Mobile Voucher',1),(5,'SIM Cards','SIM Cards',1),(6,'Sim Unlocking','Sim Unlocking',1);
/*!40000 ALTER TABLE `t_master_product_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_productinfo`
--

DROP TABLE IF EXISTS `t_master_productinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_productinfo` (
  `Product_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Supplier_ID` int(10) unsigned NOT NULL DEFAULT '0',
  `Product_Name` varchar(100) NOT NULL,
  `Product_Type_ID` smallint(5) unsigned NOT NULL,
  `Product_Face_Value` float unsigned NOT NULL DEFAULT '0',
  `Product_Description` varchar(100) DEFAULT NULL,
  `Product_Active_Status` smallint(5) unsigned NOT NULL,
  `Product_Created_By` varchar(50) NOT NULL,
  `Product_Creation_Time` datetime NOT NULL,
  `Notes` longtext,
  `Caliculate_VAT` smallint(6) NOT NULL DEFAULT '0',
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  `COST_PRICE` decimal(19,2) DEFAULT NULL,
  PRIMARY KEY (`Product_ID`) USING BTREE,
  KEY `FK_t_master_productinfo_1` (`Product_Type_ID`),
  KEY `FK_t_master_productinfo_2` (`Product_Created_By`),
  KEY `FK_t_master_productinfo_3` (`Supplier_ID`),
  CONSTRAINT `FK_t_master_productinfo_1` FOREIGN KEY (`Product_Type_ID`) REFERENCES `t_master_producttype` (`Product_Type_ID`),
  CONSTRAINT `FK_t_master_productinfo_2` FOREIGN KEY (`Product_Created_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_productinfo_3` FOREIGN KEY (`Supplier_ID`) REFERENCES `t_master_supplierinfo` (`Supplier_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=426 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_productinfo`
--

LOCK TABLES `t_master_productinfo` WRITE;
/*!40000 ALTER TABLE `t_master_productinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_productinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_productsaleinfo`
--

DROP TABLE IF EXISTS `t_master_productsaleinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_productsaleinfo` (
  `Sale_Info_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Product_ID` int(10) unsigned NOT NULL,
  `Toll_Free_Number_1` varchar(50) DEFAULT NULL,
  `Toll_Free_Number_2` varchar(50) DEFAULT NULL,
  `Local_Acess_Number_1` varchar(50) DEFAULT NULL,
  `Local_Acess_Number_2` varchar(50) DEFAULT NULL,
  `National_Acess_Number_1` varchar(50) DEFAULT NULL,
  `National_Acess_Number_2` varchar(50) DEFAULT NULL,
  `PayPhone_Acess_Number_1` varchar(50) DEFAULT NULL,
  `PayPhone_Acess_Number_2` varchar(50) DEFAULT NULL,
  `Other_Acess_Number_1` varchar(50) DEFAULT NULL,
  `Other_Acess_Number_2` varchar(50) DEFAULT NULL,
  `Support_Number_1` varchar(50) DEFAULT NULL,
  `Support_Number_2` varchar(50) DEFAULT NULL,
  `Sale_Rules` varchar(250) DEFAULT NULL,
  `AdditionalInfo` varchar(250) DEFAULT NULL,
  `Product_Image_File` varchar(250) DEFAULT NULL,
  `IsActive` int(10) unsigned NOT NULL,
  `CreationTime` datetime NOT NULL,
  `CreatedBy` varchar(50) NOT NULL,
  `ModifiedTime` datetime NOT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `Print_Info` varchar(2048) DEFAULT NULL,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Sale_Info_ID`),
  KEY `FK_t_master_productsaleinfo_1` (`Product_ID`),
  CONSTRAINT `FK_t_master_productsaleinfo_1` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`),
  CONSTRAINT `FK_t_master_productsaleinfo_2` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=332 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_productsaleinfo`
--

LOCK TABLES `t_master_productsaleinfo` WRITE;
/*!40000 ALTER TABLE `t_master_productsaleinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_productsaleinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_producttype`
--

DROP TABLE IF EXISTS `t_master_producttype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_producttype` (
  `Product_Type_ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `Product_Type` varchar(50) NOT NULL,
  `Product_Type_Description` varchar(50) DEFAULT NULL,
  `Product_Type_Active_Status` smallint(5) unsigned NOT NULL,
  `Notes` longtext,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Product_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_producttype`
--

LOCK TABLES `t_master_producttype` WRITE;
/*!40000 ALTER TABLE `t_master_producttype` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_producttype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_supplierinfo`
--

DROP TABLE IF EXISTS `t_master_supplierinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_supplierinfo` (
  `Supplier_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Supplier_Name` varchar(50) NOT NULL,
  `Supplier_Type_ID` smallint(5) unsigned NOT NULL,
  `Supplier_Contact` varchar(100) DEFAULT NULL,
  `Supplier_Address_Line_1` varchar(50) DEFAULT NULL,
  `Supplier_Address_Line_2` varchar(50) DEFAULT NULL,
  `Supplier_Address_Line_3` varchar(50) DEFAULT NULL,
  `Supplier_City` varchar(50) DEFAULT NULL,
  `Supplier_State` varchar(50) DEFAULT NULL,
  `Supplier_Postal_Code` varchar(20) DEFAULT NULL,
  `Supplier_Country` varchar(20) DEFAULT NULL,
  `Supplier_Primary_Phone` varchar(50) DEFAULT NULL,
  `Supplier_Secondary_Phone` varchar(50) DEFAULT NULL,
  `Supplier_Mobile_Phone` varchar(50) DEFAULT NULL,
  `Supplier_Website_Address` varchar(100) DEFAULT NULL,
  `Supplier_Email_ID` varchar(100) DEFAULT NULL,
  `Supplier_Introduced_By` varchar(50) DEFAULT NULL,
  `Supplier_Active_Status` smallint(5) unsigned NOT NULL,
  `Supplier_Created_By_User_ID` varchar(50) NOT NULL,
  `Supplier_Info_Modified_Time` datetime NOT NULL,
  `Supplier_Info_Creation_Time` datetime DEFAULT NULL,
  `Notes` longtext,
  `Secondary_Supplier` smallint(5) unsigned DEFAULT '0',
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Supplier_Image` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Supplier_ID`),
  KEY `FK_T_Master_SupplierInfo_T_Master_SupplierType` (`Supplier_Type_ID`),
  KEY `FK_T_Master_SupplierInfo_T_Master_Users` (`Supplier_Created_By_User_ID`),
  CONSTRAINT `FK_T_Master_SupplierInfo_T_Master_SupplierType` FOREIGN KEY (`Supplier_Type_ID`) REFERENCES `t_master_suppliertype` (`Supplier_Type_ID`),
  CONSTRAINT `FK_t_master_supplierinfo_2` FOREIGN KEY (`Supplier_Created_By_User_ID`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_supplierinfo`
--

LOCK TABLES `t_master_supplierinfo` WRITE;
/*!40000 ALTER TABLE `t_master_supplierinfo` DISABLE KEYS */;
INSERT INTO `t_master_supplierinfo` VALUES (77,'mobile unlocking supplier ',20,'asdf','line test','line test','line test','city','UK','12356','United Kingdom','0','123','123','x','913@test.com','2345',1,'masteradmin','2018-01-08 20:55:01','2018-01-08 20:55:01','dsadf',0,NULL,'');
/*!40000 ALTER TABLE `t_master_supplierinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_suppliertype`
--

DROP TABLE IF EXISTS `t_master_suppliertype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_suppliertype` (
  `Supplier_Type_ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `Supplier_Type` varchar(50) NOT NULL,
  `Supplier_Type_Description` varchar(50) DEFAULT NULL,
  `Supplier_Type_Active_Status` smallint(5) unsigned NOT NULL,
  `Notes` longtext,
  `Reserved_1` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  `FEATURE_ID` int(11) DEFAULT NULL,
  `IS_SIM` bit(1) DEFAULT NULL,
  PRIMARY KEY (`Supplier_Type_ID`),
  KEY `FK_favsnf4pgwuqwacu8k721u2al` (`FEATURE_ID`),
  CONSTRAINT `FK_favsnf4pgwuqwacu8k721u2al` FOREIGN KEY (`FEATURE_ID`) REFERENCES `feature` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_suppliertype`
--

LOCK TABLES `t_master_suppliertype` WRITE;
/*!40000 ALTER TABLE `t_master_suppliertype` DISABLE KEYS */;
INSERT INTO `t_master_suppliertype` VALUES (8,'card and topups','cards and topup',1,'o',NULL,NULL,NULL,NULL),(9,'internatinalcards','allcountryes',1,'',NULL,NULL,NULL,NULL),(10,'topup only','localtopup',1,'',NULL,NULL,NULL,NULL),(11,'multycountry intornatinalcards','multyint cards',1,'',NULL,NULL,NULL,NULL),(12,'intornatinaltopup','intornatinaltopups',1,'',NULL,NULL,NULL,NULL),(13,'Ghana Tel','devi',0,'india',NULL,NULL,NULL,NULL),(14,'World Mobile Topups','World Mobile Topup Service',1,'added by krishna',NULL,NULL,NULL,NULL),(15,'Uk Mobile Topups','Uk Mobile Topups',0,'',NULL,NULL,NULL,NULL),(16,'3R mobile Topups','3R mobile Topups',1,'',NULL,NULL,NULL,NULL),(17,'SIM Cards','Supplies SIM Cards',1,'Could be secondary or primary',NULL,NULL,NULL,NULL),(18,'Eezee TelApp Calling cards','Eezee TelApp Calling cards',1,'EezeeApp Calling cards',NULL,NULL,NULL,NULL),(19,'Sim unloking','Sim unloking',1,'',NULL,NULL,NULL,NULL),(20,'AAA','allcountryes',1,'gsmtopup.co.uk',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `t_master_suppliertype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_user_type_and_privilege`
--

DROP TABLE IF EXISTS `t_master_user_type_and_privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_user_type_and_privilege` (
  `User_Type_And_Privilege_ID` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `User_Type_And_Privilege_Name` varchar(50) NOT NULL,
  `Notes` longtext,
  PRIMARY KEY (`User_Type_And_Privilege_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_user_type_and_privilege`
--

LOCK TABLES `t_master_user_type_and_privilege` WRITE;
/*!40000 ALTER TABLE `t_master_user_type_and_privilege` DISABLE KEYS */;
INSERT INTO `t_master_user_type_and_privilege` VALUES (1,'Deleted_User','Can not do anything'),(2,'Employee_Master_Admin','Can do everything'),(3,'Employee_Manager','Can create other users, Manage accounts, Manage transactions'),(4,'Group_Admin','Manage transactions'),(5,'Group_Manager','Can do support activities'),(6,'Agent_User','Can create customers and check his commission statistics'),(7,'Customer_Supervisor','Do transactions and can check transactions made by customer users'),(8,'Customer_User','Do transactions'),(9,'Mobile_Admin',NULL);
/*!40000 ALTER TABLE `t_master_user_type_and_privilege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_users`
--

DROP TABLE IF EXISTS `t_master_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_master_users` (
  `User_Login_ID` varchar(50) NOT NULL,
  `User_First_Name` varchar(50) NOT NULL,
  `User_Last_Name` varchar(50) NOT NULL,
  `User_Middle_Name` varchar(50) DEFAULT NULL,
  `User_Company_Name` varchar(50) NOT NULL,
  `Address_Line_1` varchar(50) DEFAULT NULL,
  `Address_Line_2` varchar(50) DEFAULT NULL,
  `Address_Line_3` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `Postal_Code` varchar(20) DEFAULT NULL,
  `Country` varchar(20) DEFAULT NULL,
  `Primary_Phone` varchar(50) NOT NULL,
  `Secondary_Phone` varchar(50) DEFAULT NULL,
  `Mobile_Phone` varchar(50) DEFAULT NULL,
  `EMail_ID` varchar(100) NOT NULL,
  `User_Type_And_Privilege` smallint(5) unsigned NOT NULL,
  `Password` varchar(50) NOT NULL,
  `Password_2` varchar(50) NOT NULL,
  `User_Active_Status` smallint(5) unsigned NOT NULL,
  `User_Created_By` varchar(50) NOT NULL,
  `User_Creation_Time` datetime NOT NULL,
  `User_Modified_Time` datetime NOT NULL,
  `Notes` longtext,
  `Customer_Group_ID` int(10) unsigned DEFAULT NULL,
  `Reserved_2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`User_Login_ID`) USING BTREE,
  KEY `FK_t_master_users1_1` (`User_Type_And_Privilege`),
  KEY `FK_t_master_users_2` (`Customer_Group_ID`),
  CONSTRAINT `FK_t_master_users1_1` FOREIGN KEY (`User_Type_And_Privilege`) REFERENCES `t_master_user_type_and_privilege` (`User_Type_And_Privilege_ID`),
  CONSTRAINT `FK_t_master_users_2` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_users`
--

LOCK TABLES `t_master_users` WRITE;
/*!40000 ALTER TABLE `t_master_users` DISABLE KEYS */;
INSERT INTO `t_master_users` VALUES ('masteradmin','Raghu','Madabushi','no middle','Anik Solutions','address line 1','address line 2','address line 3','hendon','NW','po98rt','United Kingdom','23947239048','239478239048','23049823094','adlsfjkasdf@asdlfjasdf.com',2,'9f706ab85924bd1aa5f9b3c79f7490bd','masteradmin',1,'MasterAdmin','2018-01-05 19:22:38','2018-01-05 19:22:38','',1,NULL),('raghuanik','raghu','t','t','EEZEETOPUP','t','t','t','t','t','t','United Kingdom','1','1','1','1',4,'b008b46e382f56d2c225ed0066d68f03','20071969',1,'masteradmin','2018-01-05 19:22:38','2018-01-05 19:22:38','',1,NULL);
/*!40000 ALTER TABLE `t_master_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_messages`
--

DROP TABLE IF EXISTS `t_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_messages` (
  `Sequence_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Date_Entered` datetime NOT NULL,
  `Message` varchar(1024) NOT NULL,
  `Target_Group` int(10) unsigned DEFAULT NULL,
  `Target_Customer_List` varchar(2048) DEFAULT NULL,
  `Expiry_Date` datetime DEFAULT NULL,
  `Is_Active` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`Sequence_ID`),
  KEY `FK_l1lk5orcle7mc9i0roovb0g9w` (`Target_Group`),
  CONSTRAINT `FK_l1lk5orcle7mc9i0roovb0g9w` FOREIGN KEY (`Target_Group`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_messages`
--

LOCK TABLES `t_messages` WRITE;
/*!40000 ALTER TABLE `t_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_new_contacts`
--

DROP TABLE IF EXISTS `t_new_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_new_contacts` (
  `Sequence_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Contact_Name` varchar(50) DEFAULT NULL,
  `Contact_Business_Name` varchar(50) DEFAULT NULL,
  `Referred_By` varchar(50) DEFAULT NULL,
  `Contact_Number` varchar(50) DEFAULT NULL,
  `Contact_Email` varchar(50) DEFAULT NULL,
  `Additional_Notes` varchar(250) DEFAULT NULL,
  `Contact_Time` datetime NOT NULL,
  `Addressed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Addressed_By` varchar(50) NOT NULL,
  `Time_Addressed` datetime DEFAULT NULL,
  `Remote_Address` varchar(50) NOT NULL,
  `Comments` varchar(100) DEFAULT NULL,
  `Group_ID` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`Sequence_ID`),
  KEY `FK_t_new_contacts_1` (`Addressed_By`),
  KEY `FK_t_new_contacts_2` (`Group_ID`),
  CONSTRAINT `FK_t_new_contacts_1` FOREIGN KEY (`Addressed_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_new_contacts_2` FOREIGN KEY (`Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_new_contacts`
--

LOCK TABLES `t_new_contacts` WRITE;
/*!40000 ALTER TABLE `t_new_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_new_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_old_card_info`
--

DROP TABLE IF EXISTS `t_old_card_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_old_card_info` (
  `SequenceID` bigint(100) unsigned NOT NULL DEFAULT '0',
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `card_id` varchar(20) NOT NULL,
  `card_pin` varchar(20) NOT NULL,
  `Transaction_ID` bigint(100) unsigned DEFAULT NULL,
  `IsSold` tinyint(3) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_old_card_info`
--

LOCK TABLES `t_old_card_info` WRITE;
/*!40000 ALTER TABLE `t_old_card_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_old_card_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_old_transaction_balance`
--

DROP TABLE IF EXISTS `t_old_transaction_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_old_transaction_balance` (
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Balance_Before_Transaction` float NOT NULL,
  `Balance_After_Transaction` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_old_transaction_balance`
--

LOCK TABLES `t_old_transaction_balance` WRITE;
/*!40000 ALTER TABLE `t_old_transaction_balance` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_old_transaction_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_old_transactions`
--

DROP TABLE IF EXISTS `t_old_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_old_transactions` (
  `Sequence_ID` bigint(100) unsigned NOT NULL DEFAULT '0',
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `Unit_Purchase_Price` float unsigned NOT NULL DEFAULT '0',
  `Secondary_Transaction_Price` float unsigned NOT NULL DEFAULT '0',
  `Committed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Transaction_Time` datetime NOT NULL,
  `Unit_Group_Price` float unsigned NOT NULL,
  `Batch_Unit_Price` float unsigned NOT NULL,
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_old_transactions`
--

LOCK TABLES `t_old_transactions` WRITE;
/*!40000 ALTER TABLE `t_old_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_old_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_report_customer_credit`
--

DROP TABLE IF EXISTS `t_report_customer_credit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_report_customer_credit` (
  `Sequence_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Begin_Date` datetime NOT NULL,
  `End_Date` datetime NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `Customer_Group_ID` int(10) unsigned NOT NULL,
  `Total_Credit_So_Far` float unsigned NOT NULL,
  `Total_Debit_On_End_Date` float unsigned NOT NULL,
  `Balance_On_End_Date` float unsigned NOT NULL,
  PRIMARY KEY (`Sequence_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_report_customer_credit`
--

LOCK TABLES `t_report_customer_credit` WRITE;
/*!40000 ALTER TABLE `t_report_customer_credit` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_report_customer_credit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_report_customer_profit`
--

DROP TABLE IF EXISTS `t_report_customer_profit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_report_customer_profit` (
  `Sequence_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Begin_Date` datetime NOT NULL,
  `End_Date` datetime NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `Customer_Group_ID` int(10) unsigned NOT NULL,
  `Agent_ID` varchar(50) NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `Retail_Cost` float unsigned NOT NULL,
  `Cost_To_Customer` float unsigned NOT NULL,
  `Cost_To_Agent` float unsigned NOT NULL,
  `Cost_To_Group` float unsigned NOT NULL,
  `Batch_Cost` float unsigned NOT NULL,
  `Batch_Original_Cost` float unsigned NOT NULL,
  `Customer_VAT` float NOT NULL DEFAULT '0',
  `Agent_VAT` float NOT NULL DEFAULT '0',
  `Group_VAT` float NOT NULL DEFAULT '0',
  `EezeeTel_VAT` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`Sequence_ID`),
  KEY `FK_t_report_customer_profit_1` (`Customer_ID`),
  KEY `FK_t_report_customer_profit_2` (`Customer_Group_ID`),
  KEY `FK_t_report_customer_profit_3` (`Product_ID`),
  CONSTRAINT `FK_t_report_customer_profit_1` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_report_customer_profit_2` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`),
  CONSTRAINT `FK_t_report_customer_profit_3` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1337025 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_report_customer_profit`
--

LOCK TABLES `t_report_customer_profit` WRITE;
/*!40000 ALTER TABLE `t_report_customer_profit` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_report_customer_profit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_report_eezeetel_profit`
--

DROP TABLE IF EXISTS `t_report_eezeetel_profit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_report_eezeetel_profit` (
  `SequenceID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Begin_Date` datetime NOT NULL,
  `End_Date` datetime NOT NULL,
  `Customer_Group_ID` int(11) unsigned NOT NULL,
  `Total_Customers` int(10) unsigned NOT NULL,
  `Profit_From_Calling_Cards` float NOT NULL,
  `Profit_From_World_Mobile` float DEFAULT NULL,
  `Profit_From_Local_Mobile` float unsigned NOT NULL,
  `Total_Cards` int(10) unsigned NOT NULL,
  `Total_World_Mobile_Transactions` int(10) unsigned NOT NULL,
  `Total_Local_Mobile_Transactions` int(10) unsigned NOT NULL,
  `profit_from_mobile_unlocking` float NOT NULL,
  `profit_from_pinless` float NOT NULL,
  `total_mobile_unlocking_transactions` int(11) NOT NULL,
  `total_pinless_transactions` int(11) NOT NULL,
  PRIMARY KEY (`SequenceID`),
  KEY `t_report_eezeetel_profit_foreign_key_1` (`Customer_Group_ID`),
  CONSTRAINT `t_report_eezeetel_profit_foreign_key_1` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=318 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_report_eezeetel_profit`
--

LOCK TABLES `t_report_eezeetel_profit` WRITE;
/*!40000 ALTER TABLE `t_report_eezeetel_profit` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_report_eezeetel_profit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_report_group_profit`
--

DROP TABLE IF EXISTS `t_report_group_profit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_report_group_profit` (
  `SequenceID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Begin_Date` datetime NOT NULL,
  `End_Date` datetime NOT NULL,
  `Customer_ID` int(11) unsigned NOT NULL,
  `Customer_Group_ID` int(10) unsigned NOT NULL,
  `Agent_ID` varchar(50) NOT NULL,
  `Total_Cards` int(10) unsigned NOT NULL,
  `Total_World_Mobile_Transactions` int(10) unsigned NOT NULL,
  `Total_Local_Mobile_Transactions` int(10) unsigned NOT NULL,
  `Total_Amount` float unsigned NOT NULL,
  `Customer_Commission` float unsigned NOT NULL,
  `Agent_Commission` float unsigned NOT NULL,
  `Profit_From_Calling_Cards` float unsigned NOT NULL,
  `Profit_From_World_Mobile` float NOT NULL,
  `Profit_From_Local_Mobile` float unsigned NOT NULL,
  `EezeeTel_Cards_Profit` float NOT NULL,
  `EezeeTel_World_Mobile_Profit` float NOT NULL,
  `EezeeTel_Local_Mobile_Profit` float unsigned NOT NULL,
  `Customer_VAT` float NOT NULL DEFAULT '0',
  `Agent_VAT` float NOT NULL DEFAULT '0',
  `Group_VAT` float NOT NULL DEFAULT '0',
  `EezeeTel_VAT` float NOT NULL DEFAULT '0',
  `eezeetel_mobile_unlocking_profit` float NOT NULL,
  `eezeetel_pinless_profit` float NOT NULL,
  `profit_from_mobile_unlocking` float NOT NULL,
  `profit_from_pinless` float NOT NULL,
  `total_mobile_unlocking_transactions` int(11) NOT NULL,
  `total_pinless_transactions` int(11) NOT NULL,
  PRIMARY KEY (`SequenceID`),
  KEY `t_report_group_profit_foreign_key_1` (`Customer_ID`),
  KEY `t_report_group_profit_foreign_key_2` (`Customer_Group_ID`),
  CONSTRAINT `t_report_group_profit_foreign_key_1` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `t_report_group_profit_foreign_key_2` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19526 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_report_group_profit`
--

LOCK TABLES `t_report_group_profit` WRITE;
/*!40000 ALTER TABLE `t_report_group_profit` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_report_group_profit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_response_3r`
--

DROP TABLE IF EXISTS `t_response_3r`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_response_3r` (
  `SequenceID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Auto_Batch_Number` bigint(20) unsigned NOT NULL,
  `Supplier_Name` varchar(50) NOT NULL,
  `Product_Code` varchar(50) NOT NULL,
  `Product_Name` varchar(50) NOT NULL,
  `Requested_Quantity` smallint(5) unsigned NOT NULL,
  `Product_Value` varchar(50) NOT NULL,
  `Purchase_Date` datetime NOT NULL,
  `Response_Text` varchar(1024) NOT NULL,
  PRIMARY KEY (`SequenceID`)
) ENGINE=InnoDB AUTO_INCREMENT=269458 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_response_3r`
--

LOCK TABLES `t_response_3r` WRITE;
/*!40000 ALTER TABLE `t_response_3r` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_response_3r` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_revoked_transactions`
--

DROP TABLE IF EXISTS `t_revoked_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_revoked_transactions` (
  `Sequence_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Original_Sequence_ID` bigint(20) NOT NULL,
  `Original_Transaction_ID` bigint(20) NOT NULL,
  `Card_Sequence_ID` bigint(20) NOT NULL,
  `Revoked_Date` datetime NOT NULL,
  `New_Sequence_ID` bigint(20) DEFAULT NULL,
  `New_Transction_ID` bigint(20) DEFAULT NULL,
  `Sold_Again_Status` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Sequence_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3143 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_revoked_transactions`
--

LOCK TABLES `t_revoked_transactions` WRITE;
/*!40000 ALTER TABLE `t_revoked_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_revoked_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_sim_card_mobile_vouchers_mapping`
--

DROP TABLE IF EXISTS `t_sim_card_mobile_vouchers_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_sim_card_mobile_vouchers_mapping` (
  `SIM_Product_ID` int(10) unsigned NOT NULL,
  `Mobile_Voucher_Product_ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`SIM_Product_ID`,`Mobile_Voucher_Product_ID`),
  UNIQUE KEY `Mobile_Voucher_Product_ID_UNIQUE` (`SIM_Product_ID`,`Mobile_Voucher_Product_ID`),
  KEY `sim_prod_fk_1` (`SIM_Product_ID`),
  KEY `mobile_prod_fk_2` (`Mobile_Voucher_Product_ID`),
  CONSTRAINT `mobile_prod_fk_2` FOREIGN KEY (`Mobile_Voucher_Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sim_prod_fk_1` FOREIGN KEY (`SIM_Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_sim_card_mobile_vouchers_mapping`
--

LOCK TABLES `t_sim_card_mobile_vouchers_mapping` WRITE;
/*!40000 ALTER TABLE `t_sim_card_mobile_vouchers_mapping` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_sim_card_mobile_vouchers_mapping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_sim_cards_info`
--

DROP TABLE IF EXISTS `t_sim_cards_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_sim_cards_info` (
  `SequenceID` bigint(100) unsigned NOT NULL AUTO_INCREMENT,
  `Customer_Group_ID` int(10) unsigned DEFAULT '0',
  `Customer_ID` int(10) unsigned DEFAULT '0',
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `sim_card_id` varchar(20) NOT NULL,
  `sim_card_pin` varchar(20) NOT NULL,
  `Is_Sold` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Transaction_ID` bigint(100) unsigned DEFAULT NULL,
  `Max_Topups` tinyint(3) unsigned NOT NULL,
  `Remaining_Topups` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`SequenceID`),
  UNIQUE KEY `unique_value_sim_cards` (`Product_ID`,`sim_card_id`,`sim_card_pin`),
  KEY `fk1_batch_id` (`Batch_Sequence_ID`),
  KEY `fk2_product_id` (`Product_ID`),
  CONSTRAINT `fk1_batch_id` FOREIGN KEY (`Batch_Sequence_ID`) REFERENCES `t_batch_information` (`SequenceID`),
  CONSTRAINT `fk2_product_id` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16880 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_sim_cards_info`
--

LOCK TABLES `t_sim_cards_info` WRITE;
/*!40000 ALTER TABLE `t_sim_cards_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_sim_cards_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_sim_transactions`
--

DROP TABLE IF EXISTS `t_sim_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_sim_transactions` (
  `SequenceID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Transaction_ID` bigint(20) unsigned NOT NULL,
  `Transaction_Time` datetime NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `SIM_Card_SequenceID` bigint(20) unsigned NOT NULL,
  `Customer_Commission` float unsigned NOT NULL,
  `Agent_Commission` float unsigned NOT NULL,
  `Group_Commission` float unsigned NOT NULL,
  `Eezeetel_Commission` float unsigned NOT NULL,
  `Committed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Mobile_Topup_Transaction_ID` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`SequenceID`),
  KEY `fk_1_user_id_sim_transa` (`User_ID`),
  KEY `fk_2_customer_id_sim_trans` (`Customer_ID`),
  KEY `fk_3_sim_sequence_id_sim_cards_table` (`SIM_Card_SequenceID`),
  CONSTRAINT `fk_1_user_id_sim_transa` FOREIGN KEY (`User_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `fk_2_customer_id_sim_trans` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `fk_3_sim_sequence_id_sim_cards_table` FOREIGN KEY (`SIM_Card_SequenceID`) REFERENCES `t_sim_cards_info` (`SequenceID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2616 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_sim_transactions`
--

LOCK TABLES `t_sim_transactions` WRITE;
/*!40000 ALTER TABLE `t_sim_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_sim_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_transaction_balance`
--

DROP TABLE IF EXISTS `t_transaction_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_transaction_balance` (
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Balance_Before_Transaction` float NOT NULL,
  `Balance_After_Transaction` float NOT NULL,
  PRIMARY KEY (`Transaction_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_transaction_balance`
--

LOCK TABLES `t_transaction_balance` WRITE;
/*!40000 ALTER TABLE `t_transaction_balance` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_transaction_balance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_transaction_count`
--

DROP TABLE IF EXISTS `t_transaction_count`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_transaction_count` (
  `CurrentTransactionID` bigint(100) unsigned NOT NULL,
  PRIMARY KEY (`CurrentTransactionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_transaction_count`
--

LOCK TABLES `t_transaction_count` WRITE;
/*!40000 ALTER TABLE `t_transaction_count` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_transaction_count` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_transactions`
--

DROP TABLE IF EXISTS `t_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_transactions` (
  `Sequence_ID` bigint(100) unsigned NOT NULL AUTO_INCREMENT,
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Product_ID` int(10) unsigned NOT NULL,
  `Batch_Sequence_ID` int(10) unsigned NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Quantity` int(10) unsigned NOT NULL,
  `Unit_Purchase_Price` float unsigned NOT NULL DEFAULT '0',
  `Secondary_Transaction_Price` float unsigned NOT NULL DEFAULT '0',
  `Committed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Transaction_Time` datetime NOT NULL,
  `Unit_Group_Price` float unsigned NOT NULL,
  `Batch_Unit_Price` float unsigned NOT NULL,
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Sequence_ID`) USING BTREE,
  KEY `FK_t_temp_transactions_1` (`Product_ID`),
  KEY `FK_t_temp_transactions_2` (`Customer_ID`),
  KEY `FK_t_temp_transactions_3` (`User_ID`),
  KEY `Unique_Key` (`Transaction_ID`,`Product_ID`,`Batch_Sequence_ID`),
  KEY `FK_t_transactions_4` (`Batch_Sequence_ID`),
  CONSTRAINT `FK_e64w2lbxg6aub0rkxv917llo8` FOREIGN KEY (`Transaction_ID`) REFERENCES `t_transaction_balance` (`Transaction_ID`),
  CONSTRAINT `FK_t_temp_transactions_1` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`),
  CONSTRAINT `FK_t_temp_transactions_2` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_temp_transactions_3` FOREIGN KEY (`User_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_transactions_4` FOREIGN KEY (`Batch_Sequence_ID`) REFERENCES `t_batch_information` (`SequenceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_transactions`
--

LOCK TABLES `t_transactions` WRITE;
/*!40000 ALTER TABLE `t_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_transferto_transactions`
--

DROP TABLE IF EXISTS `t_transferto_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_transferto_transactions` (
  `Sequence_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Transaction_ID` bigint(20) unsigned NOT NULL,
  `TransferTo_Transaction_ID` bigint(20) unsigned NOT NULL,
  `Error_Code` int(10) unsigned NOT NULL,
  `Error_Text` varchar(100) NOT NULL,
  `Requester_Phone` varchar(16) NOT NULL,
  `Destination_Phone` varchar(16) NOT NULL,
  `Originating_Currency` varchar(10) NOT NULL,
  `Destination_Currency` varchar(10) NOT NULL,
  `Destination_Country` varchar(50) NOT NULL,
  `Destination_Country_ID` varchar(5) NOT NULL,
  `Destination_Operator` varchar(50) NOT NULL,
  `Destination_Operator_ID` varchar(50) NOT NULL,
  `Operator_Reference_Info` varchar(100) NOT NULL,
  `SMS_Sent` varchar(5) NOT NULL,
  `SMS_Text` varchar(100) DEFAULT NULL,
  `Authentication_Key` varchar(50) NOT NULL,
  `CID1` varchar(50) DEFAULT NULL,
  `CID2` varchar(50) DEFAULT NULL,
  `CID3` varchar(50) DEFAULT NULL,
  `Product_Requested` float unsigned NOT NULL,
  `Product_Sent` float unsigned NOT NULL,
  `Wholesale_Price` float unsigned NOT NULL,
  `Retail_Price` float unsigned NOT NULL,
  `EezeeTel_Balance` float unsigned NOT NULL,
  `Customer_ID` int(10) unsigned NOT NULL,
  `User_ID` varchar(50) NOT NULL,
  `Transaction_Time` datetime NOT NULL,
  `Transaction_Status` tinyint(3) unsigned NOT NULL,
  `Cost_To_Customer` float unsigned NOT NULL,
  `Cost_To_Agent` float unsigned NOT NULL,
  `Cost_To_EezeeTel` float unsigned NOT NULL,
  `Cost_To_Group` float unsigned NOT NULL,
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Sequence_ID`),
  KEY `FK_t_transferto_transactions_1` (`Customer_ID`),
  KEY `FK_t_transferto_transactions_2` (`User_ID`) USING BTREE,
  CONSTRAINT `FK_t_transferto_transactions_1` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_transferto_transactions_2` FOREIGN KEY (`User_ID`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_transferto_transactions`
--

LOCK TABLES `t_transferto_transactions` WRITE;
/*!40000 ALTER TABLE `t_transferto_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_transferto_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_log`
--

DROP TABLE IF EXISTS `t_user_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_user_log` (
  `User_Login_ID` varchar(50) NOT NULL,
  `Login_Time` datetime NOT NULL,
  `Logout_Time` datetime DEFAULT NULL,
  `Login_Status` tinyint(3) unsigned NOT NULL,
  `SessionID` varchar(128) NOT NULL DEFAULT '0',
  PRIMARY KEY (`User_Login_ID`,`Login_Time`),
  CONSTRAINT `FK_t_user_log_1` FOREIGN KEY (`User_Login_ID`) REFERENCES `t_master_users` (`User_Login_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_log`
--

LOCK TABLES `t_user_log` WRITE;
/*!40000 ALTER TABLE `t_user_log` DISABLE KEYS */;
INSERT INTO `t_user_log` VALUES ('masteradmin','2018-01-05 19:23:23',NULL,1,'D1F29ABF9A7E9660EC064FA2BCC39B52'),('masteradmin','2018-01-08 20:53:20',NULL,1,'81981A2A3226F57291367E9541DBE258');
/*!40000 ALTER TABLE `t_user_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_vat_rates`
--

DROP TABLE IF EXISTS `t_vat_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_vat_rates` (
  `Sequence_ID` tinyint(4) NOT NULL AUTO_INCREMENT,
  `Country` varchar(50) NOT NULL,
  `Vat_Rate` float NOT NULL,
  PRIMARY KEY (`Sequence_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_vat_rates`
--

LOCK TABLES `t_vat_rates` WRITE;
/*!40000 ALTER TABLE `t_vat_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_vat_rates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_profit_table_vat`
--

DROP TABLE IF EXISTS `temp_profit_table_vat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_profit_table_vat` (
  `Customer_Group` varchar(50) DEFAULT NULL,
  `Customer` varchar(100) DEFAULT NULL,
  `Total_Sales` float unsigned DEFAULT '0',
  `Net_Sales` float DEFAULT '0',
  `VAT` float DEFAULT '0',
  `Total_Profit` float DEFAULT '0',
  `VAT_on_Profit` float DEFAULT '0',
  `Customer_Group_ID` int(10) unsigned DEFAULT NULL,
  `Customer_ID` int(10) unsigned DEFAULT NULL,
  `typeid` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_profit_table_vat`
--

LOCK TABLES `temp_profit_table_vat` WRITE;
/*!40000 ALTER TABLE `temp_profit_table_vat` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_profit_table_vat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `title`
--

DROP TABLE IF EXISTS `title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `title` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TEXT` varchar(255) NOT NULL,
  `TYPE` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `title`
--

LOCK TABLES `title` WRITE;
/*!40000 ALTER TABLE `title` DISABLE KEYS */;
/*!40000 ALTER TABLE `title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `world_topup_customer_commission`
--

DROP TABLE IF EXISTS `world_topup_customer_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `world_topup_customer_commission` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `AGENT_PERCENT` int(11) NOT NULL DEFAULT '0',
  `GROUP_PERCENT` int(11) NOT NULL DEFAULT '5',
  `CUSTOMER_ID` int(10) unsigned NOT NULL,
  `GROUP_COMMISSION_ID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_pqi5ig82wuccyl1ogxfqkcg1l` (`CUSTOMER_ID`),
  KEY `FK_t5te7y6ghkdnfgm9nqjvmbbd` (`GROUP_COMMISSION_ID`),
  CONSTRAINT `FK_pqi5ig82wuccyl1ogxfqkcg1l` FOREIGN KEY (`CUSTOMER_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t5te7y6ghkdnfgm9nqjvmbbd` FOREIGN KEY (`GROUP_COMMISSION_ID`) REFERENCES `world_topup_group_commission` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=349 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `world_topup_customer_commission`
--

LOCK TABLES `world_topup_customer_commission` WRITE;
/*!40000 ALTER TABLE `world_topup_customer_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `world_topup_customer_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `world_topup_group_commission`
--

DROP TABLE IF EXISTS `world_topup_group_commission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `world_topup_group_commission` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PERCENT` int(11) NOT NULL DEFAULT '3',
  `COUNTRY_ID` int(11) NOT NULL,
  `GROUP_ID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_94yemicmalftt58dqdjnxygb5` (`COUNTRY_ID`),
  KEY `FK_ppjwiubiyfs6ukhkj4ws3vms6` (`GROUP_ID`),
  CONSTRAINT `FK_94yemicmalftt58dqdjnxygb5` FOREIGN KEY (`COUNTRY_ID`) REFERENCES `phone_topup_country` (`ID`),
  CONSTRAINT `FK_ppjwiubiyfs6ukhkj4ws3vms6` FOREIGN KEY (`GROUP_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `world_topup_group_commission`
--

LOCK TABLES `world_topup_group_commission` WRITE;
/*!40000 ALTER TABLE `world_topup_group_commission` DISABLE KEYS */;
/*!40000 ALTER TABLE `world_topup_group_commission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'genericappdb_new'
--
/*!50003 DROP PROCEDURE IF EXISTS `DAILY_TRANSACTIONS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DAILY_TRANSACTIONS`(
	groupId INT,
	dateBegin DATETIME,
	dateEnd DATETIME,
	transactionType TEXT
)
BEGIN

DROP TEMPORARY TABLE IF EXISTS temp_daily_transaction;

CREATE TEMPORARY TABLE temp_daily_transaction (
	transactionId BIGINT, 
	transactionTime DATETIME,
	groupBalanceBefore DECIMAL(19,2) default 0.0, 
	groupBalanceAfter DECIMAL(19,2) default 0.0,
	balanceBefore DECIMAL(19,2) default 0.0, 
	balanceAfter DECIMAL(19,2) default 0.0,
	purchasePrice DECIMAL(19,2) default 0.0,
	costToGroup DECIMAL(19,2) default 0.0,
	costToAgent DECIMAL(19,2) default 0.0,
	costToCustomer DECIMAL(19,2) default 0.0,
	customer VARCHAR(50), 
	productName VARCHAR(50), 
	retailPrice DECIMAL(19,2) default 0.0,
	quantity INT unsigned
); 

IF transactionType = 'all' OR transactionType = 'card' THEN

INSERT INTO temp_daily_transaction (
	transactionId, transactionTime, 
	groupBalanceBefore, groupBalanceAfter, 
	balanceBefore, balanceAfter, 
	purchasePrice, costToGroup, costToAgent, costToCustomer, 
	customer, productName, retailPrice, quantity)

(SELECT t.Transaction_ID, t.Transaction_Time, 
	0.0, 0.0, 0.0, 0.0,
	t.Batch_Unit_Price, t.Unit_Group_Price, t.Secondary_Transaction_Price, t.Unit_Purchase_Price,
	'', '', 0.0, t.Quantity
	FROM t_transactions t 
	WHERE t.Transaction_Time BETWEEN dateBegin AND dateEnd AND t.Committed = 1 
);

INSERT INTO temp_daily_transaction (
	transactionId, transactionTime, 
	groupBalanceBefore, groupBalanceAfter, 
	balanceBefore, balanceAfter, 
	purchasePrice, costToGroup, costToAgent, costToCustomer, 
	customer, productName, retailPrice, quantity)

(SELECT t.Transaction_ID, t.Transaction_Time, 
	0.0, 0.0, 0.0, 0.0,
	t.Batch_Unit_Price, t.Unit_Group_Price, t.Secondary_Transaction_Price, t.Unit_Purchase_Price,
	'', '', 0.0, t.Quantity	
	FROM t_history_transactions t
	WHERE t.Transaction_Time BETWEEN dateBegin AND dateEnd AND t.Committed = 1
);

END IF;

SELECT * FROM temp_daily_transaction;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `genericappdb.SP_VAT_Report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `genericappdb.SP_VAT_Report`(
    dateBegin date
)
BEGIN

DECLARE makeupDate VARCHAR(50);

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

CREATE TEMPORARY TABLE temp_profit_table_vat (Customer_Group varchar(50), Customer varchar(100),
                                                    Total_Amount float unsigned default 0.0, NonVAT_Amount float unsigned default 0.0,
													VAT_Amount float unsigned default 0.0, ThreeR_Amount float unsigned default 0.0,
                                                    Total_Profit float unsigned default 0.0, VAT float default 0.0,
                                                    Customer_Group_ID int unsigned, Customer_ID int unsigned); 

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));

insert into temp_profit_table_vat
(
	select '', '', 0, 0, 0, 0,
		sum(EezeeTel_Cards_Profit + EezeeTel_Local_Mobile_Profit + EezeeTel_World_Mobile_Profit) as Profit,
		sum(EezeeTel_VAT), Customer_Group_ID, Customer_ID 
		from t_report_group_profit where Customer_Group_ID = 1 
		and Begin_Date = dateBegin
		and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
		group by Customer_ID order by Customer_ID
);

update temp_profit_table_vat t1 set Customer_Group = (select Customer_Group_Name from t_master_customer_groups t2
        where t2.Customer_Group_ID = t1.Customer_Group_ID);

update temp_profit_table_vat t1 set Customer = (select Customer_Company_Name from t_master_customerinfo t2
        where t2.Customer_ID = t1.Customer_ID);

insert into temp_profit_table_vat
(
	select '', '', 0, 0, 0, 0,
		sum(Cost_To_Group - Batch_Original_Cost) as Profit,
		sum(EezeeTel_VAT), Customer_Group_ID, 0 
		from t_report_customer_profit where Customer_Group_ID > 1 
		and Begin_Date = dateBegin
		and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
		and Product_ID != 146
		group by Customer_Group_ID order by Customer_Group_ID
);

/* EezeeTel Group Customers */

update temp_profit_table_vat t1 set Total_Amount = (select IfNull(sum(Cost_To_Agent), 0.00) from t_report_customer_profit t2
		where Customer_Group_ID = 1 and t1.Customer_ID = t2.Customer_ID and Begin_Date = dateBegin
		group by t1.Customer_ID);

update temp_profit_table_vat t1 set NonVAT_Amount = (select IfNull(sum(Cost_To_Agent), 0.00) from t_report_customer_profit t2,
		t_master_productinfo t3
		where Customer_Group_ID = 1 and t1.Customer_ID = t2.Customer_ID and Begin_Date = dateBegin
		and t2.Product_ID = t3.Product_ID and t3.Caliculate_VAT = 0 and t2.Product_ID != 146
		group by t1.Customer_ID);

update temp_profit_table_vat t1 set VAT_Amount = (select IfNull(sum(Cost_To_Agent), 0.00) from t_report_customer_profit t2,
		t_master_productinfo t3
		where Customer_Group_ID = 1 and t1.Customer_ID = t2.Customer_ID and Begin_Date = dateBegin
		and t2.Product_ID = t3.Product_ID and t3.Caliculate_VAT != 0 and t2.Product_ID != 146
		and t2.Product_ID not in (select Product_ID from t_master_productinfo where Product_Type_ID = 13)
		group by t1.Customer_ID);

update temp_profit_table_vat t1 set ThreeR_Amount = (select IfNull(sum(Cost_To_Agent), 0.00) from t_report_customer_profit t2,
		t_master_productinfo t3
		where Customer_Group_ID = 1 and t1.Customer_ID = t2.Customer_ID and Begin_Date = dateBegin
		and t2.Product_ID = t3.Product_ID and t3.Caliculate_VAT != 0 and t2.Product_ID != 146
		and t2.Product_ID in (select Product_ID from t_master_productinfo where Product_Type_ID = 13)
		group by t1.Customer_ID);

/* Other Group Customers */

update temp_profit_table_vat t1 set Total_Amount = (select IfNull(sum(Cost_To_Group), 0.00) from t_report_customer_profit t2
		where t1.Customer_Group_ID = t2.Customer_Group_ID and Begin_Date = dateBegin
		group by t1.Customer_Group_ID) where t1.Customer_Group_ID != 1;

update temp_profit_table_vat t1 set NonVAT_Amount = (select IfNull(sum(Cost_To_Group), 0.00) from t_report_customer_profit t2,
		t_master_productinfo t3
		where t1.Customer_Group_ID = t2.Customer_Group_ID and Begin_Date = dateBegin
		and t2.Product_ID = t3.Product_ID and t3.Caliculate_VAT = 0 and t2.Product_ID != 146
		group by t1.Customer_Group_ID)where t1.Customer_Group_ID != 1;


update temp_profit_table_vat t1 set VAT_Amount = (select IfNull(sum(Cost_To_Group), 0.00) from t_report_customer_profit t2,
		t_master_productinfo t3
		where t1.Customer_Group_ID = t2.Customer_Group_ID and Begin_Date = dateBegin
		and t2.Product_ID = t3.Product_ID and t3.Caliculate_VAT != 0 and t2.Product_ID != 146
		and t2.Product_ID not in (select Product_ID from t_master_productinfo where Product_Type_ID = 13)
		group by t1.Customer_Group_ID) where t1.Customer_Group_ID != 1;

update temp_profit_table_vat t1 set ThreeR_Amount = (select IfNull(sum(Cost_To_Group), 0.00) from t_report_customer_profit t2,
		t_master_productinfo t3
		where t1.Customer_Group_ID = t2.Customer_Group_ID and Begin_Date = dateBegin
		and t2.Product_ID = t3.Product_ID and t3.Caliculate_VAT != 0 and t2.Product_ID != 146
		and t2.Product_ID in (select Product_ID from t_master_productinfo where Product_Type_ID = 13)
		group by t1.Customer_Group_ID) where t1.Customer_Group_ID != 1;


update temp_profit_table_vat t1 set Customer_Group = (select Customer_Group_Name from t_master_customer_groups t2
        where t2.Customer_Group_ID = t1.Customer_Group_ID);

update temp_profit_table_vat t1 set Customer = (select Customer_Group_Name from t_master_customer_groups t2
        where t2.Customer_Group_ID = t1.Customer_Group_ID) where t1.Customer_Group_ID > 1;

select Customer_Group as 'Customer Group', Customer, IfNull(round(Total_Amount, 2), 0.00) as 'Sales', 
        IfNull(round(NonVAT_Amount, 2), 0.00) as 'Non VAT Sales', 
		IfNull(round(VAT_Amount, 2), 0.00) as 'VAT Sales',
		IfNull(round(ThreeR_Amount, 2), 0.00) as '3R Sales',
        IfNull(round(Total_Profit, 2), 0.00) as 'Profit', 
		IfNull(round(VAT, 2), 0.00) as 'VAT' from temp_profit_table_vat
    order by Customer_Group, Customer;

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Cash_Balance_Report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Cash_Balance_Report`(

durationBegin varchar(50),
durationEnd varchar(50)

)
BEGIN

declare the_pending_credit float default 0.00;

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS temp_cash_balance_table;

CREATE TEMPORARY TABLE temp_cash_balance_table (the_date date, cash_payment float default 0.00, bank_payment float default 0.00, credit_given float default 0.00,
                                                        CreditIDs varchar(512));

insert into temp_cash_balance_table (the_date) (select durationBegin);

update temp_cash_balance_table t1 set cash_payment = (select sum(payment_amount) from t_master_customer_credit where payment_type = 1 and credit_or_debit = 1
                                                             and payment_date >= cast(durationBegin as datetime) and payment_date <=  cast(durationEnd as datetime)
                                                             and Customer_ID not in (186, 28, 45));

update temp_cash_balance_table t1 set bank_payment = (select sum(payment_amount) from t_master_customer_credit where payment_type = 3 and credit_or_debit = 1
                                                             and payment_date >= cast(durationBegin as datetime) and payment_date <=  cast(durationEnd as datetime)
                                                             and Customer_ID not in (186, 28, 45));

update temp_cash_balance_table t1 set credit_given = (select sum(payment_amount) from t_master_customer_credit where credit_or_debit = 2
                                                             and Entered_Time >= cast(durationBegin as datetime) and Entered_Time <=  cast(durationEnd as datetime)
                                                             and Customer_ID not in (186, 28, 45));

select credit_given into the_pending_credit from temp_cash_balance_table;

if  the_pending_credit > 0 then

update temp_cash_balance_table set CreditIDs = (select group_concat(Credit_ID) from t_master_customer_credit where credit_or_debit = 2
                                                        and Entered_Time >= cast(durationBegin as datetime) and Entered_Time <=  cast(durationEnd as datetime)
                                                        and Customer_ID not in (186, 28, 45));

end if;


select * from temp_cash_balance_table;

DROP TEMPORARY TABLE IF EXISTS temp_cash_balance_table;
COMMIT;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Customer_AIT_Invoice_Report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Customer_AIT_Invoice_Report`(

the_customer_id  int,
durationBegin varchar(50),
durationEnd varchar(50)

)
BEGIN

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;

CREATE TEMPORARY TABLE temp_summary_table (IsHistory int, Probable_Sale_Price float default 0.00, Transaction_Amount float default 0.00,
                                                CostToAgent float default 0.00, CostToGroup float default 0.00);


insert into temp_summary_table (IsHistory, Probable_Sale_Price, Transaction_Amount, CostToAgent, CostToGroup)
(
        select 0, Retail_Price, Cost_To_Customer, Cost_To_Agent, Cost_To_Group
                        FROM t_transferto_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1) order by Transaction_ID desc
);

insert into temp_summary_table (IsHistory, Probable_Sale_Price, Transaction_Amount, CostToAgent, CostToGroup)
(
        select 1, Retail_Price, Cost_To_Customer, Cost_To_Agent, Cost_To_Group
                        FROM t_history_transferto_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1) order by Transaction_ID desc
);

insert into temp_summary_table (IsHistory, Probable_Sale_Price, Transaction_Amount, CostToAgent, CostToGroup)
(
        select 1, Retail_Price, Cost_To_Customer, Cost_To_Agent, Cost_To_Group
                        FROM t_ding_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1) order by Transaction_ID desc
);

select * from temp_summary_table;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Customer_Daily_AIT_Summary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Customer_Daily_AIT_Summary`(

the_customer_id  int,
durationBegin varchar(50),
durationEnd varchar(50),
the_user varchar(50)
)
BEGIN

DECLARE IsLatest INT DEFAULT 0;

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;

CREATE TEMPORARY TABLE temp_summary_table (IsHistory int, Transaction_ID long, Transaction_Time datetime,
                                        Balance_Before float, Balance_After float,
                                        Probable_Sale_Price float default 0.00, Transaction_Amount float default 0.00,
                                        commit_status int, Agent_Amount float default 0.00, Group_Amount float default 0.00);


if length(the_user) <= 0 then

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                    Agent_Amount, Group_Amount)
(
        select 0, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_transferto_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                    Agent_Amount, Group_Amount)
(
        select 0, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_ding_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);

else

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                Agent_Amount, Group_Amount)
(
        select 0, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_transferto_transactions where Customer_ID = the_customer_id
                        and User_ID = the_user
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                Agent_Amount, Group_Amount)
(
        select 0, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_ding_transactions where Customer_ID = the_customer_id
                        and User_ID = the_user
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);

end if;

select count(*) into IsLatest from temp_summary_table;


if IsLatest = 0 then

if length(the_user) <= 0 then

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                    Agent_Amount, Group_Amount)
(
        select 1, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_history_transferto_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);

/*insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                    Agent_Amount, Group_Amount)
(
        select 1, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_history_ding_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);*/

else

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                        Agent_Amount, Group_Amount)
(
        select 1, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_history_transferto_transactions where Customer_ID = the_customer_id
                        and User_ID = the_user
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);

/*insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Probable_Sale_Price, Transaction_Amount, commit_status,
                                        Agent_Amount, Group_Amount)
(
        select 1, Transaction_ID, Transaction_Time, Retail_Price, Cost_To_Customer, Transaction_Status, Cost_To_Agent, Cost_To_Group
                        FROM t_history_ding_transactions where Customer_ID = the_customer_id
                        and User_ID = the_user
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Transaction_Status = 1)
);*/

end if;

END IF;



if IsLatest != 0 then

update temp_summary_table t1 left outer join t_transaction_balance t2 on (t1.Transaction_ID = t2.Transaction_ID)
        set t1.Balance_Before = t2.Balance_Before_Transaction,
            t1.Balance_After = t2.Balance_After_Transaction;
else

update temp_summary_table t1 left outer join t_history_transaction_balance t2 on (t1.Transaction_ID = t2.Transaction_ID)
        set t1.Balance_Before = t2.Balance_Before_Transaction,
            t1.Balance_After = t2.Balance_After_Transaction;

end if;

select * from temp_summary_table;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Customer_Daily_SIM_Summary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Customer_Daily_SIM_Summary`(

the_customer_id  int,
durationBegin varchar(50),
durationEnd varchar(50),
the_user varchar(50)
)
BEGIN

DECLARE IsLatest INT DEFAULT 0;

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;

CREATE TEMPORARY TABLE temp_summary_table (IsHistory int, Transaction_ID long, Transaction_Time datetime,
                                           total_topups int, Customer_Commission float default 0.00,
                                           Agent_Commission float default 0.00, Group_Commission float default 0.00,
                                           Sim_Sequence_ID int unsigned default 0, Product_Name varchar(50));


if length(the_user) <= 0 then

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, total_topups, Customer_Commission, Agent_Commission,
                                    Group_Commission, Sim_Sequence_ID, Product_Name)
(
        select 0, Transaction_ID, Transaction_Time, 0, ifNull(Customer_Commission, 0), ifNull(Agent_Commission, 0), 
                        ifNull(Group_Commission, 0), SIM_Card_SequenceID, ''
                        FROM t_sim_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and Committed = 1 and Mobile_topup_Transaction_ID is NULL
);

else

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, total_topups, Customer_Commission, Agent_Commission,
                                    Group_Commission, Sim_Sequence_ID, Product_Name)
(
        select 0, Transaction_ID, Transaction_Time, 0, ifNull(Customer_Commission, 0), ifNull(Agent_Commission, 0), 
                        ifNull(Group_Commission, 0), SIM_Card_SequenceID, ''
                        FROM t_sim_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and Committed = 1 and Mobile_topup_Transaction_ID is NULL
                        and User_ID = the_user
);

end if;

update temp_summary_table t1 set total_topups = total_topups + (select ifNull(count(*), 0) from t_sim_transactions t2 where
                t1.Transaction_ID = t2.Transaction_ID and t2.Mobile_topup_Transaction_ID is not NULL);

update temp_summary_table t1 set Customer_Commission = Customer_Commission + (select sum(IfNull(Customer_Commission, 0)) from t_sim_transactions t2 where
                t1.Transaction_ID = t2.Transaction_ID and t2.Mobile_topup_Transaction_ID is not NULL);
                
update temp_summary_table t1 set Agent_Commission = Agent_Commission + (select sum(IfNull(Agent_Commission, 0)) from t_sim_transactions t2 where
                t1.Transaction_ID = t2.Transaction_ID and t2.Mobile_topup_Transaction_ID is not NULL);
                
update temp_summary_table t1 set Group_Commission = Group_Commission + (select sum(IfNull(Group_Commission, 0)) from t_sim_transactions t2 where
                t1.Transaction_ID = t2.Transaction_ID and t2.Mobile_topup_Transaction_ID is not NULL);

update temp_summary_table t1 set t1.Product_Name = 
    (select Product_Name from t_master_productinfo t2 where Product_ID = (select Product_ID from t_sim_cards_info t3 where SequenceID = t1.Sim_Sequence_ID));


select * from temp_summary_table;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Customer_Daily_Summary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Customer_Daily_Summary`(

the_customer_id  int,
durationBegin varchar(50),
durationEnd varchar(50),
the_user varchar(50)

)
BEGIN

DECLARE IsLatest INT DEFAULT 0;
DECLARE history_date DATETIME;
set @history_date = DATE_ADD(NOW(), INTERVAL -7 DAY);

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;

CREATE TEMPORARY TABLE temp_summary_table (IsHistory int, Transaction_ID long, Transaction_Time datetime,
                                        Balance_Before float, Balance_After float, Product_ID int,
                                        Product_Name varchar(100), Quantity int, Batch_ID int,
                                        Probable_Sale_Price float default 0.00, Transaction_Amount float default 0.00,
                                        Second_Amount float default 0.00, commit_status int, face_value float default 0.00,
                                        Group_Amount float default 0.00);


if length(the_user) <= 0 then

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Product_ID, Batch_ID, Quantity,
                    Transaction_Amount, Second_Amount, commit_status, Group_Amount)
(
        select 0, Transaction_ID, Transaction_Time, Product_ID, Batch_Sequence_ID, Quantity, Unit_Purchase_Price,
                        Secondary_Transaction_Price, Committed, Unit_Group_Price  FROM t_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Committed = 1 OR Committed = 3)
);

else

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Product_ID, Batch_ID, Quantity,
                    Transaction_Amount, Second_Amount, commit_status, Group_Amount)
(
        select 0, Transaction_ID, Transaction_Time, Product_ID, Batch_Sequence_ID, Quantity, Unit_Purchase_Price,
                        Secondary_Transaction_Price, Committed, Unit_Group_Price FROM t_transactions where Customer_ID = the_customer_id
                        and User_ID = the_user
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Committed = 1 OR Committed = 3)
);

end if;

select count(*) into IsLatest from temp_summary_table;

if cast(durationBegin as datetime) < @history_date then

if length(the_user) <= 0 then

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Product_ID, Batch_ID, Quantity,
                    Transaction_Amount, Second_Amount, commit_status, Group_Amount)
(
        select 1, Transaction_ID, Transaction_Time, Product_ID, Batch_Sequence_ID, Quantity, Unit_Purchase_Price,
                        Secondary_Transaction_Price, Committed, Unit_Group_Price FROM t_history_transactions where Customer_ID = the_customer_id
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Committed = 1 OR Committed = 3)
);

else

insert into temp_summary_table (IsHistory, Transaction_ID, Transaction_Time, Product_ID, Batch_ID, Quantity,
                    Transaction_Amount, Second_Amount, commit_status, Group_Amount)
(
        select 1, Transaction_ID, Transaction_Time, Product_ID, Batch_Sequence_ID, Quantity, Unit_Purchase_Price,
                        Secondary_Transaction_Price, Committed, Unit_Group_Price FROM t_history_transactions where Customer_ID = the_customer_id
                        and User_ID = the_user
                        and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
                        and (Committed = 1 OR Committed = 3)
);

end if;

END IF;

/* update balance before transaction and balance after transaction */

if IsLatest != 0 then

update temp_summary_table t1 left outer join t_transaction_balance t2 on (t1.Transaction_ID = t2.Transaction_ID)
        set t1.Balance_Before = t2.Balance_Before_Transaction,
            t1.Balance_After = t2.Balance_After_Transaction
        where IsHistory = 0;
end if;

if cast(durationBegin as datetime) < @history_date then

update temp_summary_table t1 left outer join t_history_transaction_balance t2 on (t1.Transaction_ID = t2.Transaction_ID)
        set t1.Balance_Before = t2.Balance_Before_Transaction,
            t1.Balance_After = t2.Balance_After_Transaction
        where IsHistory = 1;

end if;

update temp_summary_table t1 
        set t1.Balance_Before = 0,
            t1.Balance_After = 0 
        where t1.Balance_Before is null;

/* update probable sale price */

update temp_summary_table t1 set t1.Probable_Sale_Price = (select Probable_Sale_Price from t_batch_information t2
                                                                where t2.SequenceID = t1.Batch_ID);

update temp_summary_table t1 set t1.Probable_Sale_Price = (select Probable_Sale_Price from t_history_batch_information t2
                                                                where t2.SequenceID = t1.Batch_ID)
        where t1.Probable_Sale_Price <= 0 OR Probable_Sale_Price is null;

Update temp_summary_table t1 set Probable_Sale_Price = (select Product_Face_Value from  t_master_productinfo where Product_ID = t1.Product_ID)
        where Probable_Sale_Price <= 0 OR Probable_Sale_Price is null;

/* update product_name */

update temp_summary_table t1 left outer join t_master_productinfo t2 on (t1.Product_ID = t2.Product_ID)
        set t1.Product_Name = t2.Product_Name,
            t1.face_value = t2.Product_Face_Value;

-- update temp_summary_table t1 set Product_Name = (select Product_Name from t_master_productinfo t2 where t2.Product_ID = t1.Product_ID);

select * from temp_summary_table order by Transaction_Time asc;

DROP TEMPORARY TABLE IF EXISTS temp_summary_table;
COMMIT; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Customer_Invoice_Report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Customer_Invoice_Report`(

the_customer_id  int,
durationBegin varchar(50),
durationEnd varchar(50)

)
BEGIN

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS temp_invoice_table;

CREATE TEMPORARY TABLE temp_invoice_table (IsHistory int, Product_ID int, Batch_ID int, Probable_Sale_Price float default 0.00, 
                    Total_Amount float default 0.00, Total_Second_Amount float default 0.00, Total_Group_Amount float default 0.00, 
                    Total_Transactions int, Total_Cards int);

insert into temp_invoice_table (IsHistory, Product_ID, Batch_ID, Total_Amount, Total_Second_Amount, Total_Group_Amount, Total_Transactions, Total_Cards)
(

    select IsHistory, Product_ID, Batch_ID, sum(Total_Transaction_Amount) as Total_Amount, sum(Secondary_Transaction_Amount) as Total_Second_Amount,
            sum(Total_Group_Transaction_Amount) as Total_Group_Amount, sum(Number_of_transactions) as Total_Transactions, 
            sum(Number_of_cards) as Total_Cards from
    (
      (select 0 as IsHistory, Product_ID, Batch_Sequence_ID as Batch_ID, sum(Unit_Purchase_Price) as Total_Transaction_Amount,
                sum(Secondary_Transaction_Price) as Secondary_Transaction_Amount, sum(Unit_Group_Price) as Total_Group_Transaction_Amount, 
                count(Transaction_ID) as Number_of_transactions,
                SUM(quantity) as Number_of_cards from t_transactions
        where Committed = 1 and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
			        and Product_ID != 146 and Customer_ID = the_customer_id group by Product_ID, Batch_Sequence_ID)
		union
		(select 1 as IsHistory, Product_ID,  Batch_Sequence_ID as Batch_ID, sum(Unit_Purchase_Price) as Total_Transaction_Amount,
                sum(Secondary_Transaction_Price) as Secondary_Transaction_Amount, sum(Unit_Group_Price) as Total_Group_Transaction_Amount, 
                count(Transaction_ID) as Number_of_transactions,
                SUM(quantity) as Number_of_cards from t_history_transactions
			 where Committed = 1 and Transaction_Time >= cast(durationBegin as datetime) and Transaction_Time <= cast(durationEnd as datetime)
			        and Product_ID != 146  and Customer_ID = the_customer_id group by Product_ID, Batch_Sequence_ID)
    ) as pp

        group by Product_ID, Batch_ID order by Product_ID
);

Update temp_invoice_table t1 set Probable_Sale_Price = (select Probable_Sale_Price from  t_batch_information where SequenceId = t1.Batch_ID);
Update temp_invoice_table t1 set Probable_Sale_Price = (select Probable_Sale_Price from  t_history_batch_information where SequenceId = t1.Batch_ID) where Probable_Sale_Price <= 0 OR Probable_Sale_Price is null;
Update temp_invoice_table t1 set Probable_Sale_Price = (select Product_Face_Value from  t_master_productinfo where Product_ID = t1.Product_ID) where Probable_Sale_Price <= 0 OR Probable_Sale_Price is null;

select Product_ID, Probable_Sale_Price, sum(Total_Amount) as Total_Amount, sum(Total_Second_Amount) as Total_Second_Amount,
        sum(Total_Group_Amount) as Total_Group_Amount, sum(Total_Transactions) as Total_Transactions, sum(Total_Cards) as Total_Cards from temp_invoice_table group by Product_ID, Probable_Sale_Price;

DROP TEMPORARY TABLE IF EXISTS temp_invoice_table;
COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GetTransactionID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GetTransactionID`()
BEGIN

DECLARE cur_transaction_id BIGINT(100);

START TRANSACTION;

select CurrentTransactionID from t_transaction_count INTO cur_transaction_id FOR UPDATE;
update t_transaction_count set CurrentTransactionID = CurrentTransactionID + 1;

COMMIT;

select cur_transaction_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Money_Situation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Money_Situation`()
BEGIN

DECLARE totalDebit float unsigned default 0.0;  /* this is total money eezeetel/gsm allowed to buy by its customers */
DECLARE debitCustomers_Balance_Now float unsigned default 0.0;  /* customer balance now who took the money from eezeetel/gsm */
DECLARE totalLoanGiven float default 0.0;  /* actual money customers used from the money eezeetel/gsm has given to them.  this is the actual loan taken by customers */
DECLARE extraBalanceFromCreditCustomers float unsigned default 0.0;  /* this amount is some customers deposted exta money */
DECLARE finalCustomerState float default 0.0;  /* tells whether eezeetel should get money or has extra money from CUSTOMERS */


DECLARE debitToCustomerGroups float unsigned default 0.0;    /* customer groups debit money */
DECLARE balanceFromCustGroups float unsigned default 0.0;    /* customer groups balance */
DECLARE loanToGroups float default 0.0;             /* actual loan used by  customer groups */
DECLARE finalGroupState float default 0.0;             /* actual amount receivable from groups */

DECLARE finalState float default 0.0;        /* tells whether eezeetel should get money or has extra money */


/* CUSTOMERS */


select sum(Payment_Amount) into totalDebit from t_master_customer_credit t1, t_master_customerinfo t2
        where t1.Customer_ID = t2.Customer_ID and t2.Active_Status = 1 and t2.Customer_Group_ID in (1, 2)
        and Entered_Time >= '2012-04-01 00:00:00' and Credit_or_Debit = 2;

 select sum(Customer_Balance) into debitCustomers_Balance_Now from t_master_customerinfo where Customer_ID in (select Customer_ID from t_master_customer_credit
         where Entered_Time >= '2012-04-01 00:00:00' and Credit_or_Debit = 2) and Active_Status = 1 and Customer_Group_ID in (1, 2);

set totalLoanGiven := totalDebit - debitCustomers_Balance_Now;

select sum(Customer_Balance) into extraBalanceFromCreditCustomers from t_master_customerinfo where Customer_ID not in (select Customer_ID from t_master_customer_credit
  where Entered_Time >= '2012-04-01 00:00:00' and Credit_or_Debit = 2) and Active_Status = 1 and Customer_Group_ID in (1, 2);

set finalCustomerState  = extraBalanceFromCreditCustomers - totalLoanGiven;

/* CUSTOMER GROUPS */

select sum(Payment_Amount) into debitToCustomerGroups from t_master_customer_group_credit t1, t_master_customer_groups t2
  where t1.Customer_Group_ID = t2.Customer_Group_ID and Credit_or_Debit = 2 and t2.Customer_Group_ID > 2 and IsActive = 1;

select sum(Customer_Group_Balance) into balanceFromCustGroups from t_master_customer_groups where IsActive = 1 and Customer_Group_ID > 2;

set loanToGroups := debitToCustomerGroups - balanceFromCustGroups;
set finalGroupState := loanToGroups;


/* FINAL */

if (loanToGroups > 0) then
    set finalGroupState := finalGroupState * -1;  /*  there is pending amount from groups that we have to receive.  so it is a debt */
end if;

set finalState := finalGroupState + finalCustomerState;

select  totalDebit as Total_Debt_Allowed, debitCustomers_Balance_Now as Not_Used_Debt, totalLoanGiven as Used_Debt,
          extraBalanceFromCreditCustomers as Extra_Payments_To_Us,
          finalCustomerState as Receivable_Or_ExtraHolding_From_Customers,
          debitToCustomerGroups as Total_Debt_Allowed_To_Groups, balanceFromCustGroups as Not_Used_Debt_By_Groups,
          loanToGroups as Used_Debt_By_Groups, finalGroupState as Receivable_Or_ExtraHolding_From_Groups,
          finalState as EezeeTel_Situation;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Report_Customer_Profit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Report_Customer_Profit`(
dateBegin DATETIME,
theCustomer int unsigned,
forAll int unsigned
)
root:BEGIN

DECLARE transferToProductID INT DEFAULT 303;
DECLARE dateEnd   DATETIME;
DECLARE alreadyExists INT DEFAULT 0;
DECLARE insertValues INT DEFAULT 1;
DECLARE makeupDate VARCHAR(50);
DECLARE values_exist int unsigned default 0;

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' MONTH);
set dateEnd := TIMESTAMP(DATE(dateEnd));

if (dateBegin > CURDATE()) then
    LEAVE root;
end if;

select count(*) into alreadyExists from t_report_customer_profit 
    where Begin_Date = dateBegin and End_Date = dateEnd and Customer_ID = theCustomer;

if alreadyExists >= 1 then
IF (forAll = 0) THEN

    select * from t_report_customer_profit where Begin_Date = dateBegin 
        and End_Date = dateEnd and Customer_ID = theCustomer order by Product_ID;

END IF;

    LEAVE root;
end if;

if (MONTH(CURDATE()) = MONTH(dateBegin) AND YEAR(CURDATE()) = YEAR(dateBegin)) then
    set insertValues := 0;
end if;

DROP TEMPORARY TABLE IF EXISTS temp_profit_final_table;
DROP TEMPORARY TABLE IF EXISTS temp_profit_table;
CREATE TEMPORARY TABLE temp_profit_final_table (Product_ID int unsigned, 
                        Customer_Group_ID int unsigned, Agent_ID varchar(50), Quantity int unsigned,
                        Retail_Cost float unsigned default 0.0, Cost_To_Customer float unsigned default 0.0,
                        Cost_To_Agent float unsigned default 0.0, Cost_To_Group float unsigned default 0.0,
                        Batch_Cost float unsigned default 0.0, Batch_Original_Cost float default 0.0);
CREATE TEMPORARY TABLE temp_profit_table (IsHistory int, Product_ID int unsigned, Batch_ID int unsigned,  
                        Quantity int unsigned, Retail_Cost float unsigned default 0.0, Cost_To_Customer float unsigned default 0.0,
                        Cost_To_Agent float unsigned default 0.0, Cost_To_Group float unsigned default 0.0,
                        Batch_Cost float unsigned default 0.0, Batch_Original_Cost float default 0.0);

insert into temp_profit_table
(
    select 0, Product_ID, Batch_Sequence_ID, sum(Quantity), 0.0, sum(Unit_Purchase_Price), 
        sum(Secondary_Transaction_Price), sum(Unit_Group_Price), sum(Batch_Unit_Price), 0.0
    from t_transactions where Committed = 1 and Transaction_Time >= dateBegin and 
            Transaction_Time < dateEnd and Customer_ID = theCustomer and Product_ID != 146
    group by Batch_Sequence_ID, Product_ID
);

insert into temp_profit_table
(
    select 1, Product_ID, Batch_Sequence_ID, sum(Quantity), 0.0, sum(Unit_Purchase_Price), 
        sum(Secondary_Transaction_Price), sum(Unit_Group_Price), sum(Batch_Unit_Price), 0.0
    from t_history_transactions where Committed = 1 and Transaction_Time >= dateBegin and 
            Transaction_Time < dateEnd and Customer_ID = theCustomer and Product_ID != 146
    group by Batch_Sequence_ID, Product_ID
);

update temp_profit_table t1 set Retail_Cost = (select Probable_Sale_Price from t_batch_information t2
            where t1.Batch_ID = t2.SequenceID);
            
update temp_profit_table t1 set Retail_Cost = (select Probable_Sale_Price from t_history_batch_information t2
            where t1.Batch_ID = t2.SequenceID) where t1.Retail_Cost <= 0 OR t1.Retail_Cost is null;
            
update temp_profit_table t1 set Retail_Cost = (select Product_Face_Value from t_master_productinfo t2
            where t1.Product_ID = t2.Product_ID) where t1.Retail_Cost <= 0 OR t1.Retail_Cost is null;
            
update temp_profit_table t1 set Batch_Original_Cost = (select t2.Batch_Cost * t1.Quantity from t_batch_information t2
            where t1.Batch_ID = t2.SequenceID);
            
update temp_profit_table t1 set Batch_Original_Cost = (select t2.Batch_Cost * t1.Quantity from t_history_batch_information t2
            where t1.Batch_ID = t2.SequenceID) where t1.Batch_Original_Cost <= 0 OR t1.Batch_Original_Cost is null;
            
insert into temp_profit_table
(
        select 0, transferToProductID, 0, 1, Retail_Price, Cost_To_Customer,
                        Cost_To_Agent, Cost_To_Group, Cost_To_EezeeTel, Cost_To_EezeeTel
                        FROM t_transferto_transactions where Customer_ID = theCustomer
                        and Transaction_Time >= dateBegin and Transaction_Time < dateEnd
                        and (Transaction_Status = 1)
);

insert into temp_profit_table
(
        select 1, transferToProductID, 0, 1, Retail_Price, Cost_To_Customer,
                        Cost_To_Agent, Cost_To_Group, Cost_To_EezeeTel, Cost_To_EezeeTel
                        FROM t_history_transferto_transactions where Customer_ID = theCustomer
                        and Transaction_Time >= dateBegin and Transaction_Time < dateEnd
                        and (Transaction_Status = 1)
);

insert into temp_profit_final_table
(
    select Product_ID, 0, '', IfNull(sum(Quantity), 0), IfNull(Retail_Cost, 0),  
            IfNull(sum(Cost_To_Customer), 0), IfNull(sum(Cost_To_Agent), 0),
            IfNull(sum(Cost_To_Group), 0), IfNull(sum(Batch_Cost), 0),
            IfNull(sum(Batch_Original_Cost), 0)
    from temp_profit_table where Product_ID != transferToProductID group by Product_ID
);


insert into temp_profit_final_table
(
    select Product_ID, 0, '', IfNull(Quantity, 0), IfNull(Retail_Cost, 0), 
            IfNull(Cost_To_Customer, 0), IfNull(Cost_To_Agent, 0),
            IfNull(Cost_To_Group, 0), IfNull(Batch_Cost, 0),
            IfNull(Batch_Original_Cost, 0)
    from temp_profit_table where Product_ID = transferToProductID and Quantity > 0
);


update temp_profit_final_table t1 set Agent_ID = (select Customer_Introduced_By from t_master_customerinfo t2 where Customer_ID = theCustomer); 
update temp_profit_final_table t1 set Customer_Group_ID = (select Customer_Group_ID from t_master_customerinfo t2 where Customer_ID = theCustomer); 

select count(*) into values_exist from temp_profit_table where Quantity > 0 and Cost_To_Customer > 0;
if (values_exist <= 0) then
    leave root;
end if;

if (insertValues = 1) then

insert into t_report_customer_profit
(
    select 0, dateBegin, dateEnd, theCustomer, Customer_Group_ID, Agent_ID, Product_ID, 
        Quantity, Retail_Cost, Cost_To_Customer, Cost_To_Agent, Cost_To_Group, Batch_Cost, Batch_Original_Cost
    from temp_profit_final_table order by Product_ID
);

IF (forAll = 0) THEN

    select * from t_report_customer_profit where Begin_Date = dateBegin 
        and End_Date = dateEnd and Customer_ID = theCustomer order by Product_ID;
            
END IF;

else

IF (forAll = 0) THEN

    select 0, dateBegin, dateEnd, theCustomer, Customer_Group_ID, Agent_ID, Product_ID,
                Quantity, Retail_Cost, Cost_To_Customer, Cost_To_Agent, Cost_To_Group, Batch_Cost, Batch_Original_Cost
         from temp_profit_final_table order by Product_ID;

END IF;            

end if;

DROP TEMPORARY TABLE IF EXISTS temp_profit_final_table;
DROP TEMPORARY TABLE IF EXISTS temp_profit_table;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Report_Customer_Profit_All` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Report_Customer_Profit_All`(
dateBegin DATETIME
)
root:BEGIN

DECLARE makeupDate VARCHAR(50);
DECLARE dateEnd   DATETIME;

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' MONTH);
set dateEnd := TIMESTAMP(DATE(dateEnd));

root1:BEGIN

DECLARE theCustomer INT UNSIGNED;
DECLARE done INT DEFAULT FALSE;
DECLARE cur1 CURSOR FOR SELECT Customer_ID from t_master_customerinfo WHERE Creation_Time < dateEnd 
                and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295) order by Customer_ID;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur1;

read_loop: LOOP

    FETCH cur1 INTO theCustomer;
    IF done THEN
      LEAVE read_loop;
    END IF;
   
    call SP_Report_Customer_Profit(dateBegin, theCustomer, 1);

END LOOP;

CLOSE cur1;

END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Report_EezeeTel_Profit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Report_EezeeTel_Profit`(
    dateBegin DATETIME
)
root:BEGIN

DECLARE dateEnd   DATETIME;
DECLARE alreadyExists INT DEFAULT 0;
DECLARE insertValues INT DEFAULT 1;
DECLARE makeupDate VARCHAR(50);

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' MONTH);
set dateEnd := TIMESTAMP(DATE(dateEnd));

if (dateBegin > CURDATE()) then
    LEAVE root;
end if;

select count(*) into alreadyExists from t_report_eezeetel_profit where Begin_Date = dateBegin and End_Date = dateEnd;

if alreadyExists >= 1 then
    select * from t_report_eezeetel_profit where Begin_Date = dateBegin and End_Date = dateEnd;
    LEAVE root;
end if;

if (MONTH(CURDATE()) = MONTH(dateBegin) AND YEAR(CURDATE()) = YEAR(dateBegin)) then
    set insertValues := 0;
end if;

DROP TEMPORARY TABLE IF EXISTS temp_profit_final_table;
DROP TEMPORARY TABLE IF EXISTS temp_profit_table;
CREATE TEMPORARY TABLE temp_profit_final_table (Group_ID int, Profit_from_Cards float default 0.0, profit_from_world_mobile float default 0.0, 
                profit_from_local_mobile float default 0.0, total_customers int default 0, 
                total_cards int default 0, total_world_trans int default 0, total_local_trans int default 0);
CREATE TEMPORARY TABLE temp_profit_table (IsHistory int, Batch_ID int, Customer_ID int, Group_ID int, Quantity int, Agent_Price float default 0.0, Group_Price float default 0.0, Batch_Cost float default 0.0);

insert into temp_profit_table
(
    select 0, Batch_Sequence_ID, Customer_ID, 0, sum(Quantity), sum(Secondary_Transaction_Price), sum(Unit_Group_Price), 0.0
        from t_transactions where Committed = 1 and Transaction_Time >= dateBegin and 
            Transaction_Time < dateEnd and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
            and Product_ID != 146
            group by Batch_Sequence_ID, Customer_ID
);

insert into temp_profit_table
(
    select 1, Batch_Sequence_ID, Customer_ID, 0, sum(Quantity), sum(Secondary_Transaction_Price), sum(Unit_Group_Price), 0.0
        from t_history_transactions where Committed = 1 and Transaction_Time >= dateBegin and 
            Transaction_Time < dateEnd and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
            and Product_ID != 146
            group by Batch_Sequence_ID, Customer_ID
);

update temp_profit_table t1 set Group_ID = (select Customer_Group_ID from t_master_customerinfo where Customer_ID = t1.Customer_ID);
update temp_profit_table t1 set Batch_Cost = (select Batch_Cost from t_batch_information where SequenceID = t1.Batch_ID);
update temp_profit_table t1 set Batch_Cost = (select Batch_Cost from t_history_batch_information where SequenceID = t1.Batch_ID)
                where Batch_Cost = 0.0 OR Batch_Cost is null;
update temp_profit_table set Batch_Cost = Quantity * Batch_Cost;

/* profit from calling cards */

insert into temp_profit_final_table (Group_ID, Profit_from_Cards)
(
    select 1, IfNULL(sum(Agent_Price - Batch_Cost), 0) from temp_profit_table where Group_ID = 1
);

insert into temp_profit_final_table  (Group_ID, Profit_from_Cards)
(
    select Group_ID, IfNULL(sum(Group_Price - Batch_Cost), 0) from temp_profit_table 
        where Group_ID != 1 group by Group_ID
);

/* profit from world mobile topup */

update temp_profit_final_table t1 set profit_from_world_mobile = profit_from_world_mobile + 
    (select IfNULL(sum(Cost_To_Group - Cost_to_EezeeTel), 0) from t_transferto_transactions where Transaction_Time >= dateBegin
        and Transaction_time < dateEnd and Customer_ID in (select Customer_ID from t_master_customerinfo where Customer_Group_ID = t1.Group_ID));
        
update temp_profit_final_table t1 set profit_from_world_mobile = profit_from_world_mobile +
    (select IfNULL(sum(Cost_To_Group - Cost_to_EezeeTel), 0) from t_history_transferto_transactions where Transaction_Time >= dateBegin
        and Transaction_time < dateEnd and Customer_ID in (select Customer_ID from t_master_customerinfo where Customer_Group_ID = t1.Group_ID));

update temp_profit_final_table set total_customers = (select IfNULL(count(*), 0) from t_master_customerinfo where Active_Status = 1 and Customer_Group_ID = Group_ID
                                                                and Creation_Time < dateEnd);
update temp_profit_final_table t1 set total_cards = (select IfNULL(sum(Quantity), 0) from temp_profit_table where Group_ID = t1.Group_ID);
update temp_profit_final_table t1 set total_world_trans = (select IfNULL(count(*), 0) from t_transferto_transactions where Transaction_Time >= dateBegin
        and Transaction_time < dateEnd and Customer_ID in (select Customer_ID from t_master_customerinfo where Customer_Group_ID = t1.Group_ID));

if (insertValues = 1) then

insert into t_report_eezeetel_profit
(
    select 0, dateBegin, dateEnd, Group_ID, total_customers, Profit_from_Cards, 
        profit_from_world_mobile, profit_from_local_mobile, total_cards,
        total_world_trans, total_local_trans from temp_profit_final_table
);

select * from t_report_eezeetel_profit where Begin_Date = dateBegin and End_Date = dateEnd;

else

    select 0, dateBegin, dateEnd, Group_ID, total_customers, Profit_from_Cards, 
        profit_from_world_mobile, profit_from_local_mobile, total_cards,
        total_world_trans, total_local_trans from temp_profit_final_table;

end if;

DROP TEMPORARY TABLE IF EXISTS temp_profit_final_table;
DROP TEMPORARY TABLE IF EXISTS temp_profit_table;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Report_Group_Profit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Report_Group_Profit`(
    dateBegin DATETIME,
    theCustomer INT unsigned,
    forAll INT unsigned
)
root:BEGIN

DECLARE vat float default 1.2;
DECLARE dateEnd   DATETIME;
DECLARE alreadyExists INT DEFAULT 0;
DECLARE insertValues INT DEFAULT 1;
DECLARE makeupDate VARCHAR(50);
DECLARE theagent_id VARCHAR(50);
DECLARE group_id INT UNSIGNED DEFAULT 0;
DECLARE values_exist int unsigned default 0;
DECLARE currentMonth TINYINT UNSIGNED DEFAULT 0;

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' MONTH);
set dateEnd := TIMESTAMP(DATE(dateEnd));

if (dateBegin > CURDATE()) then
    LEAVE root;
end if;

select count(*) into alreadyExists from t_report_group_profit where Begin_Date = dateBegin and End_Date = dateEnd
        and Customer_ID = theCustomer;

if alreadyExists >= 1 then
IF (forAll = 0) THEN
    select * from t_report_group_profit where Begin_Date = dateBegin and End_Date = dateEnd and Customer_ID = theCustomer;
end if;
    LEAVE root;
    
end if;

if (MONTH(CURDATE()) = MONTH(dateBegin) AND YEAR(CURDATE()) = YEAR(dateBegin)) then
    set insertValues := 0;
    set currentMonth := 1;
end if;

DROP TEMPORARY TABLE IF EXISTS temp_profit_final_table_grp;
DROP TEMPORARY TABLE IF EXISTS temp_profit_table_grp;

CREATE TEMPORARY TABLE temp_profit_final_table_grp (Cards int unsigned, World_Mobile int unsigned, Local_Mobile int unsigned,
                                                Total_Amount float unsigned default 0.0, Total_VAT float unsigned default 0.0, 
                                                Total_NonVAT float unsigned default 0.0, Customer_Commission float unsigned default 0.0,
                                                Agent_Commission float unsigned default 0.0, Profit_From_Cards float unsigned default 0.0,
                                                Profit_From_World_Mobile float unsigned default 0.0, Profit_From_Local_Mobile float unsigned default 0.0,
                                                EezeeTel_Profit_From_Cards  float unsigned default 0.0, 
                                                EezeeTel_Profit_From_World_Mobile float unsigned default 0.0, 
                                                EezeeTel_Profit_From_Local_Mobile float unsigned default 0.0);
                                                
CREATE TEMPORARY TABLE temp_profit_table_grp (theType int unsigned, Quantity int unsigned,
                                          Total_Amount float unsigned default 0.0, Total_VAT float unsigned default 0.0, 
                                          Total_NonVAT float unsigned default 0.0, Customer_Commission float unsigned default 0.0,
                                          Agent_Commission float unsigned default 0.0, Profit float unsigned default 0.0,
                                          EezeeTel_Profit float default 0.00);

if (currentMonth = 0 ) then
                                          
    /* regular cards */

    insert into temp_profit_table_grp
    (
        select 1, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from t_report_customer_profit
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Product_Type_ID not in (13, 16) and Supplier_ID != 15)
    );

    update temp_profit_table_grp set Total_NonVAT = Total_Amount / vat where theType = 1;
    update temp_profit_table_grp set Total_VAT = Total_Amount - Total_NonVAT where theType = 1;

    /* non vat cards FNT supplier */
    insert into temp_profit_table_grp
    (
        select 2, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from t_report_customer_profit
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Supplier_ID = 15)
    );

    update temp_profit_table_grp set Total_NonVAT = Total_Amount where theType = 2;
    update temp_profit_table_grp set Total_VAT = 0 where theType = 2;

    /* world mobile topups */
    insert into temp_profit_table_grp
    (    
        select 3, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from t_report_customer_profit
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Product_Type_ID = 16)
    );

    update temp_profit_table_grp set Total_NonVAT = Total_Amount where theType = 3;
    update temp_profit_table_grp set Total_VAT = 0 where theType = 3;
        
    /* local mobile topups */
    insert into temp_profit_table_grp
    (    
        select 4, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from t_report_customer_profit
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Product_Type_ID = 13)
    );   

    update temp_profit_table_grp set Total_NonVAT = Total_Amount / vat where theType = 4;
    update temp_profit_table_grp set Total_VAT = Total_Amount - Total_NonVAT where theType = 4;

else

    START TRANSACTION;

    DROP TEMPORARY TABLE IF EXISTS customer_report_temp_table;
    CREATE TEMPORARY TABLE customer_report_temp_table (select * from t_report_customer_profit where 1 = 0);

    call SP_Report_Customer_Profit(dateBegin, theCustomer, 0, 1);

    /* regular cards */

    insert into temp_profit_table_grp
    (
        select 1, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from customer_report_temp_table
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Product_Type_ID not in (13, 16) and Supplier_ID != 15)
    );

    update temp_profit_table_grp set Total_NonVAT = Total_Amount / vat where theType = 1;
    update temp_profit_table_grp set Total_VAT = Total_Amount - Total_NonVAT where theType = 1;

    /* non vat cards FNT supplier */
    insert into temp_profit_table_grp
    (
        select 2, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from customer_report_temp_table
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Supplier_ID = 15)
    );

    update temp_profit_table_grp set Total_NonVAT = Total_Amount where theType = 2;
    update temp_profit_table_grp set Total_VAT = 0 where theType = 2;

    /* world mobile topups */
    insert into temp_profit_table_grp
    (    
        select 3, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from customer_report_temp_table
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Product_Type_ID = 16)
    );

    update temp_profit_table_grp set Total_NonVAT = Total_Amount where theType = 3;
    update temp_profit_table_grp set Total_VAT = 0 where theType = 3;
        
    /* local mobile topups */
    insert into temp_profit_table_grp
    (    
        select 4, sum(Quantity), sum(Cost_To_Customer), 0.0, 0.0, sum(Retail_Cost * Quantity - Cost_To_Customer), 
                sum(Cost_To_Customer - Cost_To_Agent), sum(Cost_To_Agent - Cost_To_Group),
                sum(Cost_To_Group - Batch_Cost) + sum(Batch_Cost - Batch_Original_Cost)
        from customer_report_temp_table
        where Customer_ID = theCustomer and Begin_Date = dateBegin and End_Date = dateEnd and Product_ID in 
            (select Product_ID from t_master_productinfo where Product_Type_ID = 13)
    );   

    update temp_profit_table_grp set Total_NonVAT = Total_Amount / vat where theType = 4;
    update temp_profit_table_grp set Total_VAT = Total_Amount - Total_NonVAT where theType = 4;
    
    DROP TEMPORARY TABLE IF EXISTS customer_report_temp_table;
    
    COMMIT;

end if;

update temp_profit_table_grp set EezeeTel_Profit = 0 where EezeeTel_Profit < 0;

/* populate cards related information */
insert into temp_profit_final_table_grp
(
    select sum(Quantity), 0, 0, sum(Total_Amount), sum(Total_VAT), sum(Total_NonVAT), 
        sum(Customer_Commission), sum(Agent_Commission),
        sum(Profit), 0.0, 0.0, sum(EezeeTel_Profit), 0.0, 0.0
    from temp_profit_table_grp where theType in (1, 2)
);

/* populate world mobile information */
update temp_profit_final_table_grp set World_Mobile = (select IfNull(sum(Quantity), 0) from temp_profit_table_grp where theType = 3);
update temp_profit_final_table_grp set Total_Amount = Total_Amount + (select IfNull(sum(Total_Amount), 0) from temp_profit_table_grp where theType = 3);
update temp_profit_final_table_grp set Total_VAT = Total_VAT + (select IfNull(sum(Total_VAT), 0) from temp_profit_table_grp where theType = 3);
update temp_profit_final_table_grp set Total_NonVAT = Total_NonVAT + (select IfNull(sum(Total_NonVAT), 0) from temp_profit_table_grp where theType = 3);
update temp_profit_final_table_grp set Customer_Commission = Customer_Commission + (select IfNull(sum(Customer_Commission), 0) from temp_profit_table_grp where theType = 3); 
update temp_profit_final_table_grp set Agent_Commission = Agent_Commission + (select IfNull(sum(Agent_Commission), 0) from temp_profit_table_grp where theType = 3); 
update temp_profit_final_table_grp set Profit_From_World_Mobile = (select IfNull(sum(Profit), 0) from temp_profit_table_grp where theType = 3);
update temp_profit_final_table_grp set EezeeTel_Profit_From_World_Mobile = (select IfNull(sum(EezeeTel_Profit), 0) from temp_profit_table_grp where theType = 3);

/* populate local mobile information */
update temp_profit_final_table_grp set Local_Mobile = (select IfNull(sum(Quantity), 0) from temp_profit_table_grp where theType = 4);
update temp_profit_final_table_grp set Total_Amount = Total_Amount + (select IfNull(sum(Total_Amount), 0) from temp_profit_table_grp where theType = 4);
update temp_profit_final_table_grp set Total_VAT = Total_VAT + (select IfNull(sum(Total_VAT), 0) from temp_profit_table_grp where theType = 4);
update temp_profit_final_table_grp set Total_NonVAT = Total_NonVAT + (select IfNull(sum(Total_NonVAT), 0) from temp_profit_table_grp where theType = 4);
update temp_profit_final_table_grp set Customer_Commission = Customer_Commission + (select IfNull(sum(Customer_Commission), 0) from temp_profit_table_grp where theType = 4); 
update temp_profit_final_table_grp set Agent_Commission = Agent_Commission + (select IfNull(sum(Agent_Commission), 0) from temp_profit_table_grp where theType = 4); 
update temp_profit_final_table_grp set Profit_From_Local_Mobile = (select IfNull(sum(Profit), 0) from temp_profit_table_grp where theType = 4);
update temp_profit_final_table_grp set EezeeTel_Profit_From_Local_Mobile = (select IfNull(sum(EezeeTel_Profit), 0) from temp_profit_table_grp where theType = 4);

select Customer_Group_ID, Customer_Introduced_By into group_id, theagent_id from t_master_customerinfo
    where Customer_ID = theCustomer;

select count(*) into values_exist from temp_profit_table_grp where Total_Amount > 0 and Quantity > 0;

if (values_exist <= 0) then
    DROP TEMPORARY TABLE IF EXISTS temp_profit_final_table_grp;
    DROP TEMPORARY TABLE IF EXISTS temp_profit_table_grp;
    leave root;
end if;

if (insertValues = 1) then

insert into t_report_group_profit
(
    select 0, dateBegin, dateEnd, theCustomer, group_id, theagent_id, IfNull(Cards, 0), IfNull(World_Mobile, 0), IfNull(Local_Mobile, 0),
        IfNull(Total_Amount, 0), IfNull(Total_VAT, 0), IfNull(Total_NonVAT, 0), IfNull(Customer_Commission, 0), IfNull(Agent_Commission, 0), IfNull(Profit_From_Cards, 0),
        IfNull(Profit_From_World_Mobile, 0), IfNull(Profit_From_Local_Mobile, 0), IfNull(EezeeTel_Profit_From_Cards, 0),
        IfNull(EezeeTel_Profit_From_World_Mobile, 0), IfNull(EezeeTel_Profit_From_Local_Mobile, 0)
    from temp_profit_final_table_grp
);

IF (forAll = 0) THEN

    select * from t_report_group_profit where Begin_Date = dateBegin and End_Date = dateEnd and Customer_ID = theCustomer;
            
END IF;

else

IF (forAll = 0) THEN

    select 0, dateBegin, dateEnd, theCustomer, group_id, theagent_id, Cards, World_Mobile, Local_Mobile,
        Total_Amount, Total_VAT, Total_NonVAT, Customer_Commission, Agent_Commission, Profit_From_Cards, 
        Profit_From_World_Mobile, Profit_From_Local_Mobile, EezeeTel_Profit_From_Cards,
        EezeeTel_Profit_From_World_Mobile, EezeeTel_Profit_From_Local_Mobile
    from temp_profit_final_table_grp;
        
   
END IF;            

end if;

DROP TEMPORARY TABLE IF EXISTS temp_profit_final_table_grp;
DROP TEMPORARY TABLE IF EXISTS temp_profit_table_grp;
-- DROP TEMPORARY TABLE IF EXISTS customer_report_temp_table;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Report_Group_Profit_All` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Report_Group_Profit_All`(
    dateBegin DATETIME
)
root:BEGIN

DECLARE makeupDate VARCHAR(50);
DECLARE dateEnd   DATETIME;

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' MONTH);
set dateEnd := TIMESTAMP(DATE(dateEnd));

root1:BEGIN

DECLARE theCustomer INT UNSIGNED;
DECLARE done INT DEFAULT FALSE;
DECLARE cur1 CURSOR FOR SELECT Customer_ID from t_master_customerinfo WHERE Creation_Time < dateEnd 
                and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295) order by Customer_ID;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur1;

read_loop: LOOP

    FETCH cur1 INTO theCustomer;
    IF done THEN
      LEAVE read_loop;
    END IF;
   
    call SP_Report_Group_Profit(dateBegin, theCustomer, 1);

END LOOP;

CLOSE cur1;

END;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Transferto_Rates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Transferto_Rates`()
BEGIN

select * from (
select Destination_Country, Destination_Operator, cast(Transaction_Time as DATE) as Transaction_Date, Product_Sent, Cost_To_EezeeTel from t_transferto_transactions p1
union
select Destination_Country, Destination_Operator, cast(Transaction_Time as DATE) as Transaction_Date, Product_Sent, Cost_To_EezeeTel from t_history_transferto_transactions p2
) as p3
order by Destination_Country, Destination_Operator, Product_Sent, Cost_To_EezeeTel, Transaction_Date desc;


/*select Destination_Country, Destination_Operator, Product_Sent, Cost_To_EezeeTel from
(
select Destination_Country, Destination_Operator, Product_Sent, Cost_To_EezeeTel from t_transferto_transactions as p1
union
select Destination_Country, Destination_Operator, Product_Sent, Cost_To_EezeeTel from t_history_transferto_transactions as p2
) as p3
group by Destination_Country, Destination_Operator, Product_Sent
order by Destination_Country, Destination_Operator, Product_Sent, Cost_To_EezeeTel;*/

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_VAT_Report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VAT_Report`(dateBegin date, grpId int)
BEGIN
DECLARE makeupDate VARCHAR(50);
DECLARE VAT_RATE float unsigned default 1.2;

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

CREATE TEMPORARY TABLE temp_profit_table_vat (Customer_Group varchar(50), Customer varchar(100),
													Total_Sales float unsigned default 0.0,
                                                    Net_Sales float default 0.0, VAT float default 0.0,
                                                    Total_Profit float default 0.0, VAT_on_Profit float default 0.0,
                                                    Customer_Group_ID int unsigned, Customer_ID int unsigned, typeid varchar(10)); 

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));

/* eezeetel vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0, IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, grpId, Customer_ID, '0'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID not in (15, 36, 37, 56, 22) and 
		Supplier_ID not in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID in (14, 16, 17))
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '0';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '0';

/* other customer groups vat products */

if grpId = 1 then
	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '0'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo where Supplier_ID not in (15, 36, 37, 56, 22) and 
			Supplier_ID not in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID in (14, 16, 17))
	) group by Customer_Group_ID);
end if;

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '0';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '0';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales / VAT_RATE
where
    typeid = '0';

update temp_profit_table_vat 
set 
    VAT = Total_Sales - Net_Sales
where
    typeid = '0';

update temp_profit_table_vat 
set 
    VAT_on_Profit = Total_Profit - Total_Profit / VAT_RATE
where
    typeid = '0';

/* eezeetel non vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
	 IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
         0, grpId, Customer_ID, '1'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (15, 36, 56)
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '1';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '1';

/* other customer groups non-vat products */

if grpId = 1 then

	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '1'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo where Supplier_ID in (15, 36, 56)
	) group by Customer_Group_ID);

end if;

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '1';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '1';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales
where
    typeid = '1';
update temp_profit_table_vat 
set 
    VAT = 0
where
    typeid = '1';
update temp_profit_table_vat 
set 
    VAT_on_Profit = 0
where
    typeid = '1';

/* eezeetel 3r products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
	IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, grpId, Customer_ID, '2'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo 
		where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '2';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '2';

/* other customer groups non-vat products */

if grpId = 1 then

	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '2'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo 
			where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
	) group by Customer_Group_ID);

end if;


update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '2';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '2';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales
where
    typeid = '2';
update temp_profit_table_vat 
set 
    VAT = 0
where
    typeid = '2';
update temp_profit_table_vat 
set 
    VAT_on_Profit = 0
where
    typeid = '2';

/* world mobile top up */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0, IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, grpId, Customer_ID, '3'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 14)
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '3';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '3';

/* other customer groups world mobile top up */

if grpId = 1 then
	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '3'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 14)
	) group by Customer_Group_ID);
end if;

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '3';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '3';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales 
where
    typeid = '3';

update temp_profit_table_vat 
set 
    VAT = 0
where
    typeid = '3';

update temp_profit_table_vat 
set 
    VAT_on_Profit = 0
where
    typeid = '3';

/* mobile unlocking */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0, IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, grpId, Customer_ID, '4'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 19)
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '4';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '4';

/* other customer groups mobile unlocking */

if grpId = 1 then
	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '4'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 19)
	) group by Customer_Group_ID);
end if;

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '4';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '4';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales 
where
    typeid = '4';

update temp_profit_table_vat 
set 
    VAT = 0
where
    typeid = '4';

update temp_profit_table_vat 
set 
    VAT_on_Profit = 0
where
    typeid = '4';

/* pinless */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0, IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, grpId, Customer_ID, '5'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 20)
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '5';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '5';

/* other customer groups pinless */

if grpId = 1 then
	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '5'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 20)
	) group by Customer_Group_ID);
end if;

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '5';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '5';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales 
where
    typeid = '5';

update temp_profit_table_vat 
set 
    VAT = 0
where
    typeid = '5';

update temp_profit_table_vat 
set 
    VAT_on_Profit = 0
where
    typeid = '5';

select 
    typeid as 'saleType',
    Customer_Group as 'group',
    Customer,
    round(Net_Sales, 2) as 'netSales',
    round(VAT, 2) as 'vat',
    round(Total_Sales, 2) as 'totalSales',
    round(Total_Profit, 2) as 'profit',
    round(VAT_on_Profit, 2) as 'vatOnProfit'
from
    temp_profit_table_vat
order by typeid , Customer_Group , Customer;



DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_VAT_Report_By_Customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VAT_Report_By_Customer`(
dateBegin date, customerid int
)
BEGIN

DECLARE makeupDate VARCHAR(50);
DECLARE VAT_RATE float unsigned default 1.2;
DECLARE grpId int unsigned default 1;

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

CREATE TEMPORARY TABLE temp_profit_table_vat (Customer_Group varchar(50), Customer varchar(100),
													Total_Sales float unsigned default 0.0,
                                                    Net_Sales float default 0.0, VAT float default 0.0,
                                                    Total_Profit varchar(20) default 0.0, VAT_on_Profit float default 0.0,
                                                    Customer_Group_ID int unsigned, Customer_ID int unsigned, typeid varchar(10),
												Product_ID int unsigned, Product_Name varchar(50), Quantity int unsigned default 0); 

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));

select Customer_Group_ID into grpId from t_master_customerinfo
		where Customer_ID = customerid;

/* eezeetel vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
	IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, Customer_Group_ID, Customer_ID, '0', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID not in (15, 36, 37, 56, 22, 60) and 
		Supplier_ID not in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID in (16, 17)))
	group by Product_ID
);

/* other customer groups vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Group), 0, 0,
        sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, Customer_ID, '0', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID not in (15, 36, 37, 56, 22, 60) and 
		Supplier_ID not in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID in (16, 17)))
	group by Product_ID
);


update temp_profit_table_vat set Net_Sales = Total_Sales / VAT_RATE  where typeid = '0';
update temp_profit_table_vat set VAT = Total_Sales - Net_Sales where typeid = '0';
update temp_profit_table_vat set VAT_on_Profit = Total_Profit - Total_Profit / VAT_RATE where typeid = '0';

/* eezeetel non vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
        IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, Customer_Group_ID, Customer_ID, '1', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (15, 36, 37, 56, 60))
	group by Product_ID
);


/* other customer groups non-vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Group), 0, 0,
		sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, Customer_ID, '1', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (15, 36, 37, 56, 60))
	group by Product_ID
);

update temp_profit_table_vat set Net_Sales = Total_Sales where typeid = '1';
update temp_profit_table_vat set VAT = 0  where typeid = '1';
update temp_profit_table_vat set VAT_on_Profit = 0  where typeid = '1';

/* eezeetel 3r products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
        IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, Customer_Group_ID, Customer_ID, '2', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo 
		where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16))
	group by Product_ID
);

/* other customer groups non-vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Group), 0, 0,
		sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, Customer_ID, '2', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo 
		where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16))
	group by Product_ID
);


update temp_profit_table_vat set Net_Sales = Total_Sales where typeid = '2';
update temp_profit_table_vat set VAT = 0  where typeid = '2';
update temp_profit_table_vat set VAT_on_Profit = 0  where typeid = '2';


/* eezeetel mobile unlocking */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
        IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, Customer_Group_ID, Customer_ID, '3', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 19))
	group by Product_ID
);


/* other customer groups mobile unlocking */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Group), 0, 0,
		sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, Customer_ID, '3', Product_ID, '', Quantity
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
	and Customer_ID = customerid
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 19))
	group by Product_ID
);

update temp_profit_table_vat set Net_Sales = Total_Sales where typeid = '3';
update temp_profit_table_vat set VAT = 0  where typeid = '3';
update temp_profit_table_vat set VAT_on_Profit = 0  where typeid = '3';


/*update temp_profit_table_vat set typeid = 'VAT Poducts' where typeid = '0';
update temp_profit_table_vat set typeid = 'Non-VAT Products' where typeid = '1';
update temp_profit_table_vat set typeid = '3R Products' where typeid = '2'; 
select sum(Total_Profit) from temp_profit_table_vat; */

update temp_profit_table_vat t1 set Customer = 
	(select Customer_Company_Name from t_master_customerinfo t2 
		where t2.Customer_ID = t1.Customer_ID);

update temp_profit_table_vat t1 set Customer_Group =
	(select Customer_Group_Name from t_master_customer_groups t2 
		where t2.Customer_Group_ID = t1.Customer_Group_ID);

update temp_profit_table_vat t1 set Product_Name =
	(select concat(Product_Name, "-", round(Product_Face_Value, 2)) from t_master_productinfo t2 
		where t2.Product_ID = t1.Product_ID);

select typeid as 'Sale Type', Customer_Group as 'Group', Customer, Product_Name as 'Product',
	round(Net_Sales, 2) as 'Net Sales',
	 round(VAT, 2) as 'VAT', round(Total_Sales, 2) as 'Total Sales', 
	 round(Total_Profit, 2) as 'Profit', round(VAT_on_Profit, 2) as 'VAT On Profit', Quantity as Quantity
	from temp_profit_table_vat order by typeid, Customer_Group, Customer, Product_Name;



DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_VAT_Report_New` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VAT_Report_New`(dateBegin date, grpId int)
BEGIN
DECLARE makeupDate VARCHAR(50);
DECLARE VAT_RATE float unsigned default 1.2;

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

CREATE TEMPORARY TABLE temp_profit_table_vat (Customer_Group varchar(50), Customer varchar(100),
													Total_Sales float unsigned default 0.0,
                                                    Net_Sales float default 0.0, VAT float default 0.0,
                                                    Total_Profit float default 0.0, VAT_on_Profit float default 0.0,
                                                    Customer_Group_ID int unsigned, Customer_ID int unsigned, typeid varchar(10)); 

set makeupDate := CONCAT(YEAR(dateBegin), '-', LPAD(MONTH(dateBegin), 2, '0'), '-01');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));

/* eezeetel vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0, IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, grpId, Customer_ID, '0'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID not in (15, 36, 37, 56, 22) and 
		Supplier_ID not in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID in (16, 17))
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '0';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '0';

/* other customer groups vat products */

if grpId = 1 then
	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '0'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo where Supplier_ID not in (15, 36, 37, 56, 22) and 
			Supplier_ID not in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID in (16, 17))
	) group by Customer_Group_ID);
end if;

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '0';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '0';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales / VAT_RATE
where
    typeid = '0';
update temp_profit_table_vat 
set 
    VAT = Total_Sales - Net_Sales
where
    typeid = '0';
update temp_profit_table_vat 
set 
    VAT_on_Profit = Total_Profit - Total_Profit / VAT_RATE
where
    typeid = '0';

/* eezeetel non vat products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
	 IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
         0, grpId, Customer_ID, '1'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo where Supplier_ID in (15, 36, 37, 56)
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '1';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '1';

/* other customer groups non-vat products */

if grpId = 1 then

	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '1'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo where Supplier_ID in (15, 36, 37, 56)
	) group by Customer_Group_ID);

end if;

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '1';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '1';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales
where
    typeid = '1';
update temp_profit_table_vat 
set 
    VAT = 0
where
    typeid = '1';
update temp_profit_table_vat 
set 
    VAT_on_Profit = 0
where
    typeid = '1';

/* eezeetel 3r products */

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Agent), 0, 0,
	IF(grpId = 1, sum(Cost_To_Agent - Batch_Original_Cost), sum(Cost_To_Agent - Cost_To_Group)),
        0, grpId, Customer_ID, '2'
	from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID = grpId
	and Product_ID in (
	select Product_ID from t_master_productinfo 
		where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
) group by Customer_ID);

update temp_profit_table_vat t1 
set 
    Customer = (select 
            Customer_Company_Name
        from
            t_master_customerinfo t2
        where
            t2.Customer_ID = t1.Customer_ID)
where
    typeid = '2';

update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '2';

/* other customer groups non-vat products */

if grpId = 1 then

	insert into temp_profit_table_vat
	(
	select '', '', sum(Cost_To_Group), 0, 0,
			sum(Cost_To_Group - Batch_Original_Cost), 0, Customer_Group_ID, 0, '2'
		from t_report_customer_profit where Begin_Date = dateBegin and Customer_Group_ID != 1
		and Product_ID in (
		select Product_ID from t_master_productinfo 
			where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
	) group by Customer_Group_ID);

end if;


update temp_profit_table_vat t1 
set 
    Customer_Group = (select 
            Customer_Group_Name
        from
            t_master_customer_groups t2
        where
            t2.Customer_Group_ID = t1.Customer_Group_ID)
where
    typeid = '2';

if grpId = 1 then
	update temp_profit_table_vat set Customer = Customer_Group where Customer_Group_ID != 1 and typeid = '2';
end if;

update temp_profit_table_vat 
set 
    Net_Sales = Total_Sales
where
    typeid = '2';
update temp_profit_table_vat 
set 
    VAT = 0
where
    typeid = '2';
update temp_profit_table_vat 
set 
    VAT_on_Profit = 0
where
    typeid = '2';


/*update temp_profit_table_vat set typeid = 'VAT Poducts' where typeid = '0';
update temp_profit_table_vat set typeid = 'Non-VAT Products' where typeid = '1';
update temp_profit_table_vat set typeid = '3R Products' where typeid = '2'; 
select sum(Total_Profit) from temp_profit_table_vat; */

select 
    typeid as 'Sale Type',
    Customer_Group as 'Group',
    Customer,
    round(Net_Sales, 2) as 'Net Sales',
    round(VAT, 2) as 'VAT',
    round(Total_Sales, 2) as 'Total Sales',
    round(Total_Profit, 2) as 'Profit',
    round(VAT_on_Profit, 2) as 'VAT On Profit'
from
    temp_profit_table_vat
order by typeid , Customer_Group , Customer;

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Year_End_Available_Stock_Report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Year_End_Available_Stock_Report`()
BEGIN

select t2.Product_Name, t3.Supplier_Name, t2.Product_Face_Value, sum(t1.Quantity) as Quantity,
	sum(t1.Available_Quantity) as Available_Quantity, t1.Unit_Purchase_Price, 
	round(sum(t1.Available_Quantity) * t1.Unit_Purchase_Price, 2) as Purchase_Price
from t_batch_information t1, t_master_productinfo t2, t_master_supplierinfo t3 
where t1.Product_ID = t2.Product_ID
	and t1.Supplier_ID = t3.Supplier_ID and Batch_Activated_By_Supplier = 1 
	and Batch_Ready_To_Sell = 1 and IsBatchActive = 1
	and Batch_Upload_Status = 'SUCCESS-BatchUpdateInDB'
	and t1.Available_Quantity > 0
	and t2.Product_ID != 146
group by t1.Supplier_ID, t1.Product_ID order by Supplier_Name, Product_Name;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Year_End_Customer_Credit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Year_End_Customer_Credit`(
yearBegin int unsigned,
theCustomer INT UNSIGNED
)
root:BEGIN

DECLARE dateBegin   DATETIME;
DECLARE dateEnd   DATETIME;
DECLARE customerSince   DATETIME;
DECLARE alreadyExists INT DEFAULT 0;
DECLARE insertValues INT DEFAULT 1;
DECLARE makeupDate VARCHAR(50);
DECLARE values_exist int unsigned default 0;
DECLARE group_id INT UNSIGNED DEFAULT 0;
DECLARE currentYear INT UNSIGNED DEFAULT 0;
DECLARE balance FLOAT unsigned DEFAULT 0;
DECLARE debitAmount FLOAT unsigned DEFAULT 0;
DECLARE creditAmount FLOAT unsigned DEFAULT 0;

set makeupDate := CONCAT(yearBegin, '-04-01 00:00:00');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' YEAR);
set dateEnd := TIMESTAMP(DATE(dateEnd));

select Creation_Time into customerSince from t_master_customerinfo where Customer_ID = theCustomer;
if (customerSince >= dateEnd) then
leave root;
end if;

select count(*) into alreadyExists from t_report_customer_credit 
    where Begin_Date = dateBegin and End_Date = dateEnd and Customer_ID = theCustomer;

if alreadyExists >= 1 then
leave root;
end if;

if (YEAR(CURDATE()) = YEAR(dateBegin)) then
leave root;
end if;

select Customer_Group_ID into group_id from t_master_customerinfo 
    where Customer_ID = theCustomer;
    
select IfNull(Customer_Balance, 0) into balance from t_master_customerinfo 
    where Customer_ID = theCustomer;

select IfNull(sum(Payment_Amount), 0) into creditAmount from t_master_customer_credit where Credit_or_Debit = 1
   and Customer_ID = theCustomer and Payment_Date >= dateBegin and Payment_Date < dateEnd;

select IfNull(sum(Payment_Amount),0) into debitAmount from t_master_customer_credit where Credit_or_Debit = 2
    and Customer_ID = theCustomer and Entered_Time >= dateBegin and Entered_Time < dateEnd;
    
insert into t_report_customer_credit
(
    select 0, dateBegin, dateEnd, theCustomer, group_id, creditAmount, debitAmount, balance
);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Year_End_Receivables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Year_End_Receivables`()
BEGIN

select t2.Customer_Company_Name as Customer, round(sum(t1.Payment_Amount), 2) as 'Payment Receivable'
from t_master_customer_credit t1, t_master_customerinfo t2
where t1.Customer_ID = t2.Customer_ID
	and t2.Active_Status = 1 and t2.Customer_Group_ID = 1
	and t1.Credit_or_Debit = 2
	and t2.Customer_ID != 28
	and Entered_Time >= '2012-04-01'
group by (t1.Customer_ID)
order by t2.Customer_Company_Name;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Year_End_VAT_Report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Year_End_VAT_Report`(
    dateBegin date,
    dateEnd date
)
BEGIN

/* DECLARE makeupDate VARCHAR(50);
DECLARE dateBegin datetime;
DECLARE dateEnd datetime;

set makeupDate := CONCAT(forYear, '-04-01 00:00:00');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' YEAR);
set dateEnd := TIMESTAMP(DATE(dateEnd)); */

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

CREATE TEMPORARY TABLE temp_profit_table_vat (Customer_Group varchar(50), Customer varchar(100),
                                                    Total_Amount float unsigned default 0.0, Total_VAT float unsigned default 0.0, 
                                                    Total_NonVAT float unsigned default 0.0, Total_Profit float default 0.0,
                                                    Customer_Group_ID int unsigned, Customer_ID int unsigned); 

insert into temp_profit_table_vat
(
select '', '', sum(Total_Amount), sum(Total_VAT), sum(Total_NonVAT),
    sum(EezeeTel_Cards_Profit + EezeeTel_Local_Mobile_Profit + EezeeTel_World_Mobile_Profit) as Profit,
    Customer_Group_ID, Customer_ID
from t_report_group_profit where Customer_Group_ID = 1 and Begin_Date >= dateBegin
    and Begin_Date < dateEnd and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
    group by Customer_ID order by Customer_ID
);

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Group) as Total_Amount,  (sum(Cost_To_Group) - sum(Cost_To_Group) / 1.2) as Total_VAT,
            0, sum(Cost_To_Group - Batch_Original_Cost) as Total_Profit,
            Customer_Group_ID, Customer_ID
from t_report_customer_profit where Customer_Group_ID > 1 and Begin_Date >= dateBegin 
    and Begin_Date < dateEnd and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
    and Product_ID not in 
    (
        select Product_ID from t_master_productinfo where Supplier_ID = 15
        union
        select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
    )
    and Product_ID not in (146, 303)
    group by Customer_ID order by Customer_ID
);

update temp_profit_table_vat t1 set Total_Amount = Total_Amount + 
    (select IfNull(sum(Cost_To_Group), 0) from t_report_customer_profit t2 
      where t1.Customer_ID = t2.Customer_ID
      and Customer_Group_ID > 1 and Begin_Date >= dateBegin and Begin_Date < dateEnd 
      and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
      and Product_ID in
      (
        select Product_ID from t_master_productinfo where Supplier_ID = 15
        union
        select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
        union
        select 303
      )
      and Product_ID != 146);
      
update temp_profit_table_vat t1 set t1.Total_NonVAT = t1.Total_Amount - t1.Total_VAT where t1.Customer_Group_ID > 1 and t1.Total_NonVAT = 0;

update temp_profit_table_vat t1 set Total_Profit = Total_Profit + 
    (select IfNull(sum(Cost_To_Group - Batch_Original_Cost), 0) from t_report_customer_profit t2 
      where t1.Customer_ID = t2.Customer_ID
      and Customer_Group_ID > 1 and Begin_Date >= dateBegin and Begin_Date < dateEnd 
      and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
      and Product_ID in
      (
        select Product_ID from t_master_productinfo where Supplier_ID = 15
        union
        select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
        union
        select 303
      )
      and Product_ID != 146);   
    
update temp_profit_table_vat t1 set Customer_Group = (select Customer_Group_Name from t_master_customer_groups t2
        where t2.Customer_Group_ID = t1.Customer_Group_ID);

update temp_profit_table_vat t1 set Customer = (select Customer_Company_Name from t_master_customerinfo t2
        where t2.Customer_ID = t1.Customer_ID);
        
select Customer_Group as 'Customer Group', Customer, round(Total_Amount, 2) as 'Total Amount', 
        round(Total_VAT, 2) as 'Total VAT', round(Total_NonVAT, 2) as 'Total Non VAT',
        round(Total_Profit, 2) as 'Total Profit' from temp_profit_table_vat
    order by Customer_Group, Customer;

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_Year_End_VAT_Report_New` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Year_End_VAT_Report_New`(
    dateBegin date,
    dateEnd date
)
BEGIN

/* DECLARE makeupDate VARCHAR(50);
DECLARE dateBegin datetime;
DECLARE dateEnd datetime;

set makeupDate := CONCAT(forYear, '-04-01 00:00:00');
set dateBegin := cast(makeupDate as DATETIME);
set dateBegin := TIMESTAMP(DATE(dateBegin));
set dateEnd := DATE_ADD(dateBegin, INTERVAL '1' YEAR);
set dateEnd := TIMESTAMP(DATE(dateEnd)); */

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

CREATE TEMPORARY TABLE temp_profit_table_vat (Customer_Group varchar(50), Customer varchar(100),
                                                    Total_Amount float unsigned default 0.0, Total_VAT float unsigned default 0.0, 
                                                    Total_NonVAT float unsigned default 0.0, Total_Profit float default 0.0,
                                                    Customer_Group_ID int unsigned, Customer_ID int unsigned); 

insert into temp_profit_table_vat
(
select '', '', sum(Total_Amount), sum(EezeeTel_VAT), 0,
    sum(EezeeTel_Cards_Profit + EezeeTel_Local_Mobile_Profit + EezeeTel_World_Mobile_Profit) as Profit,
    Customer_Group_ID, Customer_ID
from t_report_group_profit where Customer_Group_ID = 1 and Begin_Date >= dateBegin
    and Begin_Date < dateEnd and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
    group by Customer_ID order by Customer_ID
);

insert into temp_profit_table_vat
(
select '', '', sum(Cost_To_Group) as Total_Amount,  sum(EezeeTel_VAT) as Total_VAT,
            0, sum(Cost_To_Group - Batch_Original_Cost) as Total_Profit,
            Customer_Group_ID, Customer_ID
from t_report_customer_profit where Customer_Group_ID > 1 and Begin_Date >= dateBegin 
    and Begin_Date < dateEnd and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
    and Product_ID not in 
    (
        select Product_ID from t_master_productinfo where Supplier_ID = 15
        union
        select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
    )
    and Product_ID not in (146, 303)
    group by Customer_ID order by Customer_ID
);

update temp_profit_table_vat t1 set Total_Amount = Total_Amount + 
    (select IfNull(sum(Cost_To_Group), 0) from t_report_customer_profit t2 
      where t1.Customer_ID = t2.Customer_ID
      and Customer_Group_ID > 1 and Begin_Date >= dateBegin and Begin_Date < dateEnd 
      and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
      and Product_ID in
      (
        select Product_ID from t_master_productinfo where Supplier_ID = 15
        union
        select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
        union
        select 303
      )
      and Product_ID != 146);
      
update temp_profit_table_vat t1 set t1.Total_NonVAT = t1.Total_Amount - t1.Total_VAT where t1.Customer_Group_ID > 1 and t1.Total_NonVAT = 0;

update temp_profit_table_vat t1 set Total_Profit = Total_Profit + 
    (select IfNull(sum(Cost_To_Group - Batch_Original_Cost), 0) from t_report_customer_profit t2 
      where t1.Customer_ID = t2.Customer_ID
      and Customer_Group_ID > 1 and Begin_Date >= dateBegin and Begin_Date < dateEnd 
      and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
      and Product_ID in
      (
        select Product_ID from t_master_productinfo where Supplier_ID = 15
        union
        select Product_ID from t_master_productinfo where Supplier_ID in (select Supplier_ID from t_master_supplierinfo where Supplier_Type_ID = 16)
        union
        select 303
      )
      and Product_ID != 146);   
    
update temp_profit_table_vat t1 set Customer_Group = (select Customer_Group_Name from t_master_customer_groups t2
        where t2.Customer_Group_ID = t1.Customer_Group_ID);

update temp_profit_table_vat t1 set Customer = (select Customer_Company_Name from t_master_customerinfo t2
        where t2.Customer_ID = t1.Customer_ID);
        
select Customer_Group as 'Customer Group', Customer, round(Total_Amount, 2) as 'Total Amount', 
        round(Total_VAT, 2) as 'Total VAT', round(Total_NonVAT, 2) as 'Total Non VAT',
        round(Total_Profit, 2) as 'Total Profit' from temp_profit_table_vat
    order by Customer_Group, Customer;

DROP TEMPORARY TABLE IF EXISTS temp_profit_table_vat;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `VAT_Correction_Update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `VAT_Correction_Update`()
BEGIN

DECLARE fTHEVAT float default 1.2;

update t_report_customer_profit set Customer_VAT = 0, Agent_VAT = 0, Group_VAT = 0, EezeeTel_VAT = 0
	where Product_ID in (select Product_ID from t_master_productinfo where Caliculate_VAT = 0);

update t_report_customer_profit set Customer_VAT = ((Retail_Cost * Quantity)- Cost_To_Customer) - (((Retail_Cost * Quantity) - Cost_To_Customer) / fTHEVAT)
	where Product_ID != 146
	-- and Begin_Date = dateBegin 
and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
and Product_ID in (select Product_ID from t_master_productinfo where Caliculate_VAT = 1);

update t_report_customer_profit set Agent_VAT = (Cost_To_Customer - Cost_To_Agent) - ((Cost_To_Customer - Cost_To_Agent) / fTHEVAT)
	where Product_ID != 146 
	-- and Begin_Date = dateBegin 
and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
and Product_ID in (select Product_ID from t_master_productinfo where Caliculate_VAT = 1);

update t_report_customer_profit set Group_VAT = (Cost_To_Agent - Batch_Original_Cost) - ((Cost_To_Agent - Batch_Original_Cost) / fTHEVAT)
	where Product_ID != 146 
	-- and Begin_Date = dateBegin 
and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
and Product_ID in (select Product_ID from t_master_productinfo where Caliculate_VAT = 1)
and Customer_Group_ID = 1;


update t_report_customer_profit set EezeeTel_VAT = (Cost_To_Agent - Batch_Original_Cost) - ((Cost_To_Agent - Batch_Original_Cost) / fTHEVAT)
	where Product_ID != 146 
	-- and Begin_Date = dateBegin 
and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
and Product_ID in (select Product_ID from t_master_productinfo where Caliculate_VAT = 1)
and Customer_Group_ID = 1;

update t_report_customer_profit set Group_VAT = (Cost_To_Agent - Cost_To_Group) - ((Cost_To_Agent - Cost_To_Group) / fTHEVAT)
	where Product_ID != 146 
	-- and Begin_Date = dateBegin 
and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
and Product_ID in (select Product_ID from t_master_productinfo where Caliculate_VAT = 1)
and Customer_Group_ID != 1;


update t_report_customer_profit set EezeeTel_VAT = (Cost_To_Group - Batch_Original_Cost) - ((Cost_To_Group - Batch_Original_Cost) / fTHEVAT)
	where Product_ID != 146 
	-- and Begin_Date = dateBegin 
and Customer_ID not in (28, 45, 49, 70, 71, 173, 176, 179, 186, 264, 287, 295)
and Product_ID in (select Product_ID from t_master_productinfo where Caliculate_VAT = 1)
and Customer_Group_ID != 1;

update t_report_group_profit t1 set Customer_VAT = (select sum(Customer_VAT) from t_report_customer_profit t2 
		where t1.Customer_Group_ID = t2.Customer_Group_ID and t1.Customer_ID = t2.Customer_ID 
		and t1.Begin_Date = t2.Begin_Date group by t1.Customer_ID);

update t_report_group_profit t1 set Agent_VAT = (select sum(Agent_VAT) from t_report_customer_profit t2 
		where t1.Customer_Group_ID = t2.Customer_Group_ID and t1.Customer_ID = t2.Customer_ID 
		and t1.Begin_Date = t2.Begin_Date group by t1.Customer_ID);

update t_report_group_profit t1 set Group_VAT = (select sum(Group_VAT) from t_report_customer_profit t2 
		where t1.Customer_Group_ID = t2.Customer_Group_ID and t1.Customer_ID = t2.Customer_ID 
		and t1.Begin_Date = t2.Begin_Date group by t1.Customer_ID);

update t_report_group_profit t1 set EezeeTel_VAT = (select sum(EezeeTel_VAT) from t_report_customer_profit t2 
		where t1.Customer_Group_ID = t2.Customer_Group_ID and t1.Customer_ID = t2.Customer_ID 
		and t1.Begin_Date = t2.Begin_Date group by t1.Customer_ID);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-11 17:56:55
