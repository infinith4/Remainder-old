CREATE TABLE `UsersBookmark` (
`id` int(255) NOT NULL AUTO_INCREMENT,/*user 数*/
`userid` int(50) NOT NULL,/*user id こちらでつける*/
`email` varchar(100),/* user email NOT NULL?*/
`created` datetime,
`updated` datetime,
`lastaccess` datetime,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `Bookmark` (
`id` int(255) NOT NULL AUTO_INCREMENT,/*bookmark 数*/
`userid` int(50) NOT NULL,/*user id こちらでつける*/
`tag` varchar(100),
`bookmarkid` char(255),
`title` char(255),
`times` int(20),
`reltag` varchar(255),
`created` datetime,
`updated` datetime,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `BookmarkSetting` (
`id` int(255) NOT NULL AUTO_INCREMENT,/*user 数*/
`userid` int(50) NOT NULL,/*user id こちらでつける*/
`email` varchar(100),/* user email NOT NULL?*/
`tag` varchar(100),/* user email NOT NULL?*/
`remindnum` varchar(20),
`reltag` varchar(100),
`days` varchar(50),
`hour` int(10),
`minute` int(10),
`created` datetime,
`updated` datetime,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


