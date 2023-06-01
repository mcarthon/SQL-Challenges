/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
	id,
    SUM(price) AS total_spent
FROM (
	SELECT 
      sales.customer_id AS id,
  	  sales.order_date AS date,
      menu.price AS price
	FROM
      dannys_diner.sales AS sales
      INNER JOIN
      dannys_diner.menu AS menu
      ON
      sales.product_id = menu.product_id
    GROUP BY
        id,
        date,
        price
        -- date,
        -- price
    ORDER BY 
        id,
        date,
        price
) AS Sub_Table
GROUP BY
	id
ORDER BY
	id;

-- 2. How many days has each customer visited the restaurant?

SELECT 
	id,
    COUNT(day)
FROM (
	SELECT
      customer_id AS id,
      EXTRACT(YEAR FROM order_date) AS year,
      EXTRACT(MONTH FROM order_date) AS month,
      EXTRACT(DAY FROM order_date) AS day
	FROM
      dannys_diner.sales AS sales
  GROUP BY
      id,
      year,
      month,
      day
  ORDER BY
      id,
      year,
      month,
      day
) AS Sub_Table2
GROUP BY
	Sub_Table2.id;

-- 3. What was the first item from the menu purchased by each customer?

WITH first_item AS (
  SELECT 
      sales.customer_id AS id,
      ROW_NUMBER() OVER (PARTITION BY
          sales.customer_id
          ORDER BY
              sales.order_date
      ) AS id_rank,
      menu.product_name AS name
  FROM
      dannys_diner.sales AS sales
          INNER JOIN	
      dannys_diner.menu AS menu
          ON
      sales.product_id = menu.product_id
)
SELECT 
	id, 
    name, 
    id_rank
FROM
	first_item
WHERE
	id_rank = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
WITH name_rank AS (
  SELECT
      sales.customer_id AS id,
      menu.product_name AS name,
      COUNT(menu.product_name) AS times_eaten,
      RANK() OVER(PARTITION BY
            sales.customer_id
            ORDER BY
            COUNT(menu.product_name) DESC
      ) AS rank
  FROM
      dannys_diner.sales AS sales
      INNER JOIN
      dannys_diner.menu AS menu
      ON
      sales.product_id = menu.product_id
  GROUP BY
      id,
      name
  ORDER BY
      id,
      times_eaten DESC,
      name
)

SELECT 
	*
FROM
	name_rank
WHERE
	rank = 1;

-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Example Query:
-- SELECT
--     product_id,
--     product_name,
--     price
-- FROM dannys_diner.menu
-- ORDER BY price DESC
-- LIMIT 5;

