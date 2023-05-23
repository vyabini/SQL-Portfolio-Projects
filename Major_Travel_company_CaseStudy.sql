
CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');

Select * from booking_table
Select * from user_table

--1. Write an sql query that gives the below output
--Output summary of segment table

/*
Segement	Tot_user_count	User_who_booked_flight_in_apr2022
s1				3						2
s2				2						2
s3				5						1
*/


--Approach1
Select A.*, B.User_who_booked_flight_in_apr2022 from 
(
Select Segment, count(distinct user_id) as Tot_user_count 
from user_table 
group by Segment) A

inner join

(
Select  ut.Segment,count( distinct bt.User_id) as User_who_booked_flight_in_apr2022
from user_table ut 
inner join booking_table bt on bt.User_id=ut.User_id 
where DATEPART(month,booking_date)=4 and Line_of_business='Flight'
group by ut.Segment) B

on A.Segment=B.Segment

--Approach2
Select ut.Segment, count(distinct ut.user_id) as Tot_user_count,
count(distinct case when DATEPART(month,booking_date)=4 and Line_of_business='Flight' then bt.User_id end) as User_who_booked_flight_in_apr2022
from user_table ut left join booking_table bt on bt.User_id=ut.User_id 
group by ut.Segment;


--2. Write a query to identify users whose first booking was a hotel booking

--Approach 1
with cte as(
Select Booking_id,Booking_date,User_id,Line_of_business,
ROW_NUMBER() over(partition by user_id order by booking_date) as rn
from booking_table)

Select User_id,Line_of_business from cte where rn = 1 and Line_of_business='Hotel'

--Approach2
with cte as(
Select Booking_id,Booking_date,User_id,Line_of_business,
first_value(Line_of_business) over(partition by user_id order by booking_date) as first_booking_of_user
from booking_table)
Select distinct User_id,first_booking_of_user from cte where first_booking_of_user='Hotel'


--3. Write a query to calculate the days between first and last booking of each user

--Select * from booking_table order by User_id,Booking_date

with cte as(
Select user_id,min(booking_date) as first_booking_of_user,
max(booking_date) as last_booking_of_user
from booking_table group by User_id)
Select User_id,DATEDIFF(day,first_booking_of_user,last_booking_of_user) as days_btw_fist_and_last_booking from cte

--4. Write a query to count the number of flight and hotel bookings in each of the user segements for the year 2022

Select ut.Segment,count(case when bt.Line_of_business='Flight' then bt.Line_of_business end) as Flight_bookings,
count(case when bt.Line_of_business='Hotel' then bt.Line_of_business end) as Flight_bookings
from booking_table bt 
inner join user_table ut
on bt.User_id=ut.User_id
where DATEPART(year,booking_date)=2022
group by Segment