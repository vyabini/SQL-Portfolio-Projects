--Spotify case study

CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

Select * from activity

--1. How many active users in a day?

Select event_date, COUNT(distinct user_id) as no_of_active_users from activity group by event_date

--2. How many active users in each week?

Select (DATEPART(week,event_date)-datepart(week,dateadd(day,1,eomonth(event_date,-1))))+1 week_of_month, 
COUNT(distinct user_id) as no_of_active_users 
from activity 
group by (DATEPART(week,event_date)-datepart(week,dateadd(day,1,eomonth(event_date,-1))))+1

-- 3. Find no of users who made installation and purchase of app in the same day. Calculate this for each date separately.

--Approach 1
Select B.*,coalesce(A.no_of_users,0) as no_of_users from
(Select event_date,COUNT(1) as no_of_users from(
Select event_date,user_id from activity group by event_date,user_id having COUNT(1)=2) A
group by event_date) A
right join 
(Select distinct event_date from activity) B
on A.event_date=B.event_date

--Approach 2
Select event_date,sum(identifier) as no_of_users from(
Select event_date,user_id,case when COUNT(1)=2 then 1 else 0 end as identifier from activity group by event_date,user_id) A
group by event_date;

--4. Percentage of paid users in India, USA and other countries
with cte as(
Select case when country in ('USA','India') then country else 'Others' end as country,COUNT(user_id) as users
from activity 
where event_name='app-purchase' 
group by country)
Select country,format(SUM(users)*100.0/(Select SUM(users) from cte),'N0') as percentage_users from cte group by country;

--5. How many users purchased the app the very next day of installation --Give day wise results

--Approach 1
with cte as(
Select user_id,event_name,event_date,LAG(event_date) over(partition by user_id order by event_date) as previous_date  
from activity where user_id in (Select user_id from activity group by user_id having COUNT(1)=2)),
cte1 as(
Select event_date,DATEDIFF(day,previous_date,event_date) as date_difference from cte where previous_date is not null)

Select B.event_date,coalesce(A.no_of_users,0) as no_of_users from
(Select event_date,COUNT(1) as no_of_users from cte1 where date_difference=1 group by event_date)as A
right join (Select distinct event_date from activity) B
on A.event_date=B.event_date

--Approach 2
with cte as(
Select user_id,event_name,event_date,lag(event_name)over(partition by user_id order by event_date) as prev_event_name,
LAG(event_date) over(partition by user_id order by event_date) as previous_date  
from activity),
cte1 as(
Select event_date,COUNT(distinct user_id) as no_of_users 
from cte 
where DATEDIFF(day,previous_date,event_date)=1 and prev_event_name='app-installed' and event_name='app-purchase'
group by event_date)
Select B.event_date,coalesce(A.no_of_users,0) as no_of_users from
(Select * from cte1)as A
right join (Select distinct event_date from activity) B
on A.event_date=B.event_date



