#EX1
SELECT `title` FROM `books`
WHERE SUBSTRING(`title`, 1, 3) = 'The'
ORDER BY `id`;

#EX2
SELECT REPLACE(`title`, 'The', '***') 
AS `title`
FROM `books`
WHERE SUBSTR(title, 1, 3) = 'The'
ORDER BY `id`;

#EX3
SELECT ROUND(sum(`cost`), 2)
AS `sum`
FROM `books`;

#EX4
SELECT CONCAT_WS(' ', `first_name`, `last_name`)
AS `Full Name`,
TIMESTAMPDIFF(DAY, `born`, `died`)
AS `Days Lived`
FROM `authors`;

#EX5
SELECT `title` FROM `books`
WHERE `title` LIKE 'Harry Potter%';