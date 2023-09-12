
--CaseStudy 2

CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');



CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" datetime
);

INSERT INTO customer_orders

VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');



CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');



CREATE TABLE pizza_name (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');



CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

--Data Cleaning
/* 
1. Replacing all empty and 'null' string values in 'runner_orders' and 'customer_orders' tables to NULL
2. Trim the string unit values from distance and duration columns in 'runner_orders' table.
3. Coverting distance and duration columns in 'runner_orders' table into number format.
*/

update runner_orders set pickup_time=null where pickup_time='null'
Alter table runner_orders alter column pickup_time datetime;

update runner_orders set distance=trim('km' from distance)
update runner_orders set distance=null where distance ='null'
Alter table runner_orders alter column distance decimal(5,2);


update runner_orders set duration=TRIM('minutes' from duration)
update runner_orders set duration=null where duration='ll'
Alter table runner_orders alter column duration int;


update runner_orders set cancellation=null where cancellation='null' or cancellation=''

update customer_orders set exclusions=null where exclusions='' or exclusions='null'

update customer_orders set extras=null where extras='' or extras='null'

alter table pizza_recipes alter column toppings varchar(30)
alter table pizza_toppings alter column topping_name varchar(50)

--																			A. Pizza Metrics

  Select * from runners; -- Runnder details of the pizza take home restaurant (Runner id and their joined date)
  Select * from customer_orders; --Customer order information. Each record provides details of the pizza ordered by a customer in a specific order 
								 --(order id, pizza id, customer id, topping exclusion, topping addition, order_time)
  Select * from runner_orders; --Order delivery information. ORder id, Who delivered the order, time taken and distance to deliver, order cancellation status
  Select * from pizza_names; -- Available pizza varieties
  Select * from pizza_recipes; --Ingredients/toppings added in each pizza variety
  Select * from pizza_toppings; --What are the toppings added in pizza in general?
  
--1. How many pizzas were ordered?
/*
Execution steps:
In customer_orders table each record contains information on pizza type ordered in a specific order by a customer.
Hence, count of records in that table returns total number of pizzas ordered.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. COUNT()
*/

Select COUNT(1) as no_of_pizzas_ordered from customer_orders

/*Insight: In a period of 11 days, 5 customers made 10 orders. And the no of pizzas ordered in those 10 orders is 14.
It was a decent start for the unique positioning of the take home restaturant.
*/

--2. How many unique customer orders were made?
/*
Execution steps:
Calculating the unique orders placed by each customer. Grouping by customer id and returning the distinct count of order id.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. COUNT()
3. DISTINCT
*/

Select customer_id, count(distinct order_id) unique_customer_orders from customer_orders group by customer_id;

/*Insight: More orders were placed by customer 101 than others. Customers 102, 103, 104 placed equal no of orders. Customer 105 is the least with 1 order placed.
From the result it is clear that the early customers made more repeated orders than later ones. 
But still some of these orders may have been cancelled which could bring a change in the insight*/

--3. How many successful orders were delivered by each runner?

/*
Execution steps:
1. There are totally for runners registered as per runner table. But all runners may not yet started delivering orders. 
2. Hence doing a right join of 'runner_orders' and 'runner' table using runner_id(PK) and filtering out the cancelled orders
3. Now, grouping by runner_id of runners table and returning the count of runner_id in runner_orders table to get the number of orders placed by each runner.
   So that even if a runner has not delivered any orders yet, it will be shown in the output.
*/

/*
Keywords/Functions used:
1. SELECT, FROM, WHERE
2. RIGHT JOIN (RIGHT JOIN | ON(condition))
3. COUNT()
4. GROUP BY, ORDER BY
*/

Select r.runner_id,COUNT(ro.runner_id) as delivered_orders_count_by_runners
from runner_orders ro
right join runners r
on ro.runner_id=r.runner_id
where cancellation is null 
group by r.runner_id 
order by r.runner_id

/*Insight: No orders palced after runner id 4 joined the pizza restaurant. Hence his order delivery count is 0.
Runner id 1 is part of the restaurant since day 1 and hence he delivered more orders than others. Subsequent joiners delivered less orders than previous joiners*/

--4. How many of each type of pizza was delivered?
/*
Execution steps:
1. Finding the most popular pizza among the two varieties.  
2. Doing an inner join of customer_orders and runner_orders table using order_id as primary key to filter out the cancelled orders.
3. The resulting table is again joined with pizza_names table(right join) using pizza id as primary key, 
   to not to miss out any pizza types in the restaurant menu to take into account, for which no single order was placed.
4. Grouping by pizza id and pizza name of pizza_names table and returning the count of pizza_id in customer_orders table to get the total pizza orders placed in each type.
*/

/*
Keywords/Functions used:
1. SELECT, FROM, WHERE
2. Multiple Joins (INNER JOIN | ON(condition),RIGHT JOIN | ON(condition))
3. COUNT()
4. GROUP BY
*/
Select pn.pizza_id,pn.pizza_name,COUNT(co.pizza_id) as no_of_delivered_pizzas
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
right join pizza_names pn
on pn.pizza_id=co.pizza_id
where ro.cancellation is null
group by pn.pizza_id,pn.pizza_name

/* Insight: Meatlovers is the most famous pizza type among customers with 200% more orders than vegetarian. */

--5. How many Vegetarian and Meatlovers were ordered by each customer?
/*
Execution steps:
In the customer orders table, grouping by customer id and pizza id and finding the count of pizza_id gives the number of pizzas ordered in each type by all customers.
Since, we want the name of the pizza type doing an inner join with pizza_names table using pizza_id as primary key.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. INNER Join (INNER JOIN | ON(condition))
3. COUNT()
4. GROUP BY, ORDER BY
*/
Alter table pizza_names alter column pizza_name varchar(30)

Select co.customer_id,pn.pizza_name,COUNT(co.pizza_id) as count_of_variety_pizzas_ordered 
from customer_orders co
inner join pizza_names pn
on co.pizza_id=pn.pizza_id
group by co.customer_id,pn.pizza_name
order by co.customer_id;

/*Insight: Vegetarian pizza was bought only once or never by all 5 customers of the restaurant. Repeated orders by each customer was only for meatlovers*/ 

--6. What was the maximum number of pizzas delivered in a single order?

/* 
Execution steps:
1. Joining tables customer_orders and runner_orders on order_id as primary key to filter out the cancelled orders.
2. Finding the count of pizza_id ordered for each customer_id group using 'group by' clause and count function.
3. Ordering the result in descending order of no_of_pizzas_delivered for each customer and returning the top 1 record to get the order_id with maximum pizzas ordered.
*/

/* 
Keywords/Functions used:
1. SELECT, FROM, WHERE
2. INNER Join (INNER JOIN | ON(condition))
3. COUNT()
4. GROUP BY, ORDER BY
5. TOP n
*/

Select top 1 co.order_id,co.customer_id,COUNT(co.pizza_id) as no_of_pizzas_delivered 
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id 
where cancellation is null 
group by co.order_id,co.customer_id
order by no_of_pizzas_delivered desc

/*Insight: Customer_id 103 ordered more pizzas in a single order than any other customers and it was the only order successfully to that customer.*/

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
/*
Execution steps:
1. Joining tables customer_orders and runner_orders on order_id as primary key to filter out the cancelled orders.
2. Using case when statemnts for two conditions. One for pizzas with no change in the toppings. Second for pizzas with atleast one change in the topping 
(either addition or removal of a topping).
3. When condition satisfied, return 1 else 0 for both cases. 
4. Now, grouping by customer_id and summing up the result of case when statements to get the count of pizzas satisfying each of the conditions for each customer.
*/

/*
Keywords/Functions used:
1. SELECT, FROM, WHERE
2. INNER Join (INNER JOIN | ON(condition))
3. COUNT()
4. GROUP BY, ORDER BY
5. CASE WHEN with aggregate function SUM()
*/

Select co.customer_id, sum(case when co.exclusions is null and co.extras is null then 1 else 0 end) as no_change ,
sum(case when co.exclusions is not null or co.extras is not null then 1 else 0 end) as atleast_one_change
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id 
where ro.cancellation is null
group by customer_id
order by customer_id

/* Customers 101, 102, 103 preferred no change in the pizza toppings in all their orders so far. 
While other 2 customers preferred some changes with all or some of their orders.*/

--8. How many pizzas were delivered that had both exclusions and extras?

/*
Execution steps:
1. Joining tables customer_orders and runner_orders on order_id as primary key to filter out the cancelled orders.
2. Filtering in only the pizza orders that had both exclusions and extras as not null.
3. Aggregating and returning the count of pizza_id in customer_orders table to get the total number of pizzas with both changes.
*/

/*
Keywords/Functions used:
1. SELECT, FROM, WHERE
2. INNER Join (INNER JOIN | ON(condition))
3. COUNT()
*/

Select COUNT(co.pizza_id) as Pizzas_with_both_changes 
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id 
where co.exclusions is not null and co.extras is not null and ro.cancellation is null

/*Insight: Only one pizza required for both removal and addition of toppings in the pizza ordered. 
Rest of the orders placed requested only of either exclusion or addition of certain toppings or neither. */

--9. What was the total volume of pizzas ordered for each hour of the day?\

/*
Execution Steps:
1. Since the requirement is to find the aggregated hourly pizza orders, creating a new 'sequence' table with a sequence of numbers 1 to 24.
2. In the customer_orders table, using DATEPART function to return the hour format of order_time and grouping it to get count of pizza order placed in each hour.
3. Doing a right join of the resulting table from prevous step and sequence table using 'hour' format of the 'order_time' column 
  and 'hrs' column of the sequence table as primary key.
4. Return the hour and count of pizza orders placed in that specific hour. Using coalesce function to replace null with 0 in case no orders placed in a specific hour.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Right Join (RIGHT JOIN | ON(condition))
3. COUNT()
4. GROUP BY, ORDER BY
5. COALESCE
6. Subquery
7. DATEPART()
*/

create table sequence(hrs int)
drop table sequence
Declare @count int=1

while @count<=24
begin
insert into sequence values(@count);
set @count=@count+1;
end;

Select * from sequence;

Select s.hrs as hour_of_the_day,coalesce(A.no_of_pizzas_ordered,0) as no_of_pizzas_ordered from (
Select DATEPART(hour,order_time) hr_of_the_day,COUNT(1) as no_of_pizzas_ordered from customer_orders group by DATEPART(hour,order_time)) A 
right join sequence s 
on A.hr_of_the_day=s.hrs 
where A.no_of_pizzas_ordered!=0
order by hour_of_the_day

/*Insight: More orders were placed in the 13th, 18th, 21st and 23rd hours of the days. No sales in the morning time After 6 pm is the peak hours */

--10. What was the volume of orders for each day of the week?

/*
1. The requirement is to find the aggregated weekday orders, creating a new 'weekday_sequence' table with a sequence of numbers 1 to 7.
2. Creating a subquery: In the customer_orders table, using DATEPART function to return the weekday format of order_time and 
   grouping it to get count of unique orders placed in each weekday.
3. Doing a right join of the subquery with the 'Weekly_sequence' table on weekday number values as primary key column.
4. Return the weekday and count of unique orders placed. Using coalesce function to replace null with 0 in case no orders placed in a specific weekday.
*/

/*
Keywords/Functions used:
1. SELECT, FROM
2. Right Join (RIGHT JOIN | ON(condition))
3. COUNT(), DISTINCT
4. GROUP BY
5. COALESCE
6. Subquery
7. DATEPART()
*/
create table weekday_sequence(weekdays int)
drop table weekday_sequence
declare @count1 int=1;

while @count1<=7
begin
insert into weekday_sequence values(@count1);
set @count1=@count1+1;
end;

Select * from weekday_sequence;

Select ws.weekdays,coalesce(A.no_of_orders_placed,0) no_of_orders_placed from

(Select DATEPART(weekday,order_time)  as weekday_of_the_order, count(distinct order_id) no_of_orders_placed 
from customer_orders group by DATEPART(weekday,order_time)) A 

right join weekday_sequence ws 
on A.weekday_of_the_order=ws.weekdays


/*Insight: 
The customer_orders table shows only the first two week pizza order details. And the restaurant was started on a wednesday. 
No orders placed on weekdays 'Sunday' to 'Tuesday' so far. Half of the orders placed on wednesday. So may be day 1 sales contributed for more orders placed on wednesday*/


--																	B. Runner and Customer Experience

--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

-- Table contains data only for Jan 1st 2021
/*Execution steps:
1. Using DATEADD, DATEPART, EOMONTH functions to identify the weeknumber of a date in a specific month.
2. Using 'Group by' clause and grouping by weeknumber calculated from previous step, to find the number of runners registered in each week irrespective of the month.
*/
/*
Keywords/Functions used:
1. SELECT, FROM
2. COUNT()
3. GROUP BY
4. DATEPART()
5. EOMONTH()
6. DATEADD()
*/

Select DATEPART(week,registration_date)-datepart(week,dateadd(day,1,EOMONTH(registration_date,-1)))+1 as weeknumber,
COUNT(1) as no_of_signed_up_runners 
from runners
group by DATEPART(week,registration_date)-datepart(week,dateadd(day,1,EOMONTH(registration_date,-1)))+1 ;

/* Insights:
All 4 runners signed up within the first 3 weeks of the month. 2 users in the 2nd week. And one each in the 1st and 3rd week.
*/

/*
create table week_signup(weeknumber int)
declare @count2 int=1;
while @count2<=(Select distinct DATEPART(week,EOMONTH(registration_date,0))-datepart(week,dateadd(day,1,EOMONTH(registration_date,-1)))+1 as weeknumber from runners)
begin
insert into week_signup values(@count2)
set @count2=@count2+1
end;

--Select * from week_signup;
--Select EOMONTH('2020-01-01',0)
--Select DATEPART(week,'2023-05-31')-datepart(week,dateadd(day,1,EOMONTH('2023-05-31',-1)))+1 as weeknumber --To calculate no of weeks in a month/ weeknumber of last day in a month


with cte as(
Select weeknumber,COUNT(1) as no_of_signed_up_runners from (
Select DATEPART(week,registration_date)-datepart(week,dateadd(day,1,EOMONTH(registration_date,-1)))+1 as weeknumber from runners) B 
group by weeknumber)

Select ws.weeknumber,coalesce(cte.no_of_signed_up_runners,0) as no_of_signed_up_runners from cte right join week_signup ws on cte.weeknumber=ws.weeknumber */

--2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
/*
Execution steps:
1. Joining tables customer_orders and runner_orders on order_id as primary key and filter out the cancelled orders.
2. Using datediff function to get the difference between each ordertime and runner's pickuptime in minutes.
3. Calculate the average pickuptime in minutes for each runner using average function partitioned by each runner_id.
*/

/*
Keyword/Functions used:
1. SELECT,FROM, WHERE
2. Inner Join (INNER JOIN | ON(condition))
3. DISTINCT
4. CTE
5. DATEDIFF()
6. Aggregate function AVG() with over() clause
*/

with cte as(
Select distinct co.order_id,ro.runner_id,datediff(MINUTE,order_time,pickup_time) as pickup_time_diff_in_mins 
from customer_orders co 
inner join runner_orders ro
on co. order_id=ro.order_id 
where cancellation is null)

Select distinct runner_id,avg(pickup_time_diff_in_mins) over (partition by runner_id) avg_pickup_time_diff from cte

/*Inights: Runner id 3 delivered only one order since registered and has less average time compared to runners 1 and 2. 
High average time of runners 1 and 2 doesn't mean they are less effecient.
It could be also due to one or two of the delivery orders might have been picked up late for some valid reasons like engaged in other deliveries 
or it took long time to prepare the order, affecting the overall avg pickup time. */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
/*
Execution Steps:
1. Joining tables customer_orders and runner_orders on order_id as primary key and filter out the cancelled orders.
2. Using datediff function to find the difference between each ordertime and runner's pickuptime in minutes.
3. Grouping by each order_id and taken taken in minutes to pickup the order and find the number of pizzas ordered in each order.
*/

/*Keywords/Functions used:
1. SELECT,FROM, WHERE
2. Inner Join (INNER JOIN | ON(condition))
3. COUNT()
4. DATEDIFF()
5. Order By, Group By
*/ 

Select co.order_id,DATEDIFF(minute,co.order_time,ro.pickup_time) as preparation_time,COUNT(co.pizza_id) as number_of_pizzas_ordered
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
where ro.cancellation is null
group by co.order_id,DATEDIFF(minute,co.order_time,ro.pickup_time)
order by order_id

/* Insight: From the above result set, it is obvious that there is a positive relationship between number of pizzas ordered and time taken to prepare the order. */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

--4.What was the average distance travelled for each customer?
/*
1. Joining tables customer_orders and runner_orders on order_id as primary key and filter out the cancelled orders.
2. Using distinct function to get unique order_id,customer_id and the distance to reach the customer location. 
   If duplicate rows not removed, the result will be affected while calculating avg distance.
3. If the same customer has made multiple orders from same/different location, group by customer_id and find the avg distance to reach each customer location.
*/

/*
Keywords/Functions used:
1. SELECT,FROM, WHERE
2. Inner Join (INNER JOIN | ON(condition))
3. Avg(), Format()
4. DISTINCT
5. Group By 
6. Subquery
*/

Select customer_id,format(avg(distance),'N2') as average_distance_in_kms from (
Select distinct co.order_id,co.customer_id,ro.distance
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null)A
group by customer_id

/*
Insight: Except customer 105, other customers are around 20 mins away from the pizza runner. */

/*
The below method is wrong:

Select co.customer_id,format(avg(ro.distance),'N2') as average_distance_in_kms
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null
group by co.customer_id
order by co.customer_id
*/


--5.What was the difference between the longest and shortest delivery times for all orders?

Select MAX(duration)-MIN(duration) shortest_longest_duration_difference from runner_orders;

--6.What was the average speed for each runner for each delivery and do you notice any trend for these values?
/*
Execution steps:
1. Filtering out cancelled orders from runner_orders table.
2. Dividing distance by duration to calculate the average speed of each runner and grouping by runner_id. 
*/

/*
Keyword/Function used:
1. SELECT,FROM, WHERE
2. Avg(), Format()
3. Group By 
*/

Select runner_id,format(avg(distance/duration),'N2') as avg_speed_kmpm from runner_orders where cancellation is null group by runner_id;
--Select order_id,runner_id,distance,duration,format(distance/duration,'N2') as speed_kmpm from runner_orders where cancellation is null;

--Insights:
--Even though runner_id '1' has taken more orders than  runner_id '2' and '3', runner_id '2' is slightly faster than runner_id '1' 
--on average, considering the distance and time taken to travel. Runner_id '3' has taken only one order but still, for the same distance runner_id '1' was even more faster.
--Therefore, avg speed of runners goes like this ----   2>1>3 

--7.What is the successful delivery percentage for each runner?
/*
Execution steps:
1. USing case when statement along with sum function to get the number of successful deliveries of each runner.
2. Diving the result from step 1 by count of total orders assigned by a runner returns the successful_delevery_Percentage of each runner.
3. Group by runner_id to get the above result for each runner
*/

/*
Keywords/Functions used:
1. SELECT,FROM
2. CASE WHEN with aggregate function SUM()
3. COUNT()
4. CAST()
5. Group By 
*/

Select runner_id,cast(sum(case when cancellation is null then 1 else 0 end)*100.0/COUNT(runner_id) as float) as sucessful_delivery_percentage
from runner_orders
group by runner_id

/*Insights: Runner id 1 and 2 got 4 orders each to deliver. Runner id 3 got only 2 orders to deliver since he/she joined one week after the pizza runner launched
No orders of runner id 1 were cancelled either by the restaurant or the customer. 
But for other two runners, each got cancelled with one order, either by customer or restaurant. 
*/

																--C. Ingredient Optimisation
--1.What are the standard ingredients for each pizza?

/*
SELECT compatibility_level FROM sys.databases WHERE name = 'mybase'  
select @@VERSION */ 

/*Execution steps:
1. In the pizza_recipes table, the toppings added in each type are given as comma separated values. Hence spliting and displaying each value in individual record using
   string_split function and cross apply.
2. The resulting table from step1 is joined(inner join) with pizz_toppings table to get the names of each toppings added in pizza using topping_id as primary key.
3. Now, each row holds the pizza_id, topping_id and topping_name of the pizza type.
4. Now again, aggregating the toppings of each pizza type in a single row as comma separated values using string_agg function.
*/

/*
Keywords/Functions used:
1. SELECT,FROM
2. Subquery
3. Inner join(INNER JOIN | ON(CONDITION))
4. String_agg()
5. cross apply STRING_SPLIT() 
*/

Select pizza_id,string_agg(ingredient_id,' , ') as ingredient_id,string_agg(topping_name,' , ') as topping_name from 
(Select pizza_id,value as ingredient_id from pizza_recipes cross apply string_split(toppings,',')) pr 
inner join pizza_toppings pt 
on pr.ingredient_id=pt.topping_id
group by pizza_id;


--2.What was the most commonly added extra?

/*Execution steps:
1. Filtering out all the null values from extras and doing a 'string_split' using cross apply to return all the comma seprated extras values in individual rows.
2. Since the extras are in csv in customer_orders, after spliting it has to be converted into integer values using cast() function.
3. 'Group by' the splitted extras values to get the count of each extras.
4. Order by 'count of extras' is descending order and return the top 1 record to get most commonly added extras.
*/

/*
Keyword/Functions used:
1. SELECT,FROM, WHERE
2. Subquery
3. Inner join(INNER JOIN | ON(CONDITION))
4. CTE
5. cross apply STRING_SPLIT() 
6. GROUP BY,ORDER BY
7. COUNT(),CAST()
*/

with cte as(
Select top 1 cast(value as int) as extras,count(1) as count_of_extras 
from customer_orders cross apply string_split(extras,',')
where extras is not null 
group by cast(value as int)
order by count_of_extras desc)

Select cte.extras,pt.topping_name,cte.count_of_extras 
from cte 
inner join pizza_toppings pt 
on pt.topping_id=cte.extras

/*Insight: Bacon is the most commonly added extras and it was requested to add in the pizza for 4 times so far. */

--3.What was the most common exclusion?

/*Execution steps:
1. Filtering out all the null values from exclusions and doing a 'string_split' using cross apply to return all the comma seprated exclusions values in individual rows.
2. Since the exclusions are in csv in customer_orders, after spliting it has to be converted into integer values using cast() function.
3. 'Group by' the splitted exclusions values to get the count of each exclusions.
4. Order by 'count of exclusions' is descending order and return the top 1 record to get most common exclusions.
*/

/*
Keyword/Functions used:
1. SELECT,FROM, WHERE
2. Subquery
3. Inner join(INNER JOIN | ON(CONDITION))
4. CTE
5. cross apply STRING_SPLIT() 
6. GROUP BY,ORDER BY
7. COUNT(),CAST()
*/
with cte as(
Select top 1 cast(value as int) as exclusions,COUNT(1) as no_of_exclusions 
from customer_orders cross apply string_split(exclusions,',') 
where exclusions is not null
group by cast(value as int)
order by no_of_exclusions desc)

Select cte.exclusions,pt.topping_name,cte.no_of_exclusions 
from cte 
inner join pizza_toppings pt 
on pt.topping_id=cte.exclusions

/*Insight: Cheese is the most common exclusion and it was requested not to add in the pizza 4 times so far. */

--4.Generate an order item for each record in the customers_orders table in the format of one of the following:
			--Meat Lovers
			--Meat Lovers - Exclude Beef
			--Meat Lovers - Extra Bacon
			--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

/*
Execution steps:
1. Creating two separate tables for exclusions and extras from customer_orders table
2. In a separate cte, return exclusions of each pizza ordered from the customer_orders table and row number for each record after filtering out null values.
3. Using string_split and cross apply, separate all the comma seprated values of exclusion into individual records and do an inner join with pizza_toppings table.
4. Step 3 returns the exclusion and its topping_name along with the row number. Add this result in another cte.
5. Now again group by row_number and do a string aggregation to get comma seprated values of 
   exclusion id and topping_name. Use 'distinct' function to remove duptical records.
6. Repeat steps 1 to 5 for extras attribute as well.
7. Reults of step 5 and 6 are inserted into newly created tables for exclusions and extras.
*/

/*
Keyword/Functions used:
1. SELECT,FROM, WHERE, INSERT INTO
2. Subquery
3. Inner join(INNER JOIN | ON(CONDITION))
4. CTE
5. cross apply STRING_SPLIT(),STRING_AGG(),CAST() 
6. GROUP BY
7. ROW_NUMBER() OVER(PARTITION BY... [OPTIONAL] ORDER BY)
*/

create table exclusions(ingredient_id varchar(10),topping_name varchar(30));
create table extras(ingredient_id varchar(10),topping_name varchar(30));
drop table exclusions
drop table extras

-- inserting the exclusion ingredient_id from customer_orders table and corresponding topping names in a new table

with cte as(
Select exclusions,ROW_NUMBER() over(order by exclusions) as rn 
from customer_orders 
where exclusions is not null),

cte1 as(
Select A.rn,A.ingredient_id,pt.topping_name from (
Select rn,cast(value as int) as ingredient_id from cte cross apply string_split(exclusions,',')) A
inner join pizza_toppings pt
on A.ingredient_id=pt.topping_id)

insert into exclusions(ingredient_id,topping_name)(
Select distinct STRING_AGG(ingredient_id,', ') as ingredient_id,
STRING_AGG(topping_name,', ') as topping_name
from cte1
group by rn);

------------------------------------------------------------------------
-- inserting the extras ingredient_id from customer_orders table and corresponding topping names in a new table 

with cte as(
Select extras,ROW_NUMBER() over(order by extras) as rn 
from customer_orders 
where extras is not null),

cte1 as(
Select A.rn,cast(A.ingredient_id as int) as ingredient_id,pt.topping_name from (
Select rn,value as ingredient_id from cte cross apply string_split(extras,',')) A
inner join pizza_toppings pt
on A.ingredient_id=pt.topping_id)

insert into extras(ingredient_id,topping_name)(
Select  distinct STRING_AGG(ingredient_id,', ') as ingredient_id,
STRING_AGG(topping_name,', ') as topping_name
from cte1
group by rn)

Select * from exclusions
Select * from extras

--Joining all the required tables and using concatenation along with case when statements to get the desired output

/*Execution steps:
1. Doing inner join of customer_orders and pizza_names table on pizza_id. And again doing a left join with 'exclusions' and 'extras' table with
   with exclusions and extras attributes from customer_orders as primary key.
2. Using case when statements with following conditions to insert a new attribute with expected values from the requirement:
i) when both exlcusions are null, return only the pizza name
ii) when both are not null, concat pizza name, name of the pizza topping excluded and name of the pizza topping included
iii) when exclusion is null and extras is not null, concat pizza name, name of the pizza topping excluded.
\iii) when extras is null and exclusions is not null, concat pizza name, name of the pizza topping included.
*/

/*
Keyword/Functions used:
1. SELECT,FROM
2. CONCAT()
3. Multiple joins(INNER JOIN | ON(CONDITION),LEFT JOIN | ON(CONDITION))
4. CASE WHEN.. THEN.. ELSE.. END
*/

Select co.*,case when exclusions is not null and extras is not null then
concat(pn.pizza_name,'- Exclude ',e.topping_name,'- Extra ',et.topping_name) 
when exclusions is null and extras is not null then
concat(pn.pizza_name,'- Extra ',et.topping_name)
when exclusions is not null and extras is null then
concat(pn.pizza_name,'- Exclude ',e.topping_name)
else pn.pizza_name end as pizza_type_ingredients
from customer_orders co
inner join pizza_names pn
on pn.pizza_id=co.pizza_id
left join exclusions e
on co.exclusions=e.ingredient_id
left join extras et
on co.extras=et.ingredient_id



--5.Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
			--For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"


with cte as(
Select A.pizza_id,string_agg(A.ingredient_id,',') as ingredient_id,string_agg(pt.topping_name,',') as topping_name from(
Select pizza_id,trim(value) as ingredient_id from pizza_recipes cross apply string_split(toppings,',')) A
inner join pizza_toppings pt
on A.ingredient_id=pt.topping_id
group by A.pizza_id),

cte1 as(
Select row_number()over (order by order_id) rn,co.*,concat(e.topping_name,',',cte.topping_name) as toppings
from customer_orders co 
left join exclusions e 
on co.exclusions=e.ingredient_id
inner join cte 
on cte.pizza_id=co.pizza_id),

cte2 as(
Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,trim(value) as toppings
from cte1 cross apply string_split(toppings,',')),

cte3 as(
Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,toppings,COUNT(1) as excluded_id from cte2
group by rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,toppings
),

cte4 as(
Select cte1.rn,cte1.order_id,cte1.customer_id,cte1.pizza_id,cte1.exclusions,cte1.extras,cte1.order_time,concat(e.topping_name,',',A.toppings) as toppings
from cte1 inner join 
(Select rn,string_agg(toppings,',') as toppings from cte3 where toppings!='' and excluded_id=1 group by rn) A
on A.rn=cte1.rn
left join extras e
on e.ingredient_id=cte1.extras),



cte5 as(
Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,trim(value) as toppings from cte4 cross apply string_split(toppings,',')),


cte6 as(
Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,toppings,COUNT(1) as extras_num from cte5
group by rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,toppings
)

Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,
string_agg(case when extras_num=2 then  concat(extras_num,'x',toppings) else toppings end,',') as toppings
from cte6
where toppings!=''
group by rn,order_id,customer_id,pizza_id,exclusions,extras,order_time;


--6.What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

with cte as(
Select A.pizza_id,string_agg(A.ingredient_id,',') as ingredient_id,string_agg(pt.topping_name,',') as topping_name from(
Select pizza_id,trim(value) as ingredient_id from pizza_recipes cross apply string_split(toppings,',')) A
inner join pizza_toppings pt
on A.ingredient_id=pt.topping_id
group by A.pizza_id),

cte1 as(
Select row_number()over (order by order_id) rn,co.*,concat(e.topping_name,',',cte.topping_name) as toppings
from customer_orders co 
left join exclusions e 
on co.exclusions=e.ingredient_id
inner join cte 
on cte.pizza_id=co.pizza_id),

cte2 as(
Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,trim(value) as toppings
from cte1 cross apply string_split(toppings,',')),

cte3 as(
Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,toppings,COUNT(1) as excluded_id from cte2
group by rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,toppings
),

cte4 as(
Select cte1.rn,cte1.order_id,cte1.customer_id,cte1.pizza_id,cte1.exclusions,cte1.extras,cte1.order_time,concat(e.topping_name,',',A.toppings) as toppings
from cte1 inner join 
(Select rn,string_agg(toppings,',') as toppings from cte3 where toppings!='' and excluded_id=1 group by rn) A
on A.rn=cte1.rn
left join extras e
on e.ingredient_id=cte1.extras),


cte5 as(
Select rn,order_id,customer_id,pizza_id,exclusions,extras,order_time,trim(value) as toppings from cte4 cross apply string_split(toppings,','))

Select toppings,COUNT(1) as Tot_no_of_times_used from cte5
where toppings!=''
group by toppings
order by Tot_no_of_times_used desc



																--D. Pricing and Ratings 

/* 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
- how much money has Pizza Runner made so far if there are no delivery fees? */

/*
Execution steps:
1. The customer_ordser table contains only pizza_id for each pizza ordered. But to assign price for each pizza type we need to know the pizza names. 
   Hence, joining customer_orders with pizza_names table to return the names of each pizza ordered.
2. Filter out all the cancelled orders.
3. Using case when statements to create a new revenue attribute by assigning 12$ for meatlover and 10$ for vegetarian.
4. Summing up all the values of revenues column resulted from case when statement, returns total sales_revenue of pizza_runner.
*/

/*
Keyword/Function used:
1. SELECT, FROM, WHERE
2. CASE WHEN with SUM()
3. Multiple inner joins( INNER JOIN| ON(CONDITION))
*/

Select sum(case when pn.pizza_name='Meatlovers' then 12 when pn.pizza_name='Vegetarian' then 10 end) as sales_revenue
from customer_orders co 
inner join pizza_names pn on co.pizza_id=pn.pizza_id 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null;

-- In the first 2 weeks of time, pizza runner genrated sales revenue of 138$.

/* 2. What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra*/

/*Execution steps:
1. Doing inner join of customer_orders table and pizza_names to get the names of each pizza ordered. 
2. The resulting table is again joined (inner join) with runner_orders table to filter out cancelled orders.
3. Using case when statements to create a new revenue attribute to assign prices - 12$ for meatlover and 10$ for vegetarian.
4. One more attribute created to add 1$ extra for each extras added in the pizza. To compute this, remove all charecters from the extras 
   other than pizza_ids(comma, space) using replce function and find the length of the reulting string. This returns the number of extras added in the pizza.
5. Number of extras added is equal to the extra price charged. Hence using case when statement with following conditions 
   - when extras is null, return 0 else when length of the string after removing all special characters >=1 then return length of the string itself.
6. Summing up all the values of two new attributes returns the expected result.
*/

/*
Keywords/Functions used:
1. SELECT, FROM, WHERE
2. CASE WHEN
3. Multiple inner joins( INNER JOIN| ON(CONDITION))
4. SUM()
5. LEN(), REPLACE()
6. CTE
*/
with cte as(
Select co.*,pn.pizza_name, case when pn.pizza_name='Meatlovers' then 12 when pn.pizza_name='Vegetarian' then 10 end as cost,
case when len(REPLACE(extras,', ',''))>=1 then len(REPLACE(extras,', ','')) else 0 end as extras_charge
from customer_orders co 
inner join pizza_names pn on co.pizza_id=pn.pizza_id 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null)
Select sum(cost+extras_charge) as tot_charge from cte;

-- Additional 4$ revenue received due to additional charge for extras added in pizzas.

/* 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings 
for each successful customer order between 1 to 5. */

Select * from runner_orders

Select order_id,runner_id into runner_rating from runner_orders where cancellation is null
Alter table runner_rating add rating float;
update runner_rating set rating=3.5 where order_id=1
update runner_rating set rating=4 where order_id=2
update runner_rating set rating=4.2 where order_id=3
update runner_rating set rating=3 where order_id=4
update runner_rating set rating=4.6 where order_id=5
update runner_rating set rating=4.8 where order_id=7
update runner_rating set rating=5 where order_id=8
update runner_rating set rating= 5where order_id=10
Select * from runner_rating;
 --Added a random rating ranging from 1 to 5 for each orders including average speed as criteria


/* 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
customer_id
order_id
runner_id
rating
order_time
pickup_time
Time between order and pickup
Delivery duration
Average speed
Total number of pizzas */


Select co.order_id,co.customer_id,ro.runner_id,rr.rating,co.order_time,ro.pickup_time,DATEDIFF(minute,co.order_time,ro.pickup_time) as time_diff,
ro.duration,round(cast(ro.distance*1.0/ro.duration as float),2) as avg_speed,COUNT(pizza_id) no_of_pizzas 
from customer_orders co 
inner join runner_orders ro on co.order_id = ro.order_id
inner join runner_rating rr on ro.order_id=rr.order_id
where ro.cancellation is null 
group by co.order_id,co.customer_id,co.order_time,ro.pickup_time,DATEDIFF(minute,co.order_time,ro.pickup_time),ro.runner_id,ro.distance,ro.duration,
rr.rating,ro.distance*1.0/ro.duration

-- Doing an inner join of all required tables and returning the expected attributes in the output.

/* 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
how much money does Pizza Runner have left over after these deliveries? */

/*
Execution steps:
1. The customer_ordser table contains only pizza_id for each pizza ordered. But to assign price for each pizza type we need to know the pizza names. 
   Hence, joining customer_orders with pizza_names table to return the names of each pizza ordered.
2. Filter out all the cancelled orders.
3. Using case when statements to create a new revenue attribute by assigning 12$ for meatlover and 10$ for vegetarian.
4. Summing up all the values of revenues column resulted from case when statement, returns total sales_revenue of pizza_runner.
5. For calculating expenses for runners, multiplying distance and 0.30 (since for each km travel, they were provided with 0.30$) and summing up the results.
6. Subrtacting step 5 from step4 returns the profit earned by pizza_runner.
*/

/*
Keyword/Function used:
1. SELECT, FROM, WHERE
2. CASE WHEN with SUM()
3. Multiple inner joins( INNER JOIN| ON(CONDITION))
4. CROSS JOIN
5. SUM()
6. CTE
7. Subquery
*/
with cte as(
Select sum(case when pn.pizza_name='Meatlovers' then 12 when pn.pizza_name='Vegetarian' then 10 end) as sales_revenue
from customer_orders co 
inner join pizza_names pn on co.pizza_id=pn.pizza_id 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null
)
Select sales_revenue-runner_delivery_charge as balance from
(Select * from cte)A
cross join
(Select sum(distance*0.30) as runner_delivery_charge from runner_orders where cancellation is null)B
--After overall expenses 43.56$, the pizza runner earned a profit of 94.4$ in the first two weeks of time.





