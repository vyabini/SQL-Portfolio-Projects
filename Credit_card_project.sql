Select * from credit_card_transactions;

--1. top 5 cities with more credit card transactions for each gender
Select city,gender,amount from (
Select city,gender,sum(amount) amount,RANK() over(partition by gender order by sum(amount) desc) rn 
from credit_card_transactions 
where DATEPART(year,date)=2014 
group by city,gender)A where rn<=5

--Insights
/* 
In both cases(gender), mumbau,bengaluru,delhi and ahmedabad is the highest in credit card value transactions

*/

--2. Gender wise exp_type split up
Select gender,exp_type,sum(amount) amount,RANK() over(partition by gender order by sum(amount) desc) rn 
from credit_card_transactions 
where DATEPART(year,date)=2014
group by gender,exp_type



--3. Expense type for which Credit card transactions is used most
Select B.exp_type,B.amount,A.*,format((amount/tot_amount),'N2') grand_tot_percent from
(Select SUM(amount) tot_amount from credit_card_transactions where DATEPART(year,date)=2014) A
cross join
(Select exp_type,sum(amount) amount,RANK() over( order by sum(amount) desc) rn 
from credit_card_transactions 
where DATEPART(year,date)=2014
group by exp_type)B order by grand_tot_percent desc

/*
Of total value transactions in 2014, 22% is for Bill amounts. Only 3% used for travel expenses

*/

--4. top 10 cities with highest value transactions for each gender and their exp_type
with cte as(
Select  city,gender,exp_type,amount,SUM(amount) over(partition by city) amount_by_city from (
Select city,gender,exp_type,SUM(amount) amount,RANK() over(partition by city,gender order by SUM(amount) desc) rn 
from credit_card_transactions 
group by city,gender,exp_type) A where rn=1)
Select city,gender,exp_type,amount from (
Select *,dense_RANK() over (order by amount_by_city desc) dn from cte) C where dn<=10

/*
Female are spending more than males in each cities. In the top 10 data, more spoend is for bills and then fuels irrespective of gender */


--5. month wise usage of credit cards
Select *,amount-previous_mon_trans diff_trans from(
Select DATEPART(year,date) year_trans,DATEPART(month,date) month_trans, SUM(amount) amount,
LAG(SUM(amount),1) over(order by DATEPART(year,date),DATEPART(month,date)) previous_mon_trans
from credit_card_transactions 
group by DATEPART(year,date),DATEPART(month,date)) A order by year_trans,month_trans

-- There is no continous upward/downward slope in usage. Fall and rise in value shows its random and not growing or falling continuously over a period of time.

---6. Gender,card_type_amount relationship

Select gender,COUNT(gender) from credit_card_transactions group by gender


Select gender,card_type,SUM(amount) amount from credit_card_transactions group by gender,card_type order by gender,amount desc

Select gender,card_type,COUNT(card_type) count_of_cardtype from credit_card_transactions group by gender,card_type order by gender,count_of_cardtype desc


--Both by volume and value female are the highest with credit card transactions. Female used silver cards for transactions more and less platinum comparatively.
--Male used platinum more. However, it is lower then female platinum usage count.


--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends

Select top 5 B.*,A.*,format(amount/tot_amount*100,'N2') as overall_percent_contribution from
(Select SUM(amount) tot_amount from credit_card_transactions) A
cross join
(Select city,sum(amount) amount
from credit_card_transactions 
group by city)B  order by amount desc

--Clear cache
DBCC DROPCLEANBUFFERS 
DBCC FREEPROCCACHE;
--2- write a query to print highest spend month and amount spent in that month for each card type

with cte as(
Select card_type,DATEPART(month,date) as month_trans,DATEPART(month,date) as month_trans,SUM(amount) amount 
from credit_card_transactions 
group by DATEPART(month,date)),
cte1 as(
Select month_trans from cte where amount= (Select  max(amount) from cte))
Select DATEPART(month,date) as month_trans,card_type,sum(amount) amount 
from credit_card_transactions
where DATEPART(month,date)= (Select * from cte1)
group by DATEPART(month,date),card_type;

--3- write a query to print the transaction details(all columns from the table) for each card type when
--it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

With cte as(
Select *,sum(amount) over(partition by card_type order by date,s_no) as cumulative_sum 
from credit_card_transactions),
cte1 as(
Select *,ROW_NUMBER() over (partition by card_type order by cumulative_sum) rn from cte where cumulative_sum >=1000000)
Select * from cte1 where rn=1;

--4- write a query to find city which had lowest percentage spend for gold card type
With cte as(
Select B.*,A.*,Format(B.amount/A.tot_spend*100,'N4') as percent_spend from
(Select sum(amount) as tot_spend from credit_card_transactions where card_type='Gold' group by card_type) A cross join
(Select city,card_type,SUM(amount) as amount 
from credit_card_transactions 
where card_type='Gold'
group by city,card_type) B)
Select * from cte where percent_spend=(Select MIN(percent_spend) from cte)

--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with cte as(
Select city,exp_type,SUM(amount) as amount,
RANK() over (partition by city order by SUM(amount) desc) rnh,
RANK() over (partition by city order by SUM(amount) asc) rnl
from credit_card_transactions 
group by city,exp_type)
Select city,max(case when rnh=1 then exp_type end) as highest_expense_type, 
max(case when rnl=1 then exp_type end) as lowest_expense_type from cte where (rnh =1 or rnl=1)  group by city;

--6- write a query to find percentage contribution of spends by females for each expense type
Select D.exp_type,E.amount,D.tot_amount,format(E.amount/D.tot_amount*100,'N2') as percent_contribution from 
(Select exp_type,SUM(amount) as tot_amount 
from credit_card_transactions 
group by exp_type ) D inner join 

(Select exp_type,gender,SUM(amount) as amount 
from credit_card_transactions 
where gender='F' 
group by exp_type,gender) E 

on D.exp_type=E.exp_type 
order by percent_contribution desc ;

--7- which card and expense type combination saw highest month over month growth in Jan-2014
with cte as(
Select card_type,exp_type,datepart(year,date) as year_trans, datepart(month,date) as month_trans,sum(amount) as amount,
LAG(sum(amount),1) over (partition by card_type,exp_type order by datepart(year,date), datepart(month,date)) as prev_month_trans
from credit_card_transactions 
group by card_type,exp_type,datepart(year,date), datepart(month,date)
),
cte1 as(
Select *,amount-prev_month_trans mom_growth from cte where year_trans=2014 and month_trans=1)
Select * from cte1 where mom_growth=(Select MAX(mom_growth) from cte1)

--9- During weekends which city has highest total spend to total no of transcations ratio 
with cte as(
Select *,amount/total_transactions as avg_spend_per_transactions from 
(Select city,SUM(amount) as amount from credit_card_transactions where DATEPART(weekday,date) in (1,7) group by city) A cross join
(Select COUNT(1) total_transactions from credit_card_transactions) B)
Select * from cte where avg_spend_per_transactions=(Select MAX(avg_spend_per_transactions) from cte);

--10 - which city took least number of days to reach its 500th transaction after first transaction in that city
with cte as(
Select city,date,ROW_NUMBER() over (partition by city order by date asc) rn
from credit_card_transactions
where city in (Select city from credit_card_transactions group by city having COUNT(city)>=500) ),
cte1 as(
Select city,max(case when rn=1 then date end) as first_trans,max(case when rn=500 then date end) as five_hundredth_trans 
from cte 
where rn in (1,500)
group by city) ,
cte2 as(
Select *,DATEDIFF(day,first_trans,five_hundredth_trans) as date_difference from cte1)
Select * from cte2 where date_difference=(Select MIN(date_difference) from cte2)

id   item price start_date  end_date101  abc  100   2020-10-01  9999-12-31101  abc  110   2021-05-01  null101  abc  120   2022-06-01  null============================================= part_tabid   item price start_date  ex_rate currency 101  abc  100   2020-10-01  11.2     IND			==UPDATE101  abc  110   2021-05-01  21.5     USD			==UPDATE101  abc  120   2022-06-01  20.5     EURex_ratecurrency    ex_rateIND  		11.9USD			21.8EUR			20.5