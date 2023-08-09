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

Select * from sales;
Select * from menu;
Select * from members;

--1.What is the total amount each customer spent at the restaurant?

/*
Execution Steps:
1. Sales table contains information about customer orders. Menu table holds information on product and its prices
2. Doing inner join of these tables with product_id as the primary key is required to get the desired result.
3. Since each customer could have made multiple orders on multiple days, aggregating customers based on their unique id using 'group by' function.
4. Calculate the total purchase per customer using 'sum' aggregate function.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Joins (INNER JOIN | ON(condition))
3. GROUP BY
4. Agregation (SUM)
*/

Select s.customer_id,SUM(m.price) total_amount_spent 
from sales s 
inner join menu m 
on s.product_id=m.product_id 
group by s.customer_id

/*
Insights: (The given sample data is for a one month period)
In the first month of the restaurant, it has got 3 customers where C contributed only half of what A and B spent individually. 
C might not be more enthusiastic about this new launch as A and B.
This might have an impact in customer loyalty program(membership) of the restaurant.

*/

--2.How many days has each customer visited the restaurant?

/*
Execution Steps:
Each row in the sales table provides details about a specific product that the customer purchased in a every single order. 
In a single order, customer could have purchased multiple products and hence multiple rows for a single order/visit of the customer.
So to get the total customer visits, grouping the customers with their unique id and calculating the distinct count of order_date returns the desired result
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. GROUP BY
3. Agregation (COUNT)
4. DISTINCT
*/

Select  customer_id,count(distinct(order_date)) no_of_visits from sales group by customer_id;

/*
Insights:
The output with the number of visits of each customer correlates with the previous insight. 
C has less number of visits and hence less contribution to the restaurant revenue.

*/

--3.What was the first item from the menu purchased by each customer?

/*
Execution Steps:
In the initial stages of the restaurant three products where introduced for purchase.
Since sales table has information on customer order_dates and product_id, to get the product name from 'Menu', using inner join on the primary key(product_id) to combine both tables.
Now within each customer groups, ordering by 'order_date' in ascending order using ROW_NUMBER function and returning the top most row of each customer groups to get the desires result.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Joins (INNER JOIN | ON(condition))
3. WHERE
4. GROUP BY
5. Window function (RANK() OVER (PARTITION BY [OPTIONAL]....ORDER BY....)
6. Subquery
*/

Select customer_id,order_date,product_id, product_name,COUNT(1) as quantity from
(Select s.*,m.product_name,RANK() over(partition by customer_id order by order_date) rn 
from sales s inner join menu m on s.product_id=m.product_id)a where rn=1 group by customer_id,order_date,product_id,product_name;

/*
Insights: All three of them are customers from the day 1 of the restaurant */


--4.What is the most purchased item on the menu and how many times was it purchased by all customers?

/*
Execution Steps:
1. From the sales table, calculating the total number of purchases of each of the products. Using 'group by' clause and count function to get the count of each product. 
   Storing the result in a temporary table (cte).
2. To get the product name of the higly sold product, doing an inner join of sales and menu tables on primary key column 'product_id'.
   Using 'where' clause and subquery to retrieve the information of only high sales product from first cte created.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Joins (INNER JOIN | ON(condition))
3. WHERE
4. GROUP BY
5. Common Table Expression (CTE)
6. Subquery
*/
with cte as(
Select product_id,COUNT(product_id) ordered_count 
from sales 
group by product_id
)
Select cte.product_id,cte.ordered_count,m.product_name 
from cte 
inner join menu m 
on cte.product_id=m.product_id 
where ordered_count=(Select max(ordered_count) from cte);

/*Insight: Out of 3 newly launched items, ramen is the most popular among all existing customers. */

--5.Which item was the most popular for each customer?

/*
Execution steps:
1.Each record of sales table provides information on the product bought by a customer in every single order. Hence grouping customer id and product id to get the number of times 
a product bought by a customer. Storing the result in a temporary table.
2. Ranking of the purchase count of each product in descending order partitioned by customers.
3.Joining sales and menu table to get the product name and filtering in the top rank record of each customer. This provides the most popular product for each customer.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Joins (INNER JOIN | ON(condition))
3. WHERE
4. GROUP BY
5. Common Table Expression (CTE)
6. Window function (RANK() OVER (PARTITION BY [OPTIONAL]....ORDER BY....)
*/

With cte as
(Select customer_id,product_id,COUNT(product_id) number_of_times_purchased,RANK()over(partition by customer_id order by COUNT(product_id) desc) rank
from sales 
group by customer_id,product_id)

Select cte.customer_id,cte.product_id,m.product_name,cte.number_of_times_purchased 
from cte 
inner join menu m 
on m.product_id=cte.product_id 
where rank=1

/* Insight: Ramen is commonly popular among all 3 customers. Customer B eqaully likes all 3 products offered by the restaurant */

--6.Which item was purchased first by the customer after they became a member?

/*
Execution steps:
1. Combining all three tables using inner join based on the primary key and foriegn key of each tables.
2. Filtering the orders of sales table that happened after the customers joined the loyalty membership program.
3. Ranking the orders of each customer by order date in ascending order.
4. Filtering the top ranked record of each customer to get the first customer purchase details of each customer after their membership.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Multiple Inner Joins (INNER JOIN | ON(condition))
3. WHERE
4. Subquery
5. Window function (RANK() OVER (PARTITION BY [OPTIONAL]....ORDER BY....)
*/

Select customer_id,product_id,product_name,order_date,join_date from (
Select s.customer_id,s.product_id,m1.product_name,s.order_date,m.join_date,RANK() over (partition by s.customer_id order by s.order_date asc) as rn
from sales s 
inner join members m 
on s.customer_id=m.customer_id
inner join menu m1 
on s.product_id=m1.product_id
where s.order_date>=m.join_date) a where rn=1

/*Observation: Only Customers A and B became the members of the loyalty program. Post their membership customer A bought 'curry' on the day of membership.
Customer B bought 'sushi' 2 days after his/her membership. Even though ramen was popular it wasn't the first item bought by both the customers after their membership*/

--7.Which item was purchased just before the customer became a member?
/*
Execution steps:
1. Combining all three tables using inner join based on the primary key and foriegn key of each tables.
2. Filtering the orders of sales table that happened before the customers joined the loyalty membership program.
3. Ranking the orders of each customer by order date in descending order.
4. Filtering the top ranked record of each customer to get the first customer purchase details of each customer just before their membership.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Multiple Inner Joins (INNER JOIN | ON(condition))
3. WHERE
4. Subquery
5. Window function (RANK() OVER (PARTITION BY [OPTIONAL]....ORDER BY....)
*/

Select customer_id,product_id,product_name,order_date,join_date from(
Select s.customer_id,s.product_id,m1.product_name,s.order_date,m.join_date,RANK() over (partition by s.customer_id order by s.order_date desc) rn
from sales s 
inner join members m 
on s.customer_id=m.customer_id 
inner join menu m1 
on m1.product_id=s.product_id 
where s.order_date<m.join_date) a where rn=1

/*Insight: Customer A became a member after their first order itself, which was 6 days before the membership joining date.
Customer A and B bought commonly 'sushi' just before their membership. Despite the popularity of ramen, it wasn't bought by either customers, just before or after membership*/

--8.What is the total items and amount spent by each member before they became a member?
/*
Execution steps:
1. Combining all three tables using inner join based on the primary key and foriegn key of each tables.
2. Filtering the orders of sales table that happened before the customers joined the loyalty membership program.
3. For each customer, retrieve the total count and price of those products purchased.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Multiple Inner Joins (INNER JOIN | ON(condition))
3. WHERE
4. GROUP BY
5. Aggregate functions - SUM(), COUNT()
*/

Select s.customer_id,COUNT(s.product_id) total_items,SUM(price) total_amount_spent
from sales s 
inner join members m 
on m.customer_id=s.customer_id 
inner join menu m1 
on m1.product_id=s.product_id 
where m.join_date>s.order_date 
group by s.customer_id

/*Insight: Customer B ordered for 40$ which is 60% more than customer A before membership. This result is no way related to later membership of customer B than customer A.
In fact, customer B ordered more items than Customer A even before the membership date of customer A.*/

--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

/*
Execution steps:
1. To get he product price details of each customer order, combining sales and menu table using product id as primary key column.
2. Since the expectation is to retrieve points of each customer, utilizing 'group by' clause to segregate result for each cusotmer.
3. For 'Sushi' the point is 2x multiplier than points specified for other products(10 points for 1$) , i.e., 20 points for 1$. Hence multiplying thr price of each product 
   ordered by the customer with the points. 
4. Using case when statement within sum() function to return respective points for each product in the sales table and summing up to get the overall points of each customer.
*/


/*
Keywords/Functions used:
1. SELECT, FROM
2. Inner Joins (INNER JOIN | ON(condition))
3. CASE WHEN.. THEN.. ELSE.. END
4. GROUP BY
5. Aggregate functions - SUM()
*/

Select s.customer_id,sum(price*case when product_name='sushi' then 20 else 10 end) as total_points
from sales s 
inner join menu m 
on m.product_id=s.product_id 
group by s.customer_id;

/*
Insight: From the 1st query result, there was a minor difference between the order price of customer A and B. When multiplied with points, the difference was expected to be 
around 10 times of the price difference. But customer B points is 40 times more than customer A. 
From query result no.2, Customer B is the most visited customer. 
Hence highest points of customer B can be either due to purchased more sushi than other customers or visited restaurant for more orders than other customers or both.
Customer C purchase price was 36 and points is 360. Probably Customer C have not tried sushi at all.
*/

--10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
--how many points do customer A and B have at the end of January?

/*
Execution steps:
1. This question can be calculated in two parts. First part is to get the points of each product in the sales table, for orders happened on and within seven days of the customer's joining date.
2. Combining sales and menu table using inner join on product id to get the price information. 
3. Using 'where' filter and DATEADD function to retrieve information about orders that heppened only within day 7 from joining date of customer. 
   For this time period all products are given 20 points. Storing the results of first part in a temp table cte.
4. Second part is to retrieve sales information of each customer, for orders that happened before the joining date and after 7 days of joining date in the month of january.
5. During this period, sushi is assigned with 20 points while other products got 10 points. Hence using case when statement to assign points for rach record in the sale stable.
6. Storing the results of second part in a temp table cte1.
7. Now doing union of both tables (cte and cte1).
8. In the resulting table, grouping by customer id and retrieving the sum of all price*points to get the total points of each customer.
*/

/*
Keywords/Functions used:
1. SELECT, FROM, WHERE, AND
2. Multiple Inner Joins (INNER JOIN | ON(condition))
3. CASE WHEN.. THEN.. ELSE.. END
4. GROUP BY
5. Aggregate functions - SUM()
6. DATEADD(),DATEPART()
7. UNION
8. Subquery
9. CTE
*/
with cte as(
Select s.customer_id,s.order_date,m.join_date,s.product_id,m1.product_name,m1.price,20 as points_per_dollar
from sales s 
inner join members m 
on m.customer_id=s.customer_id 
inner join menu m1 on m1.product_id=s.product_id
where s.order_date<=DATEADD(day,6,m.join_date) and m.join_date<=s.order_date),

cte1 as(
Select s.customer_id,s.order_date,m.join_date,s.product_id,m1.product_name,m1.price,case when product_name='sushi' then 20 else 10 end as points_per_dollar
from sales s 
inner join members m 
on m.customer_id=s.customer_id 
inner join menu m1 on m1.product_id=s.product_id
where m.join_date>s.order_date or s.order_date>DATEADD(day,6,m.join_date) and DATEPART(month,order_date)=1)

Select customer_id ,SUM(price*points_per_dollar) as total_points from(
Select * from cte union all Select * from cte1) a group by customer_id;

/*Insight: Although customer B was leading with overall sales contribution, Customer A was the one who ordered more after the first week of joining the restaurant loyalty program. 
Hence Customer A scored more points than Customer B in this case*/ 

--Ranking based on Membership. Mention as null if not a member

/*
Execution Steps:
1. Creating a new variable to code as'N' or'Y' to check if the customer is a member or not on each order date
2. Joining sale and member tables using inner join on the 'product id' variable as primary key. This returns order details of only members of the restaurant.
3. Using case when statement to assign 'Y' if the customer is a member on the order date else 'N', based on the condition whether the order date is less than the join date or not.
4. The resulting table is stored in a cte. 
   Now, again creating a new variable using case when statement to rank the orders of each customer by order date, but only for orders that happened after their membership. 
   Rest should be null value.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Inner Join (INNER JOIN | ON(condition))
3. CASE WHEN.. THEN.. ELSE.. END
4. CTE
5.  Window function (RANK() OVER (PARTITION BY [OPTIONAL]....ORDER BY....)
*/

with cte as(
Select s.customer_id,s.order_date,
case when s.order_date>=m1.join_date then 'Y' else 'N' end as member
from sales s 
inner join members m1
on s.customer_id=m1.customer_id)

Select customer_id,order_date,member,case when member='Y' then RANK() over(partition by customer_id,member order by order_date) else null end ranking from cte

/*
Project Insights: 
From the day1 of restaurant opening, Danny has 3 customers (A,B,C). Customer A became the first member of the loyalty program in just 7 days of the launch of the program.
Customer B is the most visited customer among all customers and aloved all threeprocts equally.
Customer C is the lowest contributor of the restaurant sales. The only item bought by customer C is ramen and didnt order anything afer the 1st week of the restaurant.
Customer A's order of preference is ramen, curry and sushi.
Although customer B was leading with overall sales contribution, Customer A was the one who ordered more after the first week of joining the restaurant loyalty program.
Before membership, Customer B contributed for more sales then Customer A.
*/
