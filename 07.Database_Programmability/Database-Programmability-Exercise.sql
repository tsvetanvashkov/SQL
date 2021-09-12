#EX1
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above_35000` ()
BEGIN

		SELECT 
		`first_name`,
		`last_name`
		FROM `employees`
		WHERE `salary` > 35000
		ORDER BY `first_name` ASC, `last_name` ASC, `employee_id` ASC;

END$$
DELIMITER ;
CALL`usp_get_employees_salary_above_35000`;

#EX2
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above` (`number` DECIMAL (19, 4))
BEGIN

		SELECT 
		`first_name`,
		`last_name`
		FROM `employees`
		WHERE `salary` >= `number`
		ORDER BY `first_name` ASC, `last_name` ASC, `employee_id` ASC;

END$$
DELIMITER ;
CALL `usp_get_employees_salary_above`(45000);

#EX3
DELIMITER $$
CREATE PROCEDURE `usp_get_towns_starting_with` (`string` VARCHAR(50))
BEGIN

		SELECT
		`name` AS `town_name`
		FROM `towns`
		WHERE LEFT(`name`, LENGTH(`string`)) = `string`
        ORDER BY `town_name` ASC;

END$$
DELIMITER ;
CALL `usp_get_towns_starting_with`('b');

#EX4
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_from_town` (`town_name` VARCHAR(50))
BEGIN

		SELECT 
		`e`.`first_name`,
		`e`.`last_name`
		FROM `employees` AS `e`
		JOIN `addresses`
        USING(`address_id`)
        JOIN `towns` AS `t`
        USING(`town_id`)
        WHERE `t`.`name` = `town_name`
		ORDER BY `e`.`first_name` ASC, `e`.`last_name` ASC, `e`.`employee_id` ASC;

END$$
DELIMITER ;
CALL `usp_get_employees_from_town`('Sofia');

#EX5
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level` (`salary` DECIMAL(19, 4))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN

	DECLARE `salary_level` VARCHAR(20);
    SET `salary_level` := (
		CASE
			WHEN `salary` < 30000 THEN 'Low'
            WHEN `salary` BETWEEN 30000 AND 50000 THEN 'Average'
            ELSE 'High'
		END
    );

RETURN `salary_level`;
END$$
DELIMITER ;

SELECT
`salary`,
`ufn_get_salary_level`(`salary`) AS `salary_Level`
FROM `employees`
ORDER BY `salary`;

#EX6
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_by_salary_level` (`salary_level` VARCHAR(20))
BEGIN

		SELECT 
		`first_name`,
		`last_name`
		FROM `employees`
        WHERE `salary_level` = (
			CASE
				WHEN `salary` < 30000 THEN 'Low'
				WHEN `salary` BETWEEN 30000 AND 50000 THEN 'Average'
				ELSE 'High'
			END
		)
		ORDER BY `first_name` DESC, `last_name` DESC;

END$$
DELIMITER ;
CALL `usp_get_employees_by_salary_level`('high');

#EX7
DELIMITER $$
CREATE FUNCTION `ufn_is_word_comprised` (`set_of_letters` VARCHAR(50), `word` VARCHAR(50))
RETURNS INTEGER
DETERMINISTIC
BEGIN

	DECLARE `result` INT;
    SET `result` := (
		SELECT
        `word` REGEXP(CONCAT('^[', `set_of_letters`, ']+$'))
    );

RETURN `result`;
END$$
DELIMITER ;

#EX8
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_full_name` ()
BEGIN

		SELECT 
		CONCAT_WS(' ', `first_name`, `last_name`) AS `full_name`
		FROM `account_holders`
        ORDER BY `full_name` ASC, `id` ASC;

END$$
DELIMITER ;
CALL `usp_get_holders_full_name`;

#EX9
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_with_balance_higher_than` (`number` INT)
BEGIN

		SELECT 
		`ah`.`first_name`,
        `ah`.`last_name`
		FROM `account_holders` AS `ah`
        JOIN `accounts` AS `a`
        ON `ah`.`id` = `a`.`account_holder_id`
        GROUP BY `a`.`account_holder_id`
        HAVING SUM(`balance`) > `number`
        ORDER BY `account_holder_id` ASC;

END$$
DELIMITER ;
CALL `usp_get_holders_with_balance_higher_than`(7000);

#EX10
DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value` (`sum` DECIMAL(19, 4), `yearly_interest_rate` DECIMAL(19, 4), `number_of_years` INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
BEGIN

	DECLARE `result` DECIMAL(19, 4);
    SET `result` := (
		SELECT
        (
        `sum` * POW((1 + `yearly_interest_rate`), `number_of_years`)
        )
    );

RETURN `result`;
END$$
DELIMITER ;
SELECT
`ufn_calculate_future_value`(1000, 0.5, 5);

#EX11
DELIMITER $$
CREATE PROCEDURE `usp_calculate_future_value_for_account` (`account_id` INT, `interest_rate` DECIMAL(19, 4))
BEGIN

		SELECT 
        `account_id`,
		`ah`.`first_name`,
        `ah`.`last_name`,
        ROUND(`a`.`balance`, 4) AS `current_balance`,
        `ufn_calculate_future_value`(`a`.`balance`, `interest_rate`, 5) AS `balance_in_5_years`
		FROM `account_holders` AS `ah`
        JOIN `accounts` AS `a`
        ON `ah`.`id` = `a`.`account_holder_id`
        WHERE `account_id` = `a`.`id`;

END$$
DELIMITER ;
CALL `usp_calculate_future_value_for_account`(1, 0.1);
DROP PROCEDURE `usp_calculate_future_value_for_account`;

#EX12
DELIMITER $$
CREATE PROCEDURE `usp_deposit_money` (`account_id` INT, `money_amount` DECIMAL(19, 4))
BEGIN

	START TRANSACTION;
    IF(`money_amount` <= 0
    ) THEN
    ROLLBACK;
    ELSE 
		UPDATE `accounts`
        SET `balance` = (`balance` + `money_amount`)
        WHERE `id` = `account_id`;
	END IF;

END$$
DELIMITER ;
CALL `usp_deposit_money`(1, 10);
SELECT
`id`,
`account_holder_id`,
`balance`
FROM `accounts`
where `id` = 1;

#EX13
DELIMITER $$
CREATE PROCEDURE `usp_withdraw_money` (`account_id` INT, `money_amount` DECIMAL(19, 4))
BEGIN

	START TRANSACTION;
    IF(`money_amount` <= 0
		OR `money_amount` > (
			SELECT
            `balance`
            FROM `accounts`
            WHERE `id` = `account_id`
        )
    ) THEN
    ROLLBACK;
    ELSE 
		UPDATE `accounts`
        SET `balance` = (`balance` - `money_amount`)
        WHERE `id` = `account_id`;
	END IF;

END$$
DELIMITER ;
CALL `usp_withdraw_money`(1, 10);
SELECT
`id`,
`account_holder_id`,
`balance`
FROM `accounts`
where `id` = 1;

#EX14
DELIMITER $$
CREATE PROCEDURE `usp_transfer_money` (`from_account_id` INT, `to_account_id` INT, `amount` DECIMAL(19, 4))
BEGIN

	START TRANSACTION;
    IF(
		(SELECT COUNT(`id`)
		FROM `accounts`
		WHERE `id` = `from_account_id` OR `id` = `to_account_id`
		) != 2
        OR `amount` < 0
        OR `from_account_id` = `to_account_id`
        OR `amount` > (
			SELECT
            `balance`
            FROM `accounts`
            WHERE `id` = `from_account_id`
        )
    ) THEN
    ROLLBACK;
    ELSE 
		UPDATE `accounts`
        SET `balance` = (`balance` - `amount`)
        WHERE `id` = `from_account_id`;
        UPDATE `accounts`
        SET `balance` = (`balance` + `amount`)
        WHERE `id` = `to_account_id`;
	END IF;

END$$
DELIMITER ;
CALL `usp_transfer_money`(1, 2, 10);
SELECT
`id`,
`account_holder_id`,
`balance`
FROM `accounts`
where `id` = 1 OR `id` = 2;
