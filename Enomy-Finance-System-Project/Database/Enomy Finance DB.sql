-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: enomy_finance_system
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'ea55e609-f201-11f0-9233-58112294d6c7:1-4682';

--
-- Table structure for table `currency_conversion`
--

DROP TABLE IF EXISTS `currency_conversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency_conversion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userId` bigint DEFAULT NULL,
  `baseCurrency` varchar(10) DEFAULT NULL,
  `targetCurrency` varchar(10) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `result` decimal(15,2) DEFAULT NULL,
  `rate` decimal(10,6) DEFAULT NULL,
  `fee` decimal(15,2) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `currency_conversion_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency_conversion`
--

LOCK TABLES `currency_conversion` WRITE;
/*!40000 ALTER TABLE `currency_conversion` DISABLE KEYS */;
INSERT INTO `currency_conversion` VALUES (1,7,'GBP','USD',1.00,1.28,1.334100,0.04,'2026-03-18'),(2,7,'GBP','USD',1.00,1.28,1.334100,0.04,'2026-03-18'),(3,7,'GBP','USD',1.00,1.28,1.334100,0.04,'2026-03-18'),(4,7,'GBP','USD',1.00,1.28,1.334100,0.04,'2026-03-18'),(5,7,'GBP','USD',500.00,643.70,1.334100,17.50,'2026-03-18');
/*!40000 ALTER TABLE `currency_conversion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `investment_quotes`
--

DROP TABLE IF EXISTS `investment_quotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investment_quotes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `plan_type` varchar(50) NOT NULL,
  `initial_lump_sum` decimal(12,2) NOT NULL DEFAULT '0.00',
  `monthly_investment` decimal(12,2) NOT NULL,
  `plan_rules_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_investment_quotes_user` (`user_id`),
  KEY `fk_investment_quotes_plan_rules` (`plan_rules_id`),
  CONSTRAINT `fk_investment_quotes_plan_rules` FOREIGN KEY (`plan_rules_id`) REFERENCES `plan_rules` (`id`),
  CONSTRAINT `fk_investment_quotes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investment_quotes`
--

LOCK TABLES `investment_quotes` WRITE;
/*!40000 ALTER TABLE `investment_quotes` DISABLE KEYS */;
INSERT INTO `investment_quotes` VALUES (1,7,'SAVINGS_PLUS',300.00,50.00,2,'2026-03-18 20:25:41');
/*!40000 ALTER TABLE `investment_quotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plan_rules`
--

DROP TABLE IF EXISTS `plan_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_rules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_type` varchar(50) NOT NULL,
  `min_return_rate` decimal(6,4) NOT NULL,
  `max_return_rate` decimal(6,4) NOT NULL,
  `monthly_fee_rate` decimal(6,4) NOT NULL,
  `yearly_investment_limit` decimal(12,2) DEFAULT NULL,
  `min_monthly_required` decimal(12,2) NOT NULL,
  `min_initial_required` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tax_settings_id` bigint NOT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_plan_rules_tax` (`tax_settings_id`),
  CONSTRAINT `fk_plan_rules_tax` FOREIGN KEY (`tax_settings_id`) REFERENCES `tax_settings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plan_rules`
--

LOCK TABLES `plan_rules` WRITE;
/*!40000 ALTER TABLE `plan_rules` DISABLE KEYS */;
INSERT INTO `plan_rules` VALUES (1,'BASIC_SAVINGS',0.0120,0.0240,0.0025,20000.00,50.00,0.00,1,1,'2026-03-18 20:15:00'),(2,'SAVINGS_PLUS',0.0300,0.0550,0.0030,30000.00,50.00,300.00,2,1,'2026-03-18 20:15:00'),(3,'MANAGED_STOCKS',0.0400,0.2300,0.0130,NULL,150.00,1000.00,3,1,'2026-03-18 20:15:00');
/*!40000 ALTER TABLE `plan_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rate_snapshot`
--

DROP TABLE IF EXISTS `rate_snapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rate_snapshot` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `baseCurrency` varchar(10) DEFAULT NULL,
  `targetCurrency` varchar(10) DEFAULT NULL,
  `rate` decimal(10,6) DEFAULT NULL,
  `lastSynced` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `currency_pair` (`baseCurrency`,`targetCurrency`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate_snapshot`
--

LOCK TABLES `rate_snapshot` WRITE;
/*!40000 ALTER TABLE `rate_snapshot` DISABLE KEYS */;
INSERT INTO `rate_snapshot` VALUES (1,'GBP','USD',1.334100,'Mar 17, 2026 • 11:00 PM');
/*!40000 ALTER TABLE `rate_snapshot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tax_settings`
--

DROP TABLE IF EXISTS `tax_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax_settings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tax_type` varchar(20) NOT NULL,
  `tax_free_allowance` decimal(12,2) NOT NULL DEFAULT '0.00',
  `lower_tax_rate` decimal(6,4) NOT NULL DEFAULT '0.0000',
  `lower_tax_threshold` decimal(12,2) DEFAULT NULL,
  `upper_tax_rate` decimal(6,4) NOT NULL DEFAULT '0.0000',
  `upper_tax_threshold` decimal(12,2) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tax_settings`
--

LOCK TABLES `tax_settings` WRITE;
/*!40000 ALTER TABLE `tax_settings` DISABLE KEYS */;
INSERT INTO `tax_settings` VALUES (1,'NONE',0.00,0.0000,NULL,0.0000,NULL,1,'2026-03-18 20:14:54'),(2,'FLAT',12000.00,0.1000,NULL,0.0000,NULL,1,'2026-03-18 20:14:54'),(3,'PROGRESSIVE',12000.00,0.1000,40000.00,0.2000,40000.00,1,'2026-03-18 20:14:54');
/*!40000 ALTER TABLE `tax_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `full_name` (`full_name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'nissa','nissa@eno.com','$2a$10$za5onlhDzUHS.Bzp6oRmN.1./MVj7J2r9IGOnMwJ/tIEuLjZabWmq','ADMIN',1,'2026-03-12 10:45:14'),(3,'hakdog','hakdog@enomy.com','$2a$10$q.9GyGai3aqtQS./epaV5Ol4EsathNK6xkThINxd.hUJeo/agLz52','CLIENT',1,'2026-03-12 12:44:17'),(4,'gwapako','gwapa@enomy.com','$2a$10$kqM7FJVjRh.hDqzNT5h7heWflHTQMtgrU2uWCjN8uPiGFr0grNDqa','CLIENT',1,'2026-03-12 12:51:39'),(5,'haha','haha@test.com','$2a$10$bd08vcmwfLkk.dfnELbiKuFxz/5wmwo5qxAsyW7eRFT1h2xBQwISO','CLIENT',1,'2026-03-12 13:38:45'),(7,'Nissa Pacs','nissa@enomy.com','$2a$10$/9CdKmLS4esAsZzk7bWrzexJrpdf.Py94VdUz6WERmaC0utH6ZQ1e','CLIENT',1,'2026-03-18 09:37:53');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-19  4:38:58
