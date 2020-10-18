ALTER TABLE `characters` ADD `ark_soft_relation` varchar(45) NOT NULL;
UPDATE `characters` SET `ark_soft_relation` = `nanotrasen_relation`;
ALTER TABLE `characters` DROP COLUMN `nanotrasen_relation`;
