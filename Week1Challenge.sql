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

Select customer_id,SUM(price) total_amount_spent 
from sales s 
inner join menu m 
on s.product_id=m.product_id 
group by customer_id

--2.How many days has each customer visited the restaurant?

Select  customer_id,count(distinct(order_date)) no_of_visits from sales group by customer_id;

--3.What was the first item from the menu purchased by each customer?
Select customer_id,order_date,product_id,product_name from
(Select s.*,m.product_name,ROW_NUMBER() over(partition by customer_id order by order_date) rn 
from sales s inner join menu m on s.product_id=m.product_id)a where rn=1

--4.What is the most purchased item on the menu and how many times was it purchased by all customers?

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

--5.Which item was the most popular for each customer?

With cte as
(Select customer_id,product_id,COUNT(product_id) ordered_count,RANK()over(partition by customer_id order by COUNT(product_id) desc) rank
from sales 
group by customer_id,product_id)
Select cte.customer_id,cte.product_id,m.product_name,cte.ordered_count from cte inner join menu m on m.product_id=cte.product_id where rank=1

--6.Which item was purchased first by the customer after they became a member?

Select customer_id,product_id,product_name,order_date,join_date from (
Select s.customer_id,s.product_id,m1.product_name,s.order_date,m.join_date,RANK() over (partition by s.customer_id order by s.order_date asc) as rn
from sales s 
inner join members m 
on s.customer_id=m.customer_id
inner join menu m1 
on s.product_id=m1.product_id
where s.order_date>=m.join_date) a where rn=1

--7.Which item was purchased just before the customer became a member?

Select customer_id,product_id,product_name,order_date,join_date from(
Select s.customer_id,s.product_id,m1.product_name,s.order_date,m.join_date,RANK() over (partition by s.customer_id order by s.order_date desc) rn
from sales s 
inner join members m 
on s.customer_id=m.customer_id 
inner join menu m1 
on m1.product_id=s.product_id 
where s.order_date<m.join_date) a where rn=1

--8.What is the total items and amount spent for each member before they became a member?

Select s.customer_id,COUNT(s.product_id) total_items,SUM(price) total_amount_spent
from sales s 
inner join members m 
on m.customer_id=s.customer_id 
inner join menu m1 on m1.product_id=s.product_id where m.join_date>s.order_date group by s.customer_id

--9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

Select s.customer_id,sum(price*case when product_name='sushi' then 20 else 10 end) as total_points
from sales s 
inner join menu m 
on m.product_id=s.product_id 
group by s.customer_id;

--10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - 
--how many points do customer A and B have at the end of January?

with cte as(
Select s.customer_id,s.order_date,m.join_date,s.product_id,m1.product_name,m1.price,20 as points_per_dollar
from sales s 
inner join members m 
on m.customer_id=s.customer_id 
inner join menu m1 on m1.product_id=s.product_id
where DATEDIFF(week,join_date,order_date) in (0,1) and m.join_date<=s.order_date and DATEPART(month,order_date)=1),

cte1 as(
Select s.customer_id,s.order_date,m.join_date,s.product_id,m1.product_name,m1.price,case when product_name='sushi' then 20 else 10 end as points_per_dollar
from sales s 
inner join members m 
on m.customer_id=s.customer_id 
inner join menu m1 on m1.product_id=s.product_id
where m.join_date>s.order_date)

Select customer_id ,SUM(price*points_per_dollar) as total_points from(
Select * from cte union all Select * from cte1) cte group by customer_id;

--Ranking based on Membership. Mention as null if not a member

with cte as(
Select s.customer_id,s.order_date,m.product_name,m.price,
case when s.order_date>=m1.join_date then 'Y' else 'N' end as member
from sales s 
inner join menu m 
on s.product_id=m.product_id
inner join members m1
on s.customer_id=m1.customer_id),
cte1 as(
Select customer_id,order_date,member,RANK() over(partition by customer_id order by order_date) ranking from cte where member='Y')
Select cte.*,isnull(cast(cte1.ranking as varchar(5)),'null') ranking
from cte 
left join cte1 
on cte.customer_id=cte1.customer_id and cte.order_date=cte1.order_date and cte.member=cte1.member;