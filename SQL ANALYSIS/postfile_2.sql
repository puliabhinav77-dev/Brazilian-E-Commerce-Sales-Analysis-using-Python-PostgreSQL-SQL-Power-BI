

select * from cleaned_geolocation_data;

select * from cleaned_order_items_data;

select * from cleaned_order_payments_data;

select * from cleaned_order_reviews_data;

select * from cleaned_orders_data;

select * from cleaned_products_data;

select * from cleaned_sellers_data;

-- number of customers from different cities
select * from cleaned_customers_dataset
;

select customer_state,customer_city,count(customer_unique_id) as No_of_customers from cleaned_customers_dataset
group by customer_state,customer_city
order by count(customer_unique_id) desc
;

#working on geolocation data
#this query helps in finding the customers data like city and state
select geolocation_zip_code_prefix,customer_zip_code_prefix,customer_unique_id,geolocation_city,customer_state from cleaned_geolocation_data as cg
left join cleaned_customers_dataset as cd on cg.geolocation_zip_code_prefix = cd.customer_zip_code_prefix
where geolocation_zip_code_prefix is not null and customer_zip_code_prefix is not null and
	  customer_unique_id is not null and geolocation_city is not null and customer_state is not null;

#working on orders data

select * from cleaned_order_payments_data;

select * from cleaned_order_items_data;


create view total_sales as
select cod.order_id,coi.product_id,cod.customer_id,cpd.product_category_name,cod.order_status,
coi.price,coi.freight_value, (coi.price+coi.freight_value) as total_value
from cleaned_orders_data as cod
left join cleaned_order_items_data as coi on cod.order_id = coi.order_id
left join cleaned_products_data as cpd on cpd.product_id = coi.product_id
where cod.order_status = 'delivered';

select * from total_sales;

#total sales
select sum(total_value) from total_sales;

#total sales according to the product categories
select product_category_name as category_name ,sum(total_value) as sales_in_category from total_sales
group by product_category_name
order by sales_in_category desc;

#average order value (AOV)
select round(avg(total_value),2) from total_sales;

#How does monthly revenue change over time?
select * from cleaned_orders_data;

alter table cleaned_orders_data
modify column new_order_delivered_customer_date date
;

#creating a view
create view monthly_revenue as
select cod.order_id,cpd.product_category_name,cod.order_status,
cod.new_order_delivered_customer_date as revenue_made_date,
extract(year from cod.new_order_delivered_customer_date) as yearr,
extract(month from cod.new_order_delivered_customer_date) as monthh,
(price+freight_value) as sale_made
from cleaned_orders_data as cod
left join cleaned_order_items_data as coi
on cod.order_id = coi.order_id
left join cleaned_products_data as cpd
on coi.product_id = cpd.product_id
where new_order_delivered_customer_date is not null;

#creating month wise revenue data view
create view revenue_data as
select yearr, monthh, sum(sale_made) as revenue_made_in_month from monthly_revenue
group by yearr, monthh
;

#month wise revenue data

select * from revenue_data
order by yearr asc,monthh asc;

#month with highest revenue 

select * from revenue_data
order by revenue_made_in_month desc
limit 1;

#work in sql hp laptop

#highest revenue according to category
select product_category_name, sum(sale_made) as sale from monthly_revenue
group by product_category_name
order by sum(sale_made) desc
limit 1;

#unique customers
select count(distinct customer_unique_id) as unique_customers_count from cleaned_customers_dataset
;

#highest number of customers per state

select customer_state, count(customer_unique_id) as no_of_customers from cleaned_customers_dataset
group by customer_state
order by count(customer_unique_id) desc
limit 1;

#highest number of customers per city
select customer_city, count(customer_unique_id) as no_of_customers from cleaned_customers_dataset
group by customer_city
order by count(customer_unique_id) desc
limit 1
;

# Are most customers one-time buyers or repeat buyers

select count(distinct customer_id) as single_time, count(customer_id) as repeated_buyers from cleaned_orders_data
;

#regions with highest demand according to cities

select ccd.customer_city,count(distinct cod.order_id) as order_count from cleaned_orders_data as cod
left join cleaned_customers_dataset as ccd
	on cod.customer_id = ccd.customer_id
group by ccd.customer_city
order by count(distinct cod.order_id) desc;

# product categories that are ordered most

select cpd.product_category_name,count(distinct coi.order_id) as order_count from cleaned_order_items_data as coi
left join cleaned_products_data as cpd
on coi.product_id = cpd.product_id
group by cpd.product_category_name
order by count(distinct coi.order_id) desc;

    
# categories having highest average product prize  
       
select product_category_name, round(avg(total_value),2) as average_product_prize from total_sales
group by product_category_name
order by avg(total_value) desc;

# categories having lowest average product prize

select product_category_name, round(avg(total_value),2) as average_product_prize from total_sales
group by product_category_name
order by avg(total_value) asc;

# categories with highest freight value

select product_category_name, round(max(freight_value),2) as freight_value from total_sales
group by product_category_name
order by max(freight_value) desc;

# categories have high revenue but low customer satisfaction

select ts.product_category_name,avg(cor.review_score) as avg_review_score ,sum(ts.total_value) as total_revenue from total_sales ts
left join cleaned_order_reviews_data cor
	on ts.order_id = cor.order_id
where cor.review_score is not null
group by ts.product_category_name
order by avg(cor.review_score) asc, sum(ts.total_value) desc;

# sellers generated the highest total sales

select csd.seller_id,round(sum(cod.price+cod.freight_value),2) as sales from cleaned_sellers_data csd
left join cleaned_order_items_data cod
	on csd.seller_id = cod.seller_id
group by csd.seller_id
order by sum(cod.price+cod.freight_value) desc;
 
# sellers completed the highest number of orders

select csd.seller_id,count(cod.order_id) as number_of_orders from cleaned_sellers_data csd
left join cleaned_order_items_data cod
	on csd.seller_id = cod.seller_id
group by csd.seller_id
order by count(cod.order_id) desc;

# seller states contributing the most sales

select csd.seller_state,count(cod.order_id) as number_of_orders from cleaned_sellers_data csd
left join cleaned_order_items_data cod
	on csd.seller_id = cod.seller_id
group by csd.seller_state
order by count(cod.order_id) desc;

# sellers having high sales but low review scores

select csd.seller_id, sum(total_value) sale_value,avg(cor.review_score) avg_review_score  
from total_sales ts
left join cleaned_order_items_data coi
	on ts.order_id = coi.order_id
left join cleaned_order_reviews_data cor
	on ts.order_id = cor.order_id
left join cleaned_sellers_data csd
	on csd.seller_id = coi.seller_id
group by csd.seller_id
order by sum(total_value) desc, avg(cor.review_score) asc
;

# average delivery time from purchase date to customer delivery date

alter table cleaned_orders_data
rename column estimated_delivery_date to order_estimated_delivery_date;

alter table cleaned_orders_data
modify column order_estimated_delivery_date date,
modify order_purchase_date date,
modify order_approved_date date,
modify new_order_delivered_carrier_date date,
modify new_order_delivered_customer_date date;

create view orders_data as
select order_id,customer_id,order_status,order_estimated_delivery_date as estimated_delivery,
order_purchase_date as purchase_date, order_approved_date as approved_date, new_order_delivered_carrier_date as carrier_delivered_date,
new_order_delivered_customer_date as customer_delivery_date
from cleaned_orders_data
where order_status like 'delivered';

select avg(datediff(customer_delivery_date,purchase_date)) average_delivery_time from orders_data
;

# average estimated delivery time

select avg(datediff(estimated_delivery,approved_date)) as avg_est_delivery_time from orders_data;

#  orders delivered on time and delivered late

# orders delivered on time
select * from orders_data
where datediff(customer_delivery_date,estimated_delivery) = 0 or datediff(customer_delivery_date,estimated_delivery) < 0;
# orders delivered late
select * from orders_data
where datediff(customer_delivery_date,estimated_delivery)  > 0 ;

# states having the highest late-delivery rate

select csd.seller_state,sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) > 0 then 1 else 0 end) as late_deliveries,
round(sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) > 0 then 1 else 0 end)/count(od.order_id),2) as late_delivery_rate
from cleaned_order_items_data coi
left join cleaned_sellers_data csd
	on coi.seller_id = csd.seller_id
left join orders_data od
	on coi.order_id = od.order_id
group by csd.seller_state 
;

# states with on-time deliveries

select csd.seller_state,sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) < 0 or datediff(od.customer_delivery_date,od.estimated_delivery) = 0 then 1 else 0 end) as fast_deliveries,
round(sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) < 0 or datediff(od.customer_delivery_date,od.estimated_delivery) = 0 then 1 else 0 end)/count(od.order_id),2) as fast_delivery_rate
from cleaned_order_items_data coi
left join cleaned_sellers_data csd
	on coi.seller_id = csd.seller_id
left join orders_data od
	on coi.order_id = od.order_id
group by csd.seller_state 
;

# late deliveries + on-time deliveries gives the total number of orders per state (accuracy purpose)

select csd.seller_state,count(od.order_id) as order_count
from cleaned_order_items_data coi
left join cleaned_sellers_data csd
	on coi.seller_id = csd.seller_id
left join orders_data od
	on coi.order_id = od.order_id
group by csd.seller_state 
;

# product categories face the most delivery delays

select cpd.product_category_name,sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) > 0 then 1 else 0 end) as late_deliveries 
from orders_data od
left join total_sales ts
	on od.order_id = ts.order_id
left join cleaned_products_data cpd	
	on ts.product_id = cpd.product_id
group by cpd.product_category_name
order by sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) > 0 then 1 else 0 end) desc
;

# Does late delivery reduce customer review score?

select sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) > 0 and 
cor.review_score < (select avg(review_score) from cleaned_order_reviews_data) then 1 else 0 end) 
as dl_date_and_review_for_late,
sum(case when datediff(od.customer_delivery_date,od.estimated_delivery) < 1 and 
cor.review_score < (select avg(review_score) from cleaned_order_reviews_data) then 1 else 0 end)
as dl_date_and_review_for_fast
from orders_data od
left join cleaned_order_reviews_data cor
	on od.order_id = cor.order_id;

# Is higher freight value linked with faster delivery or slower delivery

create view freight_value_fd_and_sd as
select ts.order_id,ts.product_category_name,(case when ts.freight_value > (select avg(freight_value) from total_sales ) then 'higher freight value' else 'lower freight value' end) 
as above_avg_freight_value,
(case when datediff(od.customer_delivery_date, od.estimated_delivery) < 1 then 'on time delivery' else 'late delivery' end) as end_delivery
from total_sales ts
left join cleaned_order_reviews_data cor
	on ts.order_id = cor.order_id
left join orders_data od
	on ts.order_id = od.order_id
;

select end_delivery, sum(case when above_avg_freight_value = 'higher freight value' and end_delivery = 'on time delivery' then 1 else 0 end) higher_freight_value_delivery_link,
sum(case when above_avg_freight_value = 'lower freight value' and end_delivery = 'late delivery' then 1 else 0 end) lower_freight_value_delivery_link
from freight_value_fd_and_sd
group by end_delivery;

# most commonly used payment methods

select payment_type, count(*) as count
from cleaned_order_payments_data
group by payment_type
order by count(*) desc;

# payment methods and their revenue

select payment_type, round(sum(payment_value),2) as revenue from cleaned_order_payments_data
group by payment_type;

# average payment value by payment type

select payment_type, avg(payment_value) from cleaned_order_payments_data
group by payment_type;

# most common number of payment installments

select payment_installments, count(payment_installments) from cleaned_order_payments_data
group by payment_installments
order by count(payment_installments) desc;

# Do high-value orders usually use more installments?

select * from cleaned_order_payments_data
where payment_value > (select avg(payment_value) from cleaned_order_payments_data)
order by payment_value desc;

