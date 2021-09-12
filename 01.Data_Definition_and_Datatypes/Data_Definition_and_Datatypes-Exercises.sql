CREATE DATABASE `minions`;
USE `minions`;

#EX1
CREATE TABLE `minions` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)	NOT NULL,
    `age` INT
);

CREATE TABLE `towns`(
	`town_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

#EX2
ALTER TABLE `towns`
CHANGE COLUMN `town_id` `id` INT NOT NULL AUTO_INCREMENT;

ALTER TABLE `minions`
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns`(`id`);

#EX3
INSERT INTO `towns`
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO `minions`
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

#EX4
TRUNCATE TABLE `minions`;

#EX5
DROP TABLES `minions`, `towns`;

#EX6
CREATE TABLE `people`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `picture` BLOB,
    `height` FLOAT(5, 2),
    `weight` FLOAT(5, 2),
    `gender` CHAR(1) NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` TEXT
);

INSERT INTO `people`
VALUES
(1, 'Sasho', null, 175.24, 81.4, 'm', '1995-04-06', null),
(2, 'Sashka', null, 180.04, 51.4, 'f', '1996-06-04', null),
(3, 'Nasko', null, 195.40, 100.40, 'm', '1997-09-22', null),
(4, 'Spaska', null, 159.24, 41.43, 'f', '1996-01-19', null),
(5, 'Spas', null, 182.24, 91.46, 'm', '1995-12-05', null);

#EX7
CREATE TABLE `users`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30),
    `password` VARCHAR(26),
    `profile_picture` BLOB,
    `last_login_time` DATE,
    `is_deleted` BOOLEAN
);

INSERT INTO `users`
VALUES
(1, 'EDC', 'CDE', null, '2020-10-30 05:35:14', false),
(2, 'WSX', 'XSW', null, '2020-09-29 16:34:13', true),
(3, 'QZA', 'ZAQ', null, '2020-08-28 17:33:15', false),
(4, 'BGT', 'TGB', null, '2020-07-27 18:32:17', true),
(5, 'UJM', 'NHY', null, '2020-06-26 19:31:19', false);

#EX8
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (`id`, `username`);

#EX9
ALTER TABLE `users`
CHANGE COLUMN `last_login_time` `last_login_time` DATETIME DEFAULT CURRENT_TIMESTAMP;

#EX10
ALTER TABLE `users`
DROP PRIMARY KEY,
CHANGE COLUMN `id` `id` INT PRIMARY KEY AUTO_INCREMENT,
CHANGE COLUMN `username` `username` VARCHAR(30) UNIQUE;

#EX11
CREATE DATABASE `Movies`;
USE `Movies`;

CREATE TABLE `directors`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `director_name` VARCHAR(30) NOT NULL,
    `notes` TEXT
);

CREATE TABLE `genres`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `genre_name` VARCHAR(30) NOT NULL,
    `notes` TEXT
);

CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `category_name` VARCHAR(30) NOT NULL,
    `notes` TEXT
);

CREATE TABLE `movies`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(30) NOT NULL,
    `director_id` INT,
    `copyright_year` DATE,
    `length` TIME,
    `genre_id` INT,
    `category_id` INT,
    `rating` INT,
    `notes` TEXT
);

INSERT INTO `directors`
VALUES
(1, 'John', null),
(2, 'Bob', null),
(3, 'Tom', null),
(4, 'Ronny', null),
(5, 'Tim', null);

INSERT INTO `genres`
VALUES
(1, 'Action', null),
(2, 'Fantasy', null),
(3, 'Drama', null),
(4, 'Comedy', null),
(5, 'Horror', null);

INSERT INTO `categories`
VALUES
(1, 'Animated', null),
(2, 'Documentary', null),
(3, 'Old', null),
(4, 'New', null),
(5, 'Feature', null);

INSERT INTO `movies`
VALUES
(1, 'Bad boys', 5, '1997-06-04', '02:33:10', 1, 5, 9, null),
(2, 'Avatar', 4, '2009-07-14', '03:43:10', 2, 1, 10, null),
(3, 'Alien', 3, '1984-10-02', '01:45:10', 5, 3, 9, null),
(4, 'TAXI', 2, '2005-06-04', '01:22:10', 4, 4, 8, null),
(5, 'War', 1, '1999-12-24', '02:15:10', 3, 2, 7, null);

#EX12
CREATE DATABASE `car_rental`;
USE `car_rental`;

CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `category` VARCHAR(30) NOT NULL,
    `daily_rate` FLOAT(10, 2),
    `weekly_rate` FLOAT(10, 2),
    `monthly_rate` FLOAT(10, 2),
    `weekend_rate` FLOAT(10, 2)
);

CREATE TABLE `cars`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `plate_number` VARCHAR(10) NOT NULL,
    `make` VARCHAR(20) NOT NULL,
    `model` VARCHAR(30) NOT NULL,
    `car_year` DATE NOT NULL,
    `category_id` INT NOT NULL,
    `doors` INT NOT NULL,
    `picture` BLOB,
    `car_condition` VARCHAR(25),
    `available` BOOLEAN
);

CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(25) NOT NULL,
    `last_name` VARCHAR(25) NOT NULL,
    `title` VARCHAR(25) NOT NULL,
    `notes` TEXT
);

CREATE TABLE `customers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `driver_licence_number` VARCHAR(25) NOT NULL,
    `full_name` VARCHAR(100) NOT NULL,
    `address` VARCHAR(50) NOT NULL,
    `city` VARCHAR(50) NOT NULL,
    `zip_code` INT NOT NULL,
    `notes` TEXT
);

CREATE TABLE `rental_orders`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id` INT NOT NULL,
    `customer_id` INT NOT NULL,
    `car_id` INT NOT NULL,
    `car_condition` VARCHAR(25),
    `tank_level` INT,
    `kilometrage_start` INT,
    `kilometrage_end` INT,
    `total_kilometrage` INT,
    `start_date` DATE,
    `end_date` DATE,
    `total_days` INT,
    `rate_applied` FLOAT(4, 2),
    `tax_rate` FLOAT(4, 2),
    `order_status` VARCHAR(20),
    `notes` TEXT
);

INSERT INTO `categories`
VALUES
(1, 'sedan', 75.00, 300.00, 1000.00, 150.00),
(2, 'coupe', 85.00, 350.00, 1200.00, 180.00),
(3, 'comby', 65.00, 250.00, 800.00, 130.00);

INSERT INTO `cars`
VALUES
(1, 'C3782AX', 'AUDI', 'A8', '2008-06-30', 1, 4, null, 'excellent', true),
(2, 'C3783AX', 'AUDI', 'A5', '2012-03-23', 2, 4, null, 'excellent', false),
(3, 'C3784AX', 'AUDI', 'A4', '2008-11-11', 3, 4, null, 'excellent', true);

INSERT INTO `employees`
VALUES
(1, 'Boyko', 'Borisov', 'seller', null),
(2, 'Korneliq', 'Ninova', 'seller', null),
(3, 'Krasimir', 'Karakachanov', 'seller', null);

INSERT INTO `customers`
VALUES
(1, '123456789', 'Desislava', 'Timok', 'Sofia', 1000, null), 
(2, '123456785', 'Gloria', 'Temenuga', 'Sofia', 1000, null), 
(3, '123456784', 'Ivana', 'Lom', 'Sofia', 1000, null); 

INSERT INTO `rental_orders`
VALUES
(1, 1, 3, 3, 'excellent', 50, 250649, 250849, 200, '2020-05-06', '2020-05-13', 7, null, null, null, null),
(2, 2, 2, 2, 'excellent', 60, 270649, 270849, 200, '2020-06-06', '2020-06-13', 7, null, null, null, null),
(3, 3, 1, 1, 'excellent', 40, 290649, 290849, 200, '2020-09-06', '2020-09-13', 7, null, null, null, null);

#EX13
CREATE DATABASE `soft_uni`;
USE `soft_uni`;

CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `addresses`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address_text` VARCHAR(100) NOT NULL,
    `town_id` INT NOT NULL,
    CONSTRAINT fk_addresses_towns
    FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`)
);

CREATE TABLE `departments`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `middle_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `job_title` VARCHAR(50),
    `department_id` INT,
    CONSTRAINT fk_employees_departments
    FOREIGN KEY (`department_id`) REFERENCES `departments`(`id`),
    `hire_date` DATE,
    `salary` DECIMAL(10, 2),
    `address_id` INT,
    CONSTRAINT fk_employees_addresses
    FOREIGN KEY (`address_id`) REFERENCES `addresses`(`id`)
);

INSERT INTO `towns`
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna'),
(4, 'Burgas');

INSERT INTO `departments`
VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Software Development'),
(5, 'Quality Assurance');

INSERT INTO `employees`
VALUES
(1, 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00, null),
(2, 'Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00, null),
(3, 'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25, null),
(4, 'Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00, null),
(5, 'Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88, null);

#EX14
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

#EX15
SELECT * FROM `towns`
ORDER BY `name`;

SELECT * FROM `departments`
ORDER BY `name`;

SELECT * FROM `employees`
ORDER BY `salary` DESC;

#EX16
SELECT `name` FROM `towns`
ORDER BY `name`;

SELECT `name` FROM `departments`
ORDER BY `name`;

SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;

#EX17
UPDATE `employees`
SET `salary` = `salary` * 1.1;

SELECT `salary` FROM `employees`;

#EX18
TRUNCATE TABLE `occupancies`;