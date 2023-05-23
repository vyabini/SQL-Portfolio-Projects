create database portfolio_projects
Select * from athlete_events
Select * from athletes


--1 which team has won the maximum gold medals over the years.

Select top 1 a.team,count(a.team) as number_of_medals 
from athlete_events ae inner join athletes a 
on ae.athlete_id=a.id 
where ae.medal='Gold' 
group by a.team 
order by number_of_medals desc


--2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns
-- team,total_silver_medals, year_of_max_silver
with cte as(
Select a.team,ae.year,count(ae.medal) as no_of_medals,rank() over(partition by team order by count(ae.medal) desc) as rnk
from athlete_events ae inner join athletes a 
on ae.athlete_id=a.id 
where medal='Silver'
group by a.team,ae.year)
Select A.*,B.no_of_silver_medals as Total_silver_medals from 
(Select team,string_agg(year,' , ')within group (order by year) as year  
from cte 
where rnk=1 
group by team) A
inner join 
(Select a.team,COUNT(1) as no_of_silver_medals
from athlete_events ae inner join athletes a 
on ae.athlete_id=a.id 
where medal='Silver'
group by a.team) B
on A.team=B.team


--3 which player has won maximum gold medals  amongst the players 
--which have won only gold medal (never won silver or bronze) over the years

with cte as(
Select ae.athlete_id,a.name,ae.medal,count(ae.athlete_id) as no_of_medals
from athlete_events ae inner join athletes a on ae.athlete_id=a.id
where medal!='NA'
group by ae.athlete_id,a.name,ae.medal
),
cte1 as(
Select athlete_id from cte
group by athlete_id
having COUNT(athlete_id)=1)
Select top 1 cte.* from cte inner join cte1 on cte.athlete_id=cte1.athlete_id
where medal='Gold'
order by no_of_medals desc

--4 in each year which player has won maximum gold medal . Write a query to print year,player name 
--and no of golds won in that year . In case of a tie print comma separated player names.
with cte as(
Select ae.year,ae.athlete_id,a.name,ae.medal,COUNT(ae.medal) as no_of_medals,
RANK() over(partition by ae.year order by COUNT(ae.medal) desc) as rnk
from athlete_events ae 
inner join athletes a 
on ae.athlete_id=a.id
where ae.medal='Gold'
group by ae.year,ae.athlete_id,a.name,ae.medal)
Select year,string_agg(name,' , ') within group (order by name) as players_name ,no_of_medals 
from cte 
where rnk=1
group by year,no_of_medals;

--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal
--print 3 columns medal,year,sport

with cte as(
Select ae.medal,ae.year,ae.sport,ROW_NUMBER() over(partition by ae.medal order by ae.year) as rn
from athlete_events ae 
inner join athletes a 
on ae.athlete_id=a.id
where team='India' and medal!='NA')
Select medal,year,sport from cte where rn=1

--6 find players who won gold medal in summer and winter olympics both.

with cte as(
Select ae.athlete_id,ae.season,ae.medal,COUNT(ae.medal) as no_of_medals
from athlete_events ae 
inner join athletes a 
on ae.athlete_id=a.id
where medal='Gold'
group by ae.athlete_id,ae.season,ae.medal)
Select * from cte 
inner join
(Select athlete_id from cte group by athlete_id having COUNT(athlete_id)=2) as A
on cte.athlete_id=A.athlete_id


--7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.
with cte as(
Select ae.year,ae.season,ae.athlete_id,a.name,ae.medal
from athlete_events ae 
inner join athletes a 
on ae.athlete_id=a.id
where ae.medal!='NA'
group by ae.year,ae.season,ae.athlete_id,a.name,ae.medal)

Select year,season,athlete_id from cte group by year,season,athlete_id having COUNT(athlete_id)=3;



--8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.

with cte as(
Select ae.athlete_id,a.name,ae.event,ae.year,lag(ae.year) over (PARTITION by ae.athlete_id,a.name,ae.event order by ae.year) as prev_year,
ROW_NUMBER() over(PARTITION by ae.athlete_id,a.name,ae.event order by ae.year) as rn
from athlete_events ae 
inner join athletes a 
on ae.athlete_id=a.id
where year>=2000 and season='Summer' and medal='Gold'
group by ae.athlete_id,a.name,ae.event,ae.year),
cte1 as(
Select name,event,year-prev_year as year_diff from cte where rn in (2,3) group by name,event,year-prev_year having COUNT(1)=2)
Select name,event,year_diff from cte1 where year_diff=4