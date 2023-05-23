
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

  Select * from runners;
  Select * from customer_orders;
  Select * from runner_orders;
  Select * from pizza_names;
  Select * from pizza_recipes;
  Select * from pizza_toppings;

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

--																			A. Pizza Metrics

--1. How many pizzas were ordered?

Select COUNT(1) as no_of_pizzas_ordered from customer_orders

--2. How many unique customer orders were made?

Select count(distinct order_id) unique_customer_orders from customer_orders --Doubt on the question

--3. How many successful orders were delivered by each runner?

Select r.runner_id,COUNT(ro.runner_id) as delivered_orders_count_by_runners
from runner_orders ro
right join runners r
on ro.runner_id=r.runner_id
where cancellation is null 
group by r.runner_id 
order by r.runner_id

--4. How many of each type of pizza was delivered?

Select pn.pizza_id,COUNT(co.pizza_id) as no_of_delivered_pizzas
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
right join pizza_names pn
on pn.pizza_id=co.pizza_id
where ro.cancellation is null
group by pn.pizza_id

--5. How many Vegetarian and Meatlovers were ordered by each customer?
Alter table pizza_names alter column pizza_name varchar(30)

Select co.customer_id,pn.pizza_name,COUNT(co.pizza_id) as count_of_variety_pizzas_ordered 
from customer_orders co
inner join pizza_names pn
on co.pizza_id=pn.pizza_id
group by co.customer_id,pn.pizza_name
order by co.customer_id;

--6. What was the maximum number of pizzas delivered in a single order?

with cte as(
Select co.order_id,COUNT(1) as no_of_pizzas_delivered 
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id 
where cancellation is null 
group by co.order_id)
Select * from cte where no_of_pizzas_delivered=(Select MAX(no_of_pizzas_delivered) from cte)

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

Select customer_id,SUM(no_change) as no_change,SUM(atleast_one_change) as atleast_one_change from 
(
Select co.customer_id, case when co.exclusions is null and co.extras is null then 1 else 0 end as no_change ,
case when co.exclusions is not null or co.extras is not null then 1 else 0 end as atleast_one_change
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id 
where ro.cancellation is null
) A
group by customer_id
order by customer_id



--8. How many pizzas were delivered that had both exclusions and extras?

Select COUNT(1) as Pizzas_with_both_changes from customer_orders where exclusions is not null and extras is not null

--9. What was the total volume of pizzas ordered for each hour of the day?

create table sequence(a int)
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
--where a.no_of_pizzas_ordered!=0
order by hour_of_the_day

--10. What was the volume of orders for each day of the week?

create table weekday_sequence(weekdays int)
declare @count1 int=1;

while @count1<=7
begin
insert into weekday_sequence values(@count1);
set @count1=@count1+1;
end;

Select * from weekday_sequence;




with cte as(
Select weekday_of_the_order,COUNT(1) as no_of_orders_placed from (
Select order_id,DATEPART(weekday,order_time) as weekday_of_the_order from customer_orders group by order_id,DATEPART(weekday,order_time))A
group by weekday_of_the_order)
Select ws.weekdays,coalesce(cte.no_of_orders_placed,0) as no_of_orders_placed from cte right join weekday_sequence ws on cte.weekday_of_the_order=ws.weekdays
order by weekday_of_the_order


--																	B. Runner and Customer Experience

--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

-- Table contains data only for Jan 1st 2021
create table week_signup(weeknumber int)
declare @count2 int=1;
while @count2<=(Select distinct DATEPART(week,EOMONTH(registration_date,0))-datepart(week,dateadd(day,1,EOMONTH(registration_date,-1)))+1 as weeknumber from runners)
begin
insert into week_signup values(@count2)
set @count2=@count2+1
end;

Select * from week_signup;
Select EOMONTH('2020-01-01',0)
Select DATEPART(week,'2023-05-31')-datepart(week,dateadd(day,1,EOMONTH('2023-05-31',-1)))+1 as weeknumber --To calculate weeknumber of the specific month of the given date

with cte as(
Select weeknumber,COUNT(1) as no_of_signed_up_runners from (
Select DATEPART(week,registration_date)-datepart(week,dateadd(day,1,EOMONTH(registration_date,-1)))+1 as weeknumber from runners) B 
group by weeknumber)

Select ws.weeknumber,coalesce(cte.no_of_signed_up_runners,0) as no_of_signed_up_runners from cte right join week_signup ws on cte.weeknumber=ws.weeknumber

--2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

with cte as(
Select A.order_id,B.runner_id,datediff(MINUTE,A.order_time,B.pickup_time)as pickup_time_diff_in_mins from 
(Select distinct order_id,order_time from customer_orders)A inner join 
(Select order_id,runner_id,pickup_time,cancellation from runner_orders) B on A. order_id=B.order_id where cancellation is null)
Select distinct r.runner_id,AVG(pickup_time_diff_in_mins)  avg_pickup_time_by_each_runner from cte right join runners r on r.runner_id=cte.runner_id group by r.runner_id


--3.Is there any relationship between the number of pizzas and how long the order takes to prepare?

Select order_id,preparation_time,COUNT(1) as number_of_pizzas_ordered from(
Select co.order_id,DATEDIFF(minute,co.order_time,ro.pickup_time) as preparation_time 
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
where ro.cancellation is null) A group by order_id,preparation_time

--From the above result set, it is obvious that there is a relationship between number of pizzas ordered and time taken to prepare the order.

--4.What was the average distance travelled for each customer?


Select customer_id,format(avg(distance),'N2') as average_distance_in_kms from (
Select distinct co.order_id,co.customer_id,ro.distance
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null)A
group by customer_id

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

--Approach1
Select MAX(time_to_pickup)-MIN(time_to_pickup) as diff_of_lng_shrt_delivery from (
Select distinct co.order_id,DATEDIFF(minute,co.order_time,ro.pickup_time) as time_to_pickup
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
where ro.cancellation is null) A

--Approach2
Select Max(DATEDIFF(minute,co.order_time,ro.pickup_time))-MIN(DATEDIFF(minute,co.order_time,ro.pickup_time)) as diff_of_lng_shrt_delivery
from customer_orders co 
inner join runner_orders ro 
on co.order_id=ro.order_id
where ro.cancellation is null

--6.What was the average speed for each runner for each delivery and do you notice any trend for these values?

--Select order_id,runner_id,distance,duration,format(distance/duration,'N2') as speed_kmpm from runner_orders where cancellation is null;

Select runner_id,format(avg(distance/duration),'N2') as avg_speed_kmpm from runner_orders where cancellation is null group by runner_id;

--Even though runner_id '1' has taken more orders than  runner_id '2' and '3', runner_id '2' is slightly faster than runner_id '1' 
--on average, considering the distance and time taken to travel. Runner_id '3' has taken only one order but still, for the same distance runner_id '1' was even more faster.
--Therefore, avg speed of runners goes like this ----   2>1>3 

--7.What is the successful delivery percentage for each runner?


with cte as(
Select runner_id,case when cancellation is null then 1 else 0 end as delivered_orders,
case when cancellation is not null then 1 else 0 end as cancelled_orders
from runner_orders)
Select runner_id,format((delivered_orders*1.0/(delivered_orders+cancelled_orders))*100,'N2') sucessful_delivery_percentage from(
Select runner_id,SUM(delivered_orders) as delivered_orders,SUM(cancelled_orders) as cancelled_orders from cte group by runner_id) B


																--C. Ingredient Optimisation
--1.What are the standard ingredients for each pizza?

alter table pizza_recipes alter column toppings varchar(30)
alter table pizza_toppings alter column topping_name varchar(50)

SELECT compatibility_level FROM sys.databases WHERE name = 'mybase'  
select @@VERSION  

Select pizza_id,string_agg(ingredient_id,' , ') as ingredient_id,string_agg(topping_name,' , ') as topping_name from 
(Select pizza_id,value as ingredient_id from pizza_recipes cross apply string_split(toppings,',')) pr inner join pizza_toppings pt on pr.ingredient_id=pt.topping_id
group by pizza_id;

--2.What was the most commonly added extra?

with cte as(
Select cast(value as int) as extras,count(1) as count_of_extras 
from customer_orders cross apply string_split(extras,',') 
where extras is not null group by cast(value as int))

Select * from cte where count_of_extras=(Select MAX(count_of_extras) from cte);

--3.What was the most common exclusion?
with cte as(
Select cast(value as int) as exclusions,COUNT(1) as no_of_exclusions 
from customer_orders cross apply string_split(exclusions,',') 
where exclusions is not null
group by cast(value as int))
Select * from cte where no_of_exclusions=(Select MAX(no_of_exclusions) from cte)

--4.Generate an order item for each record in the customers_orders table in the format of one of the following:
			--Meat Lovers
			--Meat Lovers - Exclude Beef
			--Meat Lovers - Extra Bacon
			--Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
/*
Select * from customer_orders where exclusions='4'
Select * from customer_orders outer apply string_split(extras,',')
Select * from customer_orders co 
inner join pizza_names pn 
on co.pizza_id=pn.pizza_id
inner join pizza_toppings pt
on co.exclusions=pt.topping_id or co.extras=pt.topping_id
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
Select A.rn,cast(A.ingredient_id as int) as ingredient_id,pt.topping_name from (
Select rn,value as ingredient_id from cte cross apply string_split(exclusions,',')) A
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

Select sum(case when pn.pizza_name='Meatlovers' then 12 when pn.pizza_name='Vegetarian' then 10 end) as sales_revenue
from customer_orders co 
inner join pizza_names pn on co.pizza_id=pn.pizza_id 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null;

/* 2. What if there was an additional $1 charge for any pizza extras?
Add cheese is $1 extra*/

with cte as(
Select co.*,pn.pizza_name,ro.cancellation, case when pn.pizza_name='Meatlovers' then 12 when pn.pizza_name='Vegetarian' then 10 end as cost,
case when extras is null then 0 when LEN(extras)-len(REPLACE(extras,',','')) >=0 then (LEN(extras)-len(REPLACE(extras,',','')))+1 end as extras_charge
from customer_orders co 
inner join pizza_names pn on co.pizza_id=pn.pizza_id 
inner join runner_orders ro 
on co.order_id=ro.order_id
where cancellation is null)
Select sum(cost+extras_charge) as tot_charge from cte;

/* 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings 
for each successful customer order between 1 to 5. */

Select order_id,runner_id into runner_rating from runner_orders where cancellation is null

Select * from runner_orders

Select * from runner_rating

update runner_rating set rating=4.6 where runner_id=3 and order_id=5

Alter table runner_rating add rating int;
Alter table runner_rating alter column rating float;

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
with cte as(
Select order_id,customer_id,order_time,COUNT(pizza_id) no_of_pizzas from customer_orders group by order_id,customer_id,order_time),
cte1 as(
Select ro.*,rr.rating from runner_orders ro inner join runner_rating rr on ro.order_id=rr.order_id where cancellation is null)
Select cte.customer_id,cte.order_id,cte1.runner_id,cte1.rating,cte.order_time,cte1.pickup_time, DATEDIFF(minute,order_time,pickup_time) as Time_taken_to_pickup,
cte1.duration,format(cte1.distance/cte1.duration,'N2') as average_speed ,cte.no_of_pizzas
from cte inner join cte1 on cte.order_id=cte1.order_id

/* 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
how much money does Pizza Runner have left over after these deliveries? */

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


/*																E. Bonus Questions
If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
Write an INSERT statement to demonstrate what would happen if 
a new Supreme pizza with all the toppings was added to the Pizza Runner menu? */


