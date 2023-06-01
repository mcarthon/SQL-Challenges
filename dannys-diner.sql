CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

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
