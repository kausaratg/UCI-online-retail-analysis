select *
from online_retail
limit 10;


-- OVERALL BUSINESS PERFORMANCE
-- total revenue
select sum(totalamount) as "Total Revenue"
from online_retail
where is_merchandise = True
and quantity >0;

-- total customers 
select count(Distinct CustomerID) as "Total Customer"
from online_retail
where is_merchandise =True
and customerId is not null
and quantity >0;

-- amount of orders
select count(Distinct invoiceNo) as "Total Orders"
from online_retail
where is_merchandise=True
and quantity >0;

-- monthly revenue
select month, sum(totalamount) as TotalRevenue
from online_retail
where is_merchandise =True
and quantity >0
group by month
order by totalrevenue desc;

-- amount of orders per month 
select month, count(distinct invoiceno) as "Order Amount"
from online_retail
where is_merchandise=True
and quantity >0
group by month
order by "Order Amount" desc;

-- Average order Value by month
select month, round(sum(TotalAmount)/count(distinct invoiceno), 2) as "Average Order Value"
from online_retail
where is_merchandise = True
and quantity >0
group by month
order by "Average Order Value" desc;


-- PRODUCT PERFORMANCE
-- top products by revenue
select  stockcode, description,  sum(totalamount) as TotalRevenue
from online_retail
where is_merchandise =True
and quantity >0
group by stockcode, description
order by totalrevenue desc
limit 10;

-- top products by quantity


-- CUSTOMER'S BEHAVIOUR
-- one time customer Vs regular customer
with customer_orders as (
select customerID, count(distinct invoiceno) as "Number of Orders", sum(totalamount) as "Total Revenue"
from online_retail
where customerid is not null and is_merchandise =True and quantity >0
group by customerID
order by count(distinct invoiceno) desc
)
select
case
when "Number of Orders" = 1 Then 'One time Customer'
else 'Repeat Customer'
end mytable,
count(*) as Customer_type, round(count(*) *100/ sum(count(*)) over(), 2) as "customers Percentage",
sum("Total Revenue") as "Revenue"
from customer_orders
group by case
when "Number of Orders" = 1 Then 'One time Customer'
else 'Repeat Customer'
end;


-- GEOGRAPHIC PERFORMANCE
-- countries with the highest revenue
select country, sum(totalamount) as "Total Revenue"
from online_retail
where is_merchandise =True
and quantity >0
group by country
order by "Total Revenue" desc;

-- countries with high order quanitity
select country, sum(quantity) as "Total Quantity"
from online_retail
where is_merchandise =True
and quantity >0
group by country
order by "Total Quantity" desc;


-- ORDER / CANCELLATION PERFORMANCE
-- how many transaction were cancelled 
select count(distinct invoiceno) as "Cancelled Transaction"
from online_retail
where invoiceno like 'C%';

-- Cancellation rate and completed rate
with orders as (
select distinct invoiceno,
case 
when invoiceno like 'C%' then 'Cancelled orders'
else 'Completed Order'
end as OrderStatus
from online_retail
)
select orderStatus, count(orderstatus) as "Order Count", 
round(count(orderstatus) *100/sum(count(*)) over(),2) as "Order Percentage"
from orders
group by orderstatus;

-- cancellation rate by month
select *
from online_retail;

select month, count(distinct case 
	when invoiceno like 'C%' then invoiceno
	end)as "Cancelled transactions",
	count(distinct invoiceno) as "total Transactions",
	round(count(distinct case 
	when invoiceno like 'C%' then invoiceno
	end) *100 /count(distinct invoiceno), 2) as percentage
	from online_retail
	group by month 
	order by month;












