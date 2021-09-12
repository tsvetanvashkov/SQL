#EX1
SELECT
`e`.`employee_id`,
`e`.`job_title`,
`a`.`address_id`,
`a`.`address_text`
FROM `employees` AS `e`
JOIN `addresses` AS `a`
ON `e`.`address_id` = `a`.`address_id`
ORDER BY `address_id` ASC
LIMIT 5;

#EX2
SELECT
`e`.`first_name`,
`e`.`last_name`,
`t`.`name` AS `town`,
`a`.`address_text`
FROM `employees` AS `e`
JOIN `addresses` AS `a`
ON `e`.`address_id` = `a`.`address_id`
JOIN `towns` AS `t`
ON `a`.`town_id` = `t`.`town_id`
ORDER BY `e`.`first_name`ASC, `last_name`
LIMIT 5;

#EX3
SELECT
`e`.`employee_id`,
`e`.`first_name`,
`e`.`last_name`,
`d`.`name` AS `department_name`
FROM `employees` AS `e`
JOIN `departments` AS `d`
ON `e`.`department_id` = `d`.`department_id`
WHERE `d`.`name` = 'Sales'
ORDER BY `employee_id` DESC;

#EX4
SELECT
`e`.`employee_id`,
`e`.`first_name`,
`e`.`salary`,
`d`.`name` AS `department_name`
FROM `employees` AS `e`
JOIN `departments` AS `d`
ON `e`.`department_id` = `d`.`department_id`
WHERE `e`.`salary` > 15000
ORDER BY `e`.`department_id` DESC
LIMIT 5;

#EX5
SELECT
`e`.`employee_id`,
`e`.`first_name`
FROM `employees` AS `e`
LEFT JOIN `employees_projects` AS `ep`
ON `e`.`employee_id` = `ep`.`employee_id`
WHERE `ep`.`project_id` IS NULL
ORDER BY `employee_id` DESC
LIMIT 3;

#EX6
SELECT
`e`.`first_name`,
`e`.`last_name`,
`e`.`hire_date`,
`d`.`name` AS `dept_name`
FROM `employees` AS `e`
JOIN `departments` AS `d`
ON `e`.`department_id` = `d`.`department_id`
WHERE DATE(`e`.`hire_date`) > '1999-01-01' AND `d`.`name` IN('Sales', 'Finance')
ORDER BY `e`.`hire_date` ASC;

#EX7
SELECT
`e`.`employee_id`,
`e`.`first_name`,
`p`.`name` AS `project_name`
FROM `employees` AS `e`
JOIN `employees_projects` AS `ep`
ON `e`.`employee_id` = `ep`.`employee_id`
JOIN `projects` AS `p`
USING(`project_id`)
WHERE DATE(`p`.`start_date`) > '2002-08-13' 
AND DATE(`p`.`end_date`) IS NULL
ORDER BY `first_name` ASC, `p`.`name` ASC
LIMIT 5;

#EX8
SELECT
`e`.`employee_id`,
`e`.`first_name`,
IF(YEAR(`p`.`start_date`) < '2005',`p`.`name`, NULL) AS `project_name`
FROM `employees` AS `e`
LEFT JOIN `employees_projects` AS `ep`
ON `e`.`employee_id` = `ep`.`employee_id`
RIGHT JOIN `projects` AS `p`
USING(`project_id`)
WHERE `e`.`employee_id` = 24
ORDER BY `p`.`name` ASC;

#EX9
SELECT
`e`.`employee_id`,
`e`.`first_name`,
`e`.`manager_id`,
`m`.`first_name` AS `manager_name`
FROM `employees` AS `e`
JOIN `employees` AS `m`
ON `e`.`manager_id` = `m`.`employee_id`
WHERE `e`.`manager_id` IN(3, 7)
ORDER BY `e`.`first_name` ASC;

#EX10
SELECT
`e`.`employee_id`,
CONCAT_WS(' ', `e`.`first_name`, `e`.`last_name`) AS `employee_name`,
CONCAT_WS(' ', `m`.`first_name`, `m`.`last_name`) AS `manager_name`,
`d`.`name` AS `department_name`
FROM `employees` AS `e`
JOIN `employees` AS `m`
ON `e`.`manager_id` = `m`.`employee_id`
JOIN `departments` AS `d`
ON `e`.`department_id` = `d`.`department_id`
ORDER BY `e`.`employee_id` ASC
LIMIT 5;

#EX11
SELECT
AVG(`salary`) AS `min_average_salary`
FROM `employees`
GROUP BY `department_id`
ORDER BY `min_average_salary` ASC
LIMIT 1;

#EX12
SELECT
`c`.`country_code`,
`m`.`mountain_range`,
`p`.`peak_name`,
`p`.`elevation`
FROM `countries` AS `c`
JOIN `mountains_countries` AS `mc`
USING(`country_code`)
JOIN `mountains` AS `m`
ON `mc`.`mountain_id` = `m`.`id`
JOIN `peaks` AS `p`
ON `m`.`id` = `p`.`mountain_id`
WHERE `p`.`elevation` > 2835 AND `c`.`country_code` = 'BG'
ORDER BY `p`.`elevation` DESC;

#EX13
SELECT
`mc`.`country_code`,
COUNT(`m`.`id`) AS `mountain_range`
FROM `mountains_countries` AS `mc`
JOIN `mountains` AS `m`
ON `mc`.`mountain_id` = `m`.`id`
GROUP BY `mc`.`country_code`
HAVING `mc`.`country_code` IN('BG', 'RU', 'US')
ORDER BY `mountain_range` DESC;

#EX14
SELECT
`c`.`country_name`,
`r`.`river_name`
FROM `countries` AS `c`
LEFT JOIN `countries_rivers` AS `cr`
ON `c`.`country_code` = `cr`.`country_code`
LEFT JOIN `rivers` AS `r`
ON `cr`.`river_id` = `r`.`id`
JOIN `continents` AS `con`
USING (`continent_code`)
WHERE `con`.`continent_name` = 'Africa'
ORDER BY `country_name` ASC
LIMIT 5;

#EX15
SELECT
`continent_code`,
`currency_code`,
COUNT(`country_name`) AS `currency_usage`
FROM `countries` AS `c`
GROUP BY `continent_code`, `currency_code`
HAVING `currency_usage` = (
	SELECT
    COUNT(`country_code`) AS `count`
    FROM `countries` AS `c1`
    WHERE `c1`.`continent_code` = `c`.`continent_code`
    GROUP BY `currency_code`
	ORDER BY `count` DESC
    LIMIT 1
) AND `currency_usage` > 1
ORDER BY `continent_code`, `currency_code`;

#EX16
SELECT 
COUNT(*) AS `country_count`
FROM `countries`
WHERE `country_code` NOT IN(
SELECT `country_code`
FROM `mountains_countries`
);

#EX17
SELECT
`country_name`,
max(`p`.`elevation`) AS `highest_peak_elevation`,
MAX(`r`.`length`) AS `longest_river_length`
FROM `countries` AS `c`
LEFT JOIN `mountains_countries` AS `mc`
ON `c`.`country_code` = `mc`.`country_code`
JOIN `mountains` AS `m`
ON `mc`.`mountain_id` = `m`.`id`
JOIN `peaks` AS `p`
ON `m`.`id` = `p`.`mountain_id`
LEFT JOIN `countries_rivers` AS `cr`
ON `c`.`country_code` = `cr`.`country_code`
LEFT JOIN `rivers` AS `r`
ON `cr`.`river_id` = `r`.`id`
GROUP BY `country_name`
ORDER BY 
`highest_peak_elevation` DESC,
`longest_river_length` DESC,
`country_name`
LIMIT 5;
