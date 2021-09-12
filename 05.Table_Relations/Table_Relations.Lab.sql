#EX1
CREATE DATABASE `geo`;
USE `geo`;

CREATE TABLE `mountains`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE `peaks`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    `mountain_id` INT NOT NULL,
    CONSTRAINT fk_peaks_mountains
    FOREIGN KEY (`mountain_id`) 
    REFERENCES `mountains`(`id`)
 );
 
 #EX2
 SELECT `driver_id`, `vehicle_type`,
 CONCAT_WS(' ', `first_name`, `last_name`) AS `driver_name`
FROM `vehicles` AS `v`
JOIN `campers` AS `c`
ON `v`.`driver_id` = `c`.`id`;

#EX3
SELECT 
`starting_point` AS `route_starting_point`,
`end_point` AS `route_ending_point`,
`leader_id`,
CONCAT_WS(' ', `first_name`, `last_name`) AS `leader_name`
FROM `routes` AS `r`
JOIN `campers` AS `c`
ON `r`.`leader_id` = `c`.`id`;

#EX4
USE `geo`;
DROP TABLE `mountains`;
DROP TABLE `peaks`;

CREATE TABLE `mountains`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE `peaks`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    `mountain_id` INT NOT NULL,
    CONSTRAINT fk_peaks_mountains
    FOREIGN KEY (`mountain_id`) 
    REFERENCES `mountains`(`id`)
    ON DELETE CASCADE
 );