#EX1
SELECT * FROM `departments`
ORDER BY `department_id`;

#EX2
SELECT `name` FROM `departments`
ORDER BY `department_id`;

#EX3
SELECT `first_name`, `last_name`, `salary` FROM `employees`
ORDER BY `employee_id`;

#EX4
SELECT `first_name`, `middle_name`, `last_name` FROM `employees`
ORDER BY `employee_id`;

#EX5
SELECT CONCAT(`first_name`, '.', `last_name`, '@softuni.bg')
AS `full_ email_address`
FROM `employees`;

#EX6
SELECT DISTINCT `salary` FROM `employees`
ORDER BY `employee_id`;

#EX7
SELECT * FROM `employees`
WHERE `job_title` = 'Sales Representative'
ORDER BY `employee_id`;

#EX8
SELECT `first_name`, `last_name`, `job_title` FROM `employees`
WHERE `salary` BETWEEN 20000 AND 30000
ORDER BY `employee_id`;

#EX9
SELECT CONCAT_WS(' ', `first_name`, `middle_name`, `last_name`)
AS 'Full Name'
FROM `employees`
WHERE `salary` IN(25000, 14000, 12500, 23600);

#EX10
SELECT `first_name`, `last_name`
FROM `employees`
WHERE `manager_id` IS NULL;

#EX11
SELECT `first_name`, `last_name`, `salary` FROM `employees`
WHERE `salary` > 50000
ORDER BY `salary` DESC;

#EX12
SELECT `first_name`, `last_name` FROM `employees`
ORDER BY `salary` DESC LIMIT 5;

#EX13
SELECT `first_name`, `last_name` FROM `employees`
WHERE `department_id` != 4;

#EX14
SELECT * FROM `employees`
ORDER BY `salary` DESC, `first_name` ASC, `last_name` DESC, `middle_name` ASC, `emplOyee_id`; 

#EX15
CREATE VIEW `v_employees_salaries`
AS
SELECT `first_name`, `last_name`, `salary` FROM `employees`;

SELECT * FROM `v_employees_salaries`;

#EX16
CREATE VIEW `v_employees_job_titles`
AS
	SELECT CONCAT_WS(' ', `first_name`, `middle_name`, `last_name`), `job_title` FROM `employees`;

SELECT * FROM `v_employees_job_titles`;
    
#EX17
SELECT DISTINCT `job_title` FROM `employees`
ORDER BY `job_title` ASC;

#EX18
SELECT * FROM `projects`
ORDER BY `start_date`, `name`, `project_id` 
LIMIT 10;

#EX19
SELECT `first_name`, `last_name`, `hire_date` FROM `employees`
ORDER BY `hire_date` DESC
LIMIT 7;

#EX20
SELECT * FROM `departments`;

UPDATE  `employees`
SET `salary` = `salary` * 1.12
WHERE `department_id` IN(1, 2, 4, 11);

SELECT `salary` FROM `employees`;

#EX21
SELECT `peak_name` FROM `peaks`
ORDER BY `peak_name`;

#EX22
SELECT * FROM `continents`;

SELECT `country_name`, `population` FROM `countries`
WHERE `continent_code` = 'EU'
ORDER BY `population` DESC, `country_name`
LIMIT 30;

#EX23
SELECT `country_name`, `country_code`, 
IF(`currency_code` = 'EUR', 'Euro', 'Not Euro') AS `currency`
FROM `countries`
ORDER BY `country_name`;

#EX24
SELECT `name` FROM `characters`
ORDER BY `name`;