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
