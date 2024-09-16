CREATE DATABASE  IF NOT EXISTS `pdv` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pdv`;
-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: pdv
-- ------------------------------------------------------
-- Server version	8.0.39

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

--
-- Table structure for table `tb_clientes`
--

DROP TABLE IF EXISTS `tb_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_clientes` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `cidade` varchar(45) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`),
  KEY `IDX_NOME_cliente` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_clientes`
--

LOCK TABLES `tb_clientes` WRITE;
/*!40000 ALTER TABLE `tb_clientes` DISABLE KEYS */;
INSERT INTO `tb_clientes` VALUES (1,'CAIQUE','JEQUIÉ','BA'),(2,'FELIPE','BELO HORIZONTE','MG'),(3,'JOÃO','SALVADOR','BA'),(4,'MARIA','SÃO PAULO','SP'),(5,'ANTÔNIO','RIO DE JANEIRO','RJ'),(6,'ALINE','BELO HORIZONTE','MG'),(7,'FRANCISCO','BRASÍLIA','DF'),(8,'CECÍLIA','FLORIANÓPOLIS','SC'),(9,'JUAREZ','AMAZONAS','AM'),(10,'MARCELO','ARACAJÚ','SE'),(11,'NATÁLIA','RIBEIRÃO PRETO','SP'),(12,'MARIANA','JEQUIÉ','BA'),(13,'TAMIRES','SALVADOR','BA'),(14,'ZACARIAS','BRASÍLIA','DF'),(15,'LUANA','PORTO ALEGRE','RS'),(16,'VILMA','GRAMADO','RS'),(17,'RICARDO','SÃO PAULO','SP'),(18,'ANA CRISTINA','RIO DE JANEIRO','RJ'),(19,'REINALDO','PORTO ALEGRE','RS'),(20,'KÁTIA','SALVADOR','BA');
/*!40000 ALTER TABLE `tb_clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_pedido_itens`
--

DROP TABLE IF EXISTS `tb_pedido_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_pedido_itens` (
  `id_pk` int NOT NULL AUTO_INCREMENT,
  `numero_pedido_fk` int NOT NULL,
  `codigo_produto_fk` int NOT NULL,
  `quantidade` decimal(10,4) NOT NULL,
  `valor_unitario` decimal(10,2) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_pk`),
  KEY `fk_pedido_item_produto_idx` (`codigo_produto_fk`),
  KEY `fk_pedido_item_pedido_idx` (`numero_pedido_fk`),
  CONSTRAINT `fk_pedido_item_pedido` FOREIGN KEY (`numero_pedido_fk`) REFERENCES `tb_pedidos` (`numero_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_item_produto` FOREIGN KEY (`codigo_produto_fk`) REFERENCES `tb_produtos` (`codigo_pk`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_pedido_itens`
--

LOCK TABLES `tb_pedido_itens` WRITE;
/*!40000 ALTER TABLE `tb_pedido_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_pedido_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_pedidos`
--

DROP TABLE IF EXISTS `tb_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_pedidos` (
  `numero_pk` int NOT NULL AUTO_INCREMENT,
  `emissao` date NOT NULL,
  `codigo_cliente_fk` int NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`numero_pk`),
  KEY `fk_pedido_cliente_idx` (`codigo_cliente_fk`),
  KEY `idx_emissao_pedido` (`emissao` DESC),
  CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`codigo_cliente_fk`) REFERENCES `tb_clientes` (`codigo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_pedidos`
--

LOCK TABLES `tb_pedidos` WRITE;
/*!40000 ALTER TABLE `tb_pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_produtos`
--

DROP TABLE IF EXISTS `tb_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_produtos` (
  `codigo_pk` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(45) NOT NULL,
  `preco_venda` decimal(10,2) NOT NULL,
  PRIMARY KEY (`codigo_pk`),
  KEY `idx_descricao_produto` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_produtos`
--

LOCK TABLES `tb_produtos` WRITE;
/*!40000 ALTER TABLE `tb_produtos` DISABLE KEYS */;
INSERT INTO `tb_produtos` VALUES (1,'BANANA',3.00),(2,'MAÇÃ',2.50),(3,'ABACAXI',5.25),(4,'KIWI',6.99),(5,'UVA',4.12),(6,'MORANGO',8.90),(7,'TOMATE',5.79),(8,'LARANJA',6.60),(9,'TANGERINA',6.70),(10,'LIMÃO',2.30),(11,'ABACATE',4.45),(12,'BATATA',3.30),(13,'PÊRA',5.50),(14,'MILHO',1.20),(15,'CEBOLA',2.15),(16,'ALHO',0.75),(17,'PIMENTA',3.29),(18,'COENTRO',1.00),(19,'ALFACE',2.00),(20,'COUVE',3.00);
/*!40000 ALTER TABLE `tb_produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-16 19:05:27
