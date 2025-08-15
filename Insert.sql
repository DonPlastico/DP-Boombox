CREATE TABLE `dp_listas_repro` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL DEFAULT '0',
	`owner` VARCHAR(255) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
)
COLLATE='utf8mb4_general_ci'
;
CREATE TABLE `dp_canciones` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`url` VARCHAR(50) NOT NULL DEFAULT '0',
	`name` VARCHAR(150) NOT NULL DEFAULT '0',
	`author` VARCHAR(50) NOT NULL DEFAULT '0',
	`maxDuration` INT NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `url` (`url`)
)
COLLATE='utf8mb4_general_ci'
;
CREATE TABLE `dp_listas_jugadores` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`license` VARCHAR(255) NOT NULL DEFAULT '',
	`playlist` INT NOT NULL DEFAULT 0,
	INDEX `license` (`license`),
	PRIMARY KEY (`id`),
	CONSTRAINT `dp_listas_jugadores` FOREIGN KEY (`playlist`) REFERENCES `dp_listas_repro` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_general_ci'
;
CREATE TABLE `dp_listas_canciones` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`playlist` INT NOT NULL DEFAULT '0',
	`song` INT NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	CONSTRAINT `dp_listas_repro` FOREIGN KEY (`playlist`) REFERENCES `dp_listas_repro` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `dp_canciones` FOREIGN KEY (`song`) REFERENCES `dp_canciones` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_general_ci'
;