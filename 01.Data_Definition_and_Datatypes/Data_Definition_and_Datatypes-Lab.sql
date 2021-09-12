CREATE DATABASE `gamebar`;
USE `gamebar`;

CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL
);

CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE `products`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    `category_id` INT NOT NULL
);

INSERT INTO `employees`
VALUES
(1, 'Pesho', 'Peshov'),
(2, 'Gosho', 'Goshev'),
(3, 'Ivan', 'Ivanov');

SELECT * FROM `employees`;

ALTER TABLE `employees`
ADD COLUMN `middle_name` VARCHAR(30) NOT NULL;

ALTER TABLE `products`
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories`(`id`);

ALTER TABLE `employees`
MODIFY COLUMN `middle_name` VARCHAR(100) NOT NULL;


