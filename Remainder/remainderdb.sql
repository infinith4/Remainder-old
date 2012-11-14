DROP TABLE IF EXISTS `RemainderMemo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RemainderMemo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `memo` text NOT NULL,
  `tag` varchar(20),
  `rm` int(1) NOT NULL,
  `weektimes` varchar(20),
  `days` varchar(20),
  `notification` varchar(10),
  `importance` int(3),
  `created` datetime NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
