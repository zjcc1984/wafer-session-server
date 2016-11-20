create database cAuth;
use cAuth;

DROP TABLE IF EXISTS `cAppinfo`;
CREATE TABLE `cAppinfo` (
  `appid` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `secret` varchar(300) COLLATE utf8_unicode_ci NOT NULL,
  `login_duration` int(11) DEFAULT '30',
  `session_duration` int(11) DEFAULT '3600',
   PRIMARY KEY (`appid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `cSessioninfo`;
CREATE TABLE `cSessioninfo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `skey` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `create_time` int(11) NOT NULL,
  `last_visit_time` int(11) NOT NULL,
  `open_id` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `session_key` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `user_info` text COLLATE utf8_unicode_ci,
   KEY `auth` (`id`,`skey`),
   KEY `wexin` (`open_id`,`session_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
