USE P1;

# E-Commerce customer retention and Cohort Analysis

# Step-1 (Data Cleaning)

select * from d3.ecommerce_customer_behavior_dataset
where Customer_ID is not null;

# Step-2 (Find First Purchase Date)

select Customer_ID, Min(Order_Date) as First_Purchase
from d3.ecommerce_customer_behavior_dataset
group by Customer_ID ;

#Step-3 (Create Cohort Month- First purchase into Months)

update d3.ecommerce_customer_behavior_dataset
set Order_date = str_to_date(Order_date,'%d-%m-%Y'); #text to date convertion

SELECT DATE_FORMAT(Order_Date, '%y-%m') AS year_month_
FROM d3.ecommerce_customer_behavior_dataset;


# Full Structure

With First_Purchase as (
 select 
 Customer_ID, Min(Order_Date) as First_Purchase_Date from d3.ecommerce_customer_behavior_dataset
group by Customer_ID 
),
Cohort_Data as (
select o.Customer_ID, Date_Format(fp.First_Purchase_Date ,'%Y-%m') as cohort_month
,

(
year(o.Order_Date) - year(fp.first_purchase_date)
)*12
+
(
month(o.Order_date) - month(fp.first_purchase_date)
) as retention_month

from d3.ecommerce_customer_behavior_dataset o
join First_Purchase fp
on o.customer_ID = fp.customer_id
)
select cohort_month,
retention_month,
count(DISTINCT customer_ID ) as customers
from cohort_data
group by cohort_month,retention_month
order by cohort_month,retention_month;