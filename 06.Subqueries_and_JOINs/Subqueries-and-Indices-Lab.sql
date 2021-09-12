#EX1
SELECT 
`e`.`employee_id`,
CONCAT_WS(' ', `first_name`, `last_name`) AS `full_name`,
`d`.`department_id`,
`d`.`name` AS `department_name`
 FROM `employees` AS `e`
 RIGHT JOIN `departments` AS `d`
 ON `e`.`employee_id` = `d`.`manager_id`
 ORDER BY `e`.`employee_id` ASC
 LIMIT 5;

#EX2
SELECT
`t`.`town_id`,
`t`.`name`,
`a`.`address_text`
FROM `towns` AS `t`
JOIN `addresses` AS `a`
ON `t`.`town_id` = `a`.`town_id`
WHERE `name` IN('San Francisco', 'Sofia', 'Carnation')
ORDER BY `t`.`town_id`, `a`.`address_id`;

#EX3
SELECT
`employee_id`,
`first_name`,
`last_name`,
`department_id`,
`salary`
FROM `employees`
WHERE `manager_id` IS NULL;

#EX4
SELECT
COUNT(`employee_id`) AS `count`
FROM `employees`
WHERE `salary` > (
	SELECT AVG(`salary`)
    FROM `employees`
);