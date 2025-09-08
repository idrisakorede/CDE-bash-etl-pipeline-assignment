--- /* Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table. */ ---
SELECT id                                       --- Select the required column (id)
FROM orders                                     --- From the table (order)
WHERE gloss_qty > 4000 or poster_qty > 4000;     --- Filtering with WHERE and OR to get the desired result of id's with gloss_qty over 4000 OR poster_qty over 4000



--- /* Write a query that returns a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000. */ ---
SELECT *                                                                --- Selecting all the columns from the table orders using the * wildcard
FROM orders
WHERE (standard_qty = 0) AND (gloss_qty > 1000 OR poster_qty > 1000);    --- Filtering with WHERE, OR, AND; returns list of orders where standard_qty = 0 AND gloss_qty OR poster_qty > 1000



--- /* Find all the company names that start with a 'C' or 'W', and where the primary contact contains 'ana' or 'Ana', but does not contain 'eana'. */ ---
SELECT a.names                                                          --- Select the required column (name) from the accounts table; used alias because name is a keyword in SQL
FROM accounts AS a
WHERE (a.name LIKE 'C%' OR a.name LIKE 'W%')                            --- The first filtering condition, finding companies whose name starts with C OR W
AND (primary_poc ILIKE '%ana%' AND primary_poc NOT LIKE '%eana%');      --- The second filtering condition, from contries whose name starts with C OR W, find primary contacts with 'ana' OR 'Ana' (ILIKE does the job of OR) but not 'aena'



--- /* Provide a table that shows the region for each sales rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) by account name. */ ---
SELECT r.name AS region_name, sr.name AS sales_rep_name, a.name AS account_name     --- Select the three columns the final table should include from the tables (region, sales_reps, and accounts) and assigns the required aliases region_name, sales_rep_name and account_name
FROM REGION as r
INNER JOIN sales_reps AS sr ON sr.region_id = r.id                                  --- Joining the sales_reps table to the region table based on the region_id and id foreign key relationship
INNER JOIN accounts AS a ON a.sales_rep_id = sr.id                                  --- Joining the accounts table to the region table based on the sales_rep_id and id foreign key relationship
ORDER BY a.name;                                                                    --- Ordering the result be account_name alphabetically, Ascending is not specified as it is the default