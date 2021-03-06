CREATE DATABASE `stc`;
USE `stc`;

CREATE TABLE `drivers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `age` INT NOT NULL,
    `rating` FLOAT DEFAULT 5.5
);

CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL
);

CREATE TABLE `cars`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `make` VARCHAR(20) NOT NULL,
    `model` VARCHAR(20),
    `year` INT NOT NULL DEFAULT 0,
    `mileage` INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    `category_id` INT NOT NULL,
    CONSTRAINT `fk_cars_categories`
    FOREIGN KEY (`category_id`)
    REFERENCES `categories`(`id`)
);

CREATE TABLE `cars_drivers`(
	`car_id` INT NOT NULL,
	`driver_id` INT NOT NULL,
    CONSTRAINT `pk_cars_drivers`
    PRIMARY KEY (`car_id`, `driver_id`),
	CONSTRAINT `fk_cars_drivers_cars`
    FOREIGN KEY (`car_id`)
    REFERENCES `cars`(`id`),
	CONSTRAINT `fk_cars_drivers_drivers`
    FOREIGN KEY (`driver_id`)
    REFERENCES `drivers`(`id`)
);

CREATE TABLE `addresses`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL
);

CREATE TABLE `clients`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `full_name` VARCHAR(50) NOT NULL,
    `phone_number` VARCHAR(20) NOT NULL
);

CREATE TABLE `courses`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `from_address_id` INT NOT NULL,
    `start` DATETIME NOT NULL,
    `bill` DECIMAL(10, 2) DEFAULT 10,
	`car_id` INT NOT NULL,
	`client_id` INT NOT NULL,
    CONSTRAINT `fk_courses_addresses`
    FOREIGN KEY (`from_address_id`)
    REFERENCES `addresses`(`id`),
    CONSTRAINT `fk_courses_cars`
    FOREIGN KEY (`car_id`)
    REFERENCES `cars`(`id`),
    CONSTRAINT `fk_courses_clients`
    FOREIGN KEY (`client_id`)
    REFERENCES `clients`(`id`)
);

#EX2
INSERT INTO `clients` (`full_name`, `phone_number`)
SELECT
	CONCAT_WS(' ', `first_name`, `last_name`) AS `full_name`,
    CONCAT('(088) 9999', `id` * 2) AS `phone_number`
    FROM `drivers`
    WHERE `id` BETWEEN 10 AND 20;
    
#EX3
UPDATE `cars`
SET `condition` = 'C'
WHERE (`mileage` >  800000
OR `mileage` IS NULL)
AND `year` <= 2010
AND `make` != 'Mercedes-Benz';

#EX4
DELETE FROM `clients`
WHERE `id` NOT IN (
	SELECT 
	`client_id`
	FROM `courses`
	WHERE `client_id` != `id`
)
AND LENGTH(`full_name`) > 3;

#EX5
SELECT
`make`,
`model`,
`condition`
FROM `cars`
ORDER BY `id`;

#EX6
SELECT
`first_name`,
`last_name`,
`make`,
`model`,
`mileage`
FROM `drivers` AS `d`
JOIN `cars_drivers` AS `cd`
ON `d`.`id` = `cd`.`driver_id`
JOIN `cars` AS `c`
ON `c`.`id` = `cd`.`car_id`
WHERE `mileage` IS NOT NULL
ORDER BY `mileage` DESC, `first_name` ASC;

#EX7
SELECT
`cars`.`id` AS `car_id`,
`cars`.`make`,
`cars`.`mileage`,
COUNT(`c`.`id`) AS `count_of_courses`,
ROUND(AVG(`c`.`bill`), 2) AS `avg_bill`
FROM `cars`
LEFT JOIN `courses` AS `c`
ON `c`.`car_id` = `cars`.`id`
GROUP BY `cars`.`id`
HAVING `count_of_courses` != 2
ORDER BY `count_of_courses` DESC, `cars`.`id`;

#EX8
SELECT
`cl`.`full_name`,
COUNT(`co`.`car_id`) AS `count_of_cars`,
SUM(`co`.`bill`) AS `total_sum`
FROM `clients` AS `cl`
JOIN `courses` AS `co`
ON `co`.`client_id` = `cl`.`id`
WHERE `cl`.`full_name` LIKE '_a%'
GROUP BY `cl`.`full_name`
HAVING `count_of_cars` > 1
ORDER BY `cl`.`full_name`;

#EX9
SELECT
`a`.`name`,
(
	CASE
		WHEN HOUR(`co`.`start`) BETWEEN 0 AND 5 THEN 'Night'
		WHEN HOUR(`co`.`start`) BETWEEN 6 AND 20 THEN 'Day'
		WHEN HOUR(`co`.`start`) BETWEEN 21 AND 24 THEN 'Night'
	END
) AS `day_time`,
`co`.`bill`,
`cl`.`full_name`,
`c`.`make`,
`c`.`model`,
`ca`.`name` AS `category_name`
FROM `courses` AS `co`
JOIN `addresses` AS `a`
ON `co`.`from_address_id` = `a`.`id`
JOIN `clients` AS `cl`
ON `co`.`client_id` = `cl`.`id`
JOIN `cars` AS `c`
ON `co`.`car_id` = `c`.`id`
JOIN `categories` AS `ca`
ON `c`.`category_id` = `ca`.`id`
GROUP BY `co`.`id`
ORDER BY `co`.`id`;

#EX10
DELIMITER $$
CREATE FUNCTION `udf_courses_by_client` (`phone_num` VARCHAR(20))
RETURNS INTEGER
DETERMINISTIC
BEGIN

	DECLARE `result` INT;
    SET `result` := (
		SELECT
		COUNT(`co`.`id`)
		FROM `courses` AS `co`
		JOIN `clients` AS `cl`
		ON `co`.`client_id` = `cl`.`id`
        WHERE `cl`.`phone_number` = `phone_num`
    );

RETURN `result`;
END$$
DELIMITER ;
SELECT udf_courses_by_client ('(803) 6386812') as `count`; 
SELECT udf_courses_by_client ('(704) 2502909') as `count`;

#EX11
DELIMITER $$
CREATE PROCEDURE `udp_courses_by_address` (`address_name` VARCHAR(100))
BEGIN

		SELECT 
		`a`.`name`,
        `cl`.`full_name`,
		(
			CASE
				WHEN `co`.`bill` BETWEEN 0 AND 20 THEN 'Low'
				WHEN `co`.`bill` BETWEEN 21 AND 30 THEN 'Medium'
                WHEN `co`.`bill` > 30 THEN 'High'
			END
		) AS `level_of_bill`,
		`c`.`make`,
		`c`.`condition`,
		`ca`.`name` AS `cat_name`
		FROM `courses` AS `co`
		JOIN `addresses` AS `a`
		ON `co`.`from_address_id` = `a`.`id`
		JOIN `clients` AS `cl`
		ON `co`.`client_id` = `cl`.`id`
		JOIN `cars` AS `c`
		ON `co`.`car_id` = `c`.`id`
		JOIN `categories` AS `ca`
		ON `c`.`category_id` = `ca`.`id`
        WHERE `a`.`name` = `address_name`
        ORDER BY `c`.`make`, `cl`.`full_name`;

END$$
DELIMITER ;
CALL udp_courses_by_address('700 Monterey Avenue');


