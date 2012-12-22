/*DROP TABLE IF EXISTS `RemainderUsers`;*/
CREATE TABLE `RemainderUsers` (
`userid` int(10) NOT NULL AUTO_INCREMENT,
`email` varchar(100),/* user email NOT NULL?*/
`user_name` varchar(20),
`created` datetime NOT NULL, /* 作成日 */
`logindated` datetime NOT NULL, /* 最終ログイン日 */
`logincount` int(10),
PRIMARY KEY (`userid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `RemainderUsers` WRITE;
/*!40000 ALTER TABLE `RemainderUsers` DISABLE KEYS */;
INSERT INTO `RemainderUsers` VALUES 
('1','tashirohiro4@gmail.com','tashirohiro4','2012-12-01 22:23:00','2012-12-01 22:23:00','0');
UNLOCK TABLES;

DROP TABLE IF EXISTS `RemainderMemo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RemainderMemo` (
  `id` int(11) NOT NULL AUTO_INCREMENT, /* 自動でインクリメントされる */
  `userid` varchar(50) NOT NULL, /* */
  `memo` text NOT NULL, /* remaind内容 */
  `tag` varchar(20),    /* すぐやる,完了,ほしい物,参考,勉強,英語 */
  `rm` int(1) NOT NULL, /* 削除されているなら1,そうでないなら0 */
  `fromtime` datetime NOT NULL, /* 送信開始日:YYYY-MM-DD HH:MM:SS */
  `totime` datetime NOT NULL,   /* 送信終了日:YYYY-MM-DD HH:MM:SS */
  `days` varchar(20),   /* 曜日の指定(mon,tue,fri,etc)*/
  `notification` varchar(10),   /* 知らせない:non,メール:mail or ポップアップ:popup(今後) */
  `importance` int(3),  /* 重要:2,普通:1,微妙:0 */
  `created` datetime NOT NULL, /* 作成日 */
  `updated` datetime NOT NULL, /* memoの更新日 */
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `RemainderMemo` WRITE;
/*!40000 ALTER TABLE `RemainderMemo` DISABLE KEYS */;
INSERT INTO `RemainderMemo` VALUES 
('1','tashirohiro4','3ステップで学ぶ MySQL入門','ほしい物,mysql,web開発','0','2012-12-01 22:20:00','2012-12-12 22:33:00','Sun,Mon,Wed,Sat','mail','2','2012-12-01 22:23:00','2012-12-01 22:23:00'),
('2','tashirohiro4','perl入門','ほしい物,perl,web開発','0','2012-12-02 00:20:00','2012-12-19 22:33:00','Sun,Mon,Wed','mail','2','2012-12-02 22:23:00','2012-12-02 22:23:00'),
('3','tashirohiro4','XML入門','ほしい物,web開発','0','2012-12-02 01:22:00','2012-12-19 22:33:00','Sun,Tue,Wed,Sat','mail','2','2012-12-02 01:23:00','2012-12-02 01:23:00'),
('4','tashirohiro4','mysql入門','ほしい物,mysql,web開発','0','2012-12-02 02:12:00','2012-12-21 20:33:00','Sun,Mon,Wed','mail','2','2012-12-02 02:23:00','2012-12-02 02:23:00'),
('5','tashirohiro4','Apache入門','web開発,apache,server,ほしい物','0','2012-12-03 20:20:00','2012-12-19 22:33:00','Sun,Thu','mail','2','2012-12-03 20:23:00','2012-12-03 20:23:00');
/*!40000 ALTER TABLE `RemainderMemo` ENABLE KEYS */;
UNLOCK TABLES;


