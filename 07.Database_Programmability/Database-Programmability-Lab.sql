#EX1
DELIMITER $$
CREATE FUNCTION `ufn_count_employees_by_town` (`town_name` VARCHAR(30))
RETURNS INTEGER
DETERMINISTIC
BEGIN

	DECLARE `e_count` INT;
    SET `e_count` := (
		SELECT 
		COUNT(*) AS `count`
		FROM `employees` AS `e`
		JOIN `addresses` AS `s`
		USING(`address_id`)
		JOIN `towns` AS `t`
		USING(`town_id`)
		WHERE `t`.`name` = `town_name`
    );

RETURN `e_count`;
END$$


#EX2
DELIMITER $$
CREATE PROCEDURE `usp_raise_salaries` (`department_name` VARCHAR(50))
BEGIN

		UPDATE `employees` AS `e`
		JOIN `departments` AS `d`
		USING(`department_id`)
        SET `salary` = (`salary` * 1.05)
		WHERE `d`.`name` = `department_name`;

END$$

#EX3
DELIMITER $$
CREATE PROCEDURE `usp_raise_salary_by_id` (`id` INT)
BEGIN
	START TRANSACTION;
    IF((
			SELECT
            COUNT(`employee_id`)
            FROM `employees`
            WHERE `employee_id` LIKE `id`
		) <> 1
    ) THEN
    ROLLBACK;
    ELSE 
		UPDATE `employees` AS `e`
        SET `salary` = (`salary` * 1.05)
        WHERE `e`.`employee_id` = `id`;
	END IF;
END$$

#EX4
DELIMITER ;
CREATE TABLE `deleted_employees`(
	`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(50),
	`last_name` VARCHAR(50),
    `middle_name` VARCHAR(50),
	`job_title` VARCHAR(50),
	`department_id`INT,
    `salary` DECIMAL(19, 4)
);
DELIMITER $$
CREATE TRIGGER `tr_deleted_employees`
AFTER DELETE
ON `employees`
FOR EACH ROW
BEGIN
	INSERT INTO `deleted_employees`(`employee_id`,
    `first_name`, `last_name`, `middle_name`,
    `job_title`, `department_id`, `salary`)
    VALUES
    (OLD.`first_name`, OLD.`last_name`, OLD.`middle_name`,
    OLD.`job_title`, OLD.`department_id`, OLD.`salary`);
END;
DELIMITER ;

DELETE FROM `employees`
WHERE `employee_id` IN(1);
        