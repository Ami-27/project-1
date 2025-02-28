create database spending_habits ;
select * from spending_patterns_detailed;
describe spending_patterns_detailed;
alter table spending_patterns_detailed change column `Customer ID` C_ID TEXT;
alter table spending_patterns_detailed change column `Price Per Unit` price_p_u INT;
alter table spending_patterns_detailed change column `Total Spent` total_spent INT;
alter table spending_patterns_detailed change column `Payment Method` Payment_Method text;
alter table spending_patterns_detailed change column `Transaction Date` Transaction_date DATE;


# count of customers
select count(C_ID) FROM spending_patterns_detailed;
# categories
select category from spending_patterns_detailed;
# count of customers as per payment methods
select payment_method , count(c_id) total from spending_patterns_detailed group by 1;
# total spent as per location 
select location, sum(Total_Spent) total from spending_patterns_detailed group by 1;
# total spent 
select sum(total_spent) from spending_patterns_detailed;


# percentage of payment methods as per customers
SELECT payment_method,percentage_of_total
from(
    select payment_method, 
    COUNT(c_id) AS total,
    ROUND((COUNT(c_id) * 100.0 / SUM(COUNT(c_id)) OVER ()), 2) AS percentage_of_total
FROM spending_patterns_detailed 
GROUP BY payment_method ) abc;

#percentage of total amount spent as per location  
select location,location_percent from
(select 
	location ,
	count(total_spent) as total,
	round((count(total_spent)*100.0 / sum(count(total_spent)) over ()), 2) as location_percent
	from spending_patterns_detailed
group by Location) abc ;


# quantities purchased per category 
SELECT 
    category, SUM(Quantity) qty
FROM
    spending_patterns_detailed
GROUP BY 1;

# yearly total
SELECT 
    category, 
    YEAR(transaction_date) AS yr, 
    COUNT(c_id) OVER (PARTITION BY YEAR(transaction_date)) AS count_by_year
FROM 
    spending_patterns_detailed;
    
# customers per category 
    SELECT 
    category, 
    YEAR(transaction_date) AS yr, 
    COUNT(c_id) AS count_by_year
FROM 
    spending_patterns_detailed
GROUP BY 
    category, YEAR(transaction_date);
    
# total spent per month 
select mth,percent_spent 
from(select
monthname(transaction_date) mth ,
month(transaction_date) mno, 
sum(total_spent) spent,
round(count(total_spent)*100/sum(count(total_spent)) over (),1) as percent_spent
 from spending_patterns_detailed group by 1,2)abc 
 order by mno ;
 

