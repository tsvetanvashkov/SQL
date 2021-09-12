#EX1
SELECT `first_name`, `last_name` FROM `employees`
WHERE SUBSTRING(`first_name`, 1, 2) = 'Sa';

#EX2
SELECT `first_name`, `last_name` FROM `employees`
WHERE `last_name` LIKE '%ei%';

#EX3
SELECT `first_name` FROM `employees`
WHERE `department_id` IN(3, 10)
AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;

#EX4
SELECT `first_name`, `last_name` FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%';

#EX5
SELECT `name` FROM `towns`
WHERE CHAR_LENGTH(`name`) IN(5, 6)
ORDER BY `name` ASC;

#EX6
SELECT `town_id`, `name` FROM `towns`
WHERE LEFT(`name`, 1) IN ('M', 'K', 'B', 'E')
ORDER BY `name` ASC;

#EX7
SELECT `town_id`, `name` FROM `towns`
WHERE NOT LEFT(`name`, 1) = 'R' 
AND NOT LEFT(`name`, 1) =  'D'
AND NOT LEFT(`name`, 1) =  'B'
ORDER BY `name` ASC;

#EX8
CREATE VIEW `v_employees_hired_after_2000`
AS
	SELECT `first_name`, `last_name` FROM `employees`
    WHERE YEAR(`hire_date`) > 2000;

SELECT * FROM `v_employees_hired_after_2000`;

#EX9
SELECT `first_name`, `last_name` FROM `employees`
WHERE CHAR_LENGTH(`last_name`) = 5;

#EX10
SELECT `country_name`, `iso_code` FROM `countries`
WHERE `country_name` LIKE '%A%A%A%'
ORDER BY `iso_code`;

#EX11
SELECT `peak_name`, `river_name`,
LOWER(concat(`peak_name`, SUBSTRING(`river_name`, 2)))
AS `mix`
FROM `peaks`, `rivers`
WHERE RIGHT(LOWER(`peak_name`), 1) = LEFT(LOWER(`river_name`), 1)
ORDER BY `mix` ASC;

#EX12
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS `start`
FROM `games`
WHERE YEAR(`start`) IN(2011, 2012)
ORDER BY `start` ASC LIMIT 50;

#EX13
SELECT `user_name`, 
SUBSTRING(`email`, LOCATE('@', `email`) + 1) AS `email provider`
FROM `users`
ORDER BY `email provider` ASC, `user_name`;
 
 #EX14
SELECT `user_name`, `ip_address`
FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name` ASC;

#EX15
SELECT `name` AS `game`,
(
	CASE
		WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN HOUR(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END
) AS `part of the day`,
(
	CASE
		WHEN `duration` BETWEEN 0 AND 3 THEN 'Extra Short'
		WHEN `duration` BETWEEN 4 AND 6 THEN 'Short'
		WHEN `duration` BETWEEN 7 AND 10 THEN 'Long'
        ELSE 'Extra Long'
	END
) AS `duration`
FROM `games`;

#EX16
SELECT `product_name`, `order_date`,
DATE_ADD(`order_date`, INTERVAL 3 DAY) AS `pay_due`,
DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS `deliver_due`
FROM `orders`;

