-- MySQL dump 10.13  Distrib 5.5.11, for Win32 (x86)
--
-- Host: localhost    Database: genericappdb
-- ------------------------------------------------------
-- Server version	5.5.11

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
) ENGINE=InnoDB AUTO_INCREMENT=17032 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `FK_t_card_info_1` FOREIGN KEY (`Batch_Sequence_ID`) REFERENCES `t_batch_information` (`SequenceID`),
  CONSTRAINT `FK_t_card_info_2` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3535649 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=70666 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `Commission` float unsigned NOT NULL,
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
  `Requester_Phone` varchar(16) DEFAULT NULL,
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
  CONSTRAINT `fk_customerinfo` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_usersinfo` FOREIGN KEY (`User_ID`) REFERENCES `t_master_users` (`User_Login_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9036 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `IsSold` tinyint(3) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_history_transaction_balance`
--

DROP TABLE IF EXISTS `t_history_transaction_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_history_transaction_balance` (
  `Transaction_ID` bigint(100) unsigned NOT NULL,
  `Balance_Before_Transaction` float NOT NULL,
  `Balance_After_Transaction` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `Post_Processing_Stage` tinyint(3) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=89211 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=667 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `Created_By` varchar(50) NOT NULL,
  `Notes` varchar(100) DEFAULT NULL,
  `IsActive` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `Customer_Group_Balance` float unsigned NOT NULL DEFAULT '0',
  `Check_Aganinst_Group_Balance` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `Default_Customer_ID` int(10) unsigned NOT NULL,
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
  PRIMARY KEY (`Customer_Group_ID`) USING BTREE,
  KEY `FK_t_master_customer_groups_2` (`Created_By`),
  KEY `FK_t_master_customer_groups_3` (`Default_Customer_ID`),
  CONSTRAINT `FK_t_master_customer_groups_1` FOREIGN KEY (`Default_Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_master_customer_groups_2` FOREIGN KEY (`Created_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_customer_groups_3` FOREIGN KEY (`Default_Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `Customer_Feature_ID` int(10) unsigned DEFAULT NULL,
  `Special_Printer_Customer` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Allow_Credit` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Customer_ID`),
  KEY `FK_T_Master_CustomerInfo_T_Master_Users` (`Created_By_User_ID`),
  KEY `FK_T_Master_CustomerInfo_T_Master_CustomerType` (`Customer_Type_ID`),
  KEY `FK_t_master_customerinfo_2` (`Customer_Introduced_By`),
  KEY `FK_t_master_customerinfo_4` (`Customer_Group_ID`),
  CONSTRAINT `FK_t_master_customerinfo_2` FOREIGN KEY (`Customer_Introduced_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_customerinfo_3` FOREIGN KEY (`Created_By_User_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_customerinfo_4` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`),
  CONSTRAINT `FK_T_Master_CustomerInfo_T_Master_CustomerType` FOREIGN KEY (`Customer_Type_ID`) REFERENCES `t_master_customertype` (`Customer_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=925 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`Product_ID`) USING BTREE,
  KEY `FK_t_master_productinfo_1` (`Product_Type_ID`),
  KEY `FK_t_master_productinfo_2` (`Product_Created_By`),
  KEY `FK_t_master_productinfo_3` (`Supplier_ID`),
  CONSTRAINT `FK_t_master_productinfo_1` FOREIGN KEY (`Product_Type_ID`) REFERENCES `t_master_producttype` (`Product_Type_ID`),
  CONSTRAINT `FK_t_master_productinfo_2` FOREIGN KEY (`Product_Created_By`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_master_productinfo_3` FOREIGN KEY (`Supplier_ID`) REFERENCES `t_master_supplierinfo` (`Supplier_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=413 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=327 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `Category_ID` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`Product_Type_ID`),
  KEY `category_fg_key_idx` (`Category_ID`),
  CONSTRAINT `category_fg_key` FOREIGN KEY (`Category_ID`) REFERENCES `t_master_product_category` (`Product_Category_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `FK_t_master_supplierinfo_2` FOREIGN KEY (`Supplier_Created_By_User_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_T_Master_SupplierInfo_T_Master_SupplierType` FOREIGN KEY (`Supplier_Type_ID`) REFERENCES `t_master_suppliertype` (`Supplier_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`Supplier_Type_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`Sequence_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=1156844 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`SequenceID`),
  KEY `t_report_eezeetel_profit_foreign_key_1` (`Customer_Group_ID`),
  CONSTRAINT `t_report_eezeetel_profit_foreign_key_1` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=213 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`SequenceID`),
  KEY `t_report_group_profit_foreign_key_1` (`Customer_ID`),
  KEY `t_report_group_profit_foreign_key_2` (`Customer_Group_ID`),
  CONSTRAINT `t_report_group_profit_foreign_key_1` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `t_report_group_profit_foreign_key_2` FOREIGN KEY (`Customer_Group_ID`) REFERENCES `t_master_customer_groups` (`Customer_Group_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14213 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `FK_t_temp_transactions_1` FOREIGN KEY (`Product_ID`) REFERENCES `t_master_productinfo` (`Product_ID`),
  CONSTRAINT `FK_t_temp_transactions_2` FOREIGN KEY (`Customer_ID`) REFERENCES `t_master_customerinfo` (`Customer_ID`),
  CONSTRAINT `FK_t_temp_transactions_3` FOREIGN KEY (`User_ID`) REFERENCES `t_master_users` (`User_Login_ID`),
  CONSTRAINT `FK_t_transactions_4` FOREIGN KEY (`Batch_Sequence_ID`) REFERENCES `t_batch_information` (`SequenceID`)
) ENGINE=InnoDB AUTO_INCREMENT=3432384 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-07-07  5:59:52