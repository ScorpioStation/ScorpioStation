USE `scorpio`;

-- Removes player poll tables and old feedback table
DROP TABLE `feedback`;
DROP TABLE `poll_option`;
DROP TABLE `poll_question`;
DROP TABLE `poll_textreply`;
DROP TABLE `poll_vote`;

-- Create new feedback table
CREATE TABLE `feedback` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL,
  `round_id` int(8) NOT NULL,
  `key_name` varchar(32) NOT NULL,
  `key_type` enum('text', 'amount', 'tally', 'nested tally', 'associative') NOT NULL,
  `version` tinyint(3) UNSIGNED NOT NULL,
  `json` LONGTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- Create new round table for tracking round information
CREATE TABLE `round` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `initialize_datetime` DATETIME NOT NULL,
  `start_datetime` DATETIME NULL,
  `shutdown_datetime` DATETIME NULL,
  `end_datetime` DATETIME NULL,
  `server_ip` INT(10) UNSIGNED NOT NULL,
  `server_port` SMALLINT(5) UNSIGNED NOT NULL,
  `commit_hash` CHAR(40) NULL,
  `game_mode` VARCHAR(32) NULL,
  `game_mode_result` VARCHAR(64) NULL,
  `end_state` VARCHAR(64) NULL,
  `shuttle_name` VARCHAR(64) NULL,
  `map_name` VARCHAR(32) NULL,
  `station_name` VARCHAR(80) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
