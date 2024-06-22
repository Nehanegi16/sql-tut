select * from order_details
select * from orders
select * from pizza_types
select * from pizzas

--Reterived the total orders places 
select  count(order_id) from orders

--calculate the revenue genrated from the pizza sales
select round(sum(p.price * od.quantity)) as Total_Revenu from pizzas as p
join order_details as od 
on p.pizza_id=od.pizza_id

--Identify the higest price pizza
select pizza_type_id,price from pizzas
where price >=(select max(price) from pizzas)
 
--comanly size order pizza
select  p.size, count(od.quantity)as total from pizzas as p
join order_details as od
on p.pizza_id=od.pizza_id
group by p.size
order by total desc


--high time or order pizza

select time as order_time,COUNT(order_id) as total_order from orders
group by order_time

--category wise distribution
select category,count(name) from pizza_types
group by category

--order by date and calculate the average number of pizza order per day
SELECT AVG(order_quantity) 
FROM (
    SELECT SUM(od.quantity) as order_quantity 
    FROM orders o 
    JOIN order_details od ON o.order_id = od.order_id 
    GROUP BY o.date
) as order_quantity;

--find top 3 order pizza based on revenu
select pizza_types.name, sum(pizzas.price * order_details.quantity) as revenu
from pizza_types 
join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by  pizza_types.name
order by revenu  desc
limit 3

--calculate the percentage contibute of each pizza type to total revenu
select pizza_types.category, 
sum(pizzas.price * order_details.quantity)/(select
sum(pizzas.price * order_details.quantity)as total_sale from order_details
join pizzas on pizzas.pizza_id=order_details.pizza_id)*100 as revenue
from pizza_types 
join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by  pizza_types.category
order by revenue  desc
limit 3

--analysis the cumulative revenue genrated over time

