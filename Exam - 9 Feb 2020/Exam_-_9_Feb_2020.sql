CREATE DATABASE `fsd`;
USE `fsd`;

CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `country_id` INT NOT NULL,
    CONSTRAINT `fk_towns_countries`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries`(`id`) 
);

CREATE TABLE `stadiums`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `capacity` INT NOT NULL,
    `town_id` INT  NOT NULL,
    CONSTRAINT `fk_stadiums_towns`
    FOREIGN KEY (`town_id`)
    REFERENCES `towns`(`id`) 
);

CREATE TABLE `teams`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
	`established` DATE NOT NULL,
    `fan_base` BIGINT NOT NULL DEFAULT 0,
    `stadium_id` INT NOT NULL,
    CONSTRAINT `fk_teams_stadiums`
    FOREIGN KEY (`stadium_id`)
    REFERENCES `stadiums`(`id`)
);

CREATE TABLE `skills_data`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `dribbling` INT DEFAULT 0,
    `pace` INT DEFAULT 0,
    `passing` INT DEFAULT 0,
    `shooting` INT DEFAULT 0,
    `speed` INT DEFAULT 0,
    `strength` INT DEFAULT 0
);

CREATE TABLE `players`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `age` INT NOT NULL,
    `position` CHAR(1) NOT NULL,
    `salary` DECIMAL(10, 2) NOT NULL,
    `hire_date` DATETIME,
    `skills_data_id` INT NOT NULL,
    `team_id` INT,
    CONSTRAINT `fk_players_teams`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams`(`id`),
    CONSTRAINT `fk_players_skills_data`
    FOREIGN KEY (`skills_data_id`)
    REFERENCES `skills_data`(`id`)
);

CREATE TABLE `coaches`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `salary` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    `coach_level` INT NOT NULL DEFAULT 0
);

CREATE TABLE `players_coaches`(
	`player_id` INT,
    `coach_id` INT,
    CONSTRAINT `fk_players_coaches_players`
    FOREIGN KEY (`player_id`)
    REFERENCES `players`(`id`),
    CONSTRAINT `fk_players_coaches_coaches`
    FOREIGN KEY (`coach_id`)
    REFERENCES `coaches`(`id`)
);

#EX2
INSERT INTO `coaches` (`first_name`, `last_name`, `salary`, `coach_level`)
SELECT 
    `first_name`,
    `last_name`,
    `salary`,
    LENGTH(`first_name`) AS `coach_level`
    FROM`players`
    WHERE `age` >= 45;

#EX3
UPDATE `coaches`
SET `coach_level` = `coach_level` + 1
WHERE `id` = (
	SELECT `coach_id`
    FROM `players_coaches`
    WHERE `coach_id` = `id`
    LIMIT 1
) AND `first_name` LIKE 'A%';

#EX4
DELETE FROM `players`
WHERE `age` >= 45;

#EX5
SELECT
`first_name`,
`age`,
`salary`
FROM `players`
ORDER BY `salary` DESC;

#EX6
SELECT
`p`.`id`,
CONCAT_WS(' ', `p`.`first_name`, `p`.`last_name`) AS `full_name`,
`p`.`age`,
`p`.`position`,
`p`.`hire_date`
FROM `players` AS `p`
JOIN `skills_data` AS `sd`
ON `p`.`skills_data_id` = `sd`.`id`
WHERE `p`.`age` < 23 
AND `p`.`position` = 'A'
AND `p`.`hire_date` IS NULL
AND `sd`.`strength` > 50
ORDER BY `salary` ASC, `age`; 

#EX7
SELECT
`t`.`name` AS `team_name`,
`t`.`established`,
`t`.`fan_base`,
(
	SELECT COUNT(*) 
    FROM `players`
    WHERE `t`.`id` = `team_id`
) AS `count_of_players`
FROM `teams` AS `t`
GROUP BY `id`
ORDER BY `count_of_players` DESC, `t`.`fan_base` DESC;

#EX8
SELECT
MAX(`sd`.`speed`) AS `max_speed`,
`t`.`name` AS `town_name`
FROM `players` AS `p`
JOIN `skills_data` AS `sd`
ON `p`.`skills_data_id` = `sd`.`id`
RIGHT JOIN `teams`
ON `teams`.`id` = `p`.`team_id` 
JOIN `stadiums` AS `s`
ON `s`.`id` = `teams`.`stadium_id`
JOIN `towns` AS `t`
ON `t`.`id` = `s`.`town_id`
WHERE `teams`.`name` != 'Devify'
GROUP BY `t`.`name`
ORDER BY `max_speed` DESC, `town_name`;

#EX9
SELECT
`c`.`name`,
COUNT(`p`.`id`) AS `total_count_of_players`,
SUM(`p`.`salary`) AS `total_sum_of_salaries`
FROM `players` AS `p`
RIGHT JOIN `teams`
ON `teams`.`id` = `p`.`team_id` 
RIGHT JOIN `stadiums` AS `s`
ON `s`.`id` = `teams`.`stadium_id`
RIGHT JOIN `towns` AS `t`
ON `t`.`id` = `s`.`town_id`
RIGHT JOIN `countries` AS `c`
ON `c`.`id` = `t`.`country_id`
GROUP BY `c`.`id`
ORDER BY `total_count_of_players` DESC, `c`.`name`;

#EX10
DELIMITER $$
CREATE FUNCTION `udf_stadium_players_count` (`stadium_name` VARCHAR(30))
RETURNS INTEGER
DETERMINISTIC
BEGIN

	DECLARE `result` INT;
    SET `result` := (
		SELECT
		COUNT(`p`.`id`)
		FROM `players` AS `p`
		JOIN `teams`
		ON `teams`.`id` = `p`.`team_id` 
		JOIN `stadiums` AS `s`
		ON `s`.`id` = `teams`.`stadium_id`
		WHERE `s`.`name` = `stadium_name`
    );

RETURN `result`;
END$$
DELIMITER ;
SELECT udf_stadium_players_count ('Linklinks') as `count`;
SELECT udf_stadium_players_count ('Jaxworks') as `count`; 

#EX11
DELIMITER $$
CREATE PROCEDURE `udp_find_playmaker` (`min_dribble_points` INT, `team_name` VARCHAR(45))
BEGIN

		SELECT 
		CONCAT_WS(' ', `p`.`first_name`, `p`.`last_name`) AS `full_name`,
        `p`.`age`,
		`p`.`salary`,
        `sd`.`dribbling`,
        `sd`.`speed`,
        `t`.`name` AS `team_name`
		FROM `players` AS `p`
		JOIN `skills_data` AS `sd`
		ON `p`.`skills_data_id` = `sd`.`id`
		JOIN `teams` AS `t`
		ON `t`.`id` = `p`.`team_id` 
		JOIN `stadiums` AS `s`
        WHERE `sd`.`dribbling` > `min_dribble_points`
        AND `t`.`name` = `team_name`
        AND `sd`.`speed` > (SELECT AVG(`speed`)FROM `skills_data`)
        ORDER BY `speed` DESC
        LIMIT 1;

END$$
DELIMITER ;
CALL `udp_find_playmaker` (20, 'Skyble');