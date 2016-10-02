--
-- Current Database: `temperature`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `temperature` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `temperature`;

--
-- Table structure for table `sensor_names`
--

DROP TABLE IF EXISTS `sensor_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sensor_names` (
  `sensor_id` varchar(25) NOT NULL,
  `name` varchar(255) NOT NULL,
  `volgorde` int(3) NOT NULL,
  PRIMARY KEY (`sensor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sensor_names`
--

LOCK TABLES `sensor_names` WRITE;
/*!40000 ALTER TABLE `sensor_names` DISABLE KEYS */;
INSERT INTO `sensor_names` VALUES ('28-000005006e4e','Sensor 1',2);
/*!40000 ALTER TABLE `sensor_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_log`
--

DROP TABLE IF EXISTS `temp_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_log` (
  `measurement_id` int(11) NOT NULL AUTO_INCREMENT,
  `sensor_id` varchar(25) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `timestamp` int(11) DEFAULT NULL,
  `value` varchar(50) DEFAULT NULL,
  `value_int` int(11) DEFAULT NULL,
  PRIMARY KEY (`measurement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=181135 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

