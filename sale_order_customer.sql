select * from customer
select * from orders
select * from salesman

--1. From the following tables, write a SQL query to find all the orders issued by the salesman 'Paul 
--Adam'. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.

select * from orders
where salesman_id=(select salesman_id from salesman where name ='Paul Adam')

--2. From the following tables write a SQL query to find all orders generated by London-based salespeople.
--Return ord_no, purch_amt, ord_date, customer_id, salesman_id.

select * from orders
where salesman_id=(select salesman_id from salesman where city='London')

--3. From the following tables write a SQL query to find all orders generated by the salespeople who may work for customers whose id is 3007.
--Return ord_no, purch_amt, ord_date, customer_id, salesman_id.


select * from orders
where salesman_id in (select salesman_id from customer where customer_id=3007)

--4. From the following tables write a SQL query to find the order values greater than the average order value of 10th October 2012.
--Return ord_no, purch_amt, ord_date, customer_id, salesman_id.
select * from orders 
where purch_amt >(select avg(purch_amt) from orders where ord_date='10/10/2012')

--5. From the following tables, write a SQL query to find all the orders generated in New York city. 
--Return ord_no, purch_amt, ord_date, customer_id and salesman_id.

select * from orders
where  salesman_id IN (select salesman_id from customer where city='New York')

--6. From the following tables write a SQL query to 
--determine the commission of the salespeople in Paris. Return commission.
select commission from  salesman
where salesman_id in (select salesman_id from customer where city='Paris')

--7. Write a query to display all the customers 
--whose ID is 2001 below the salesperson ID of Mc Lyon.

select * from customer
where customer_id=(select salesman_id-2001 from salesman
				   where name='Mc Lyon')
				   
--8. From the following tables write a SQL query to count the number of customers 
--with grades above the average in New York City. Return grade and count. 

select  grade,count(*) from customer
group by grade
having  grade >=(select avg(grade) from customer where city='New York')

--9. From the following tables, write a SQL query to find those salespeople who earned 
--the maximum commission. Return ord_no, purch_amt, ord_date, and salesman_id.

select * from orders
where salesman_id IN (select salesman_id from salesman 
				   where commission=(select max(commission) from salesman))


--10. From the following tables write SQL query to find the customers who placed orders on 
--17th August 2012. Return ord_no, purch_amt, ord_date, customer_id, salesman_id and cust_name.

select od.* ,cust.cust_name from orders od
join customer cust on od.customer_id=cust.customer_id
where ord_date='8/17/2012'


--11. From the following tables write a SQL query to find salespeople 
--who had more than one customer. Return salesman_id and name.

SELECT salesman_id, name 
FROM salesman a 
WHERE 1 < 
    (SELECT COUNT(*) 
     FROM customer 
     WHERE salesman_id = a.salesman_id);
	 
--12. From the following tables write a SQL query to find those orders,
--which are higher than the average amount of the orders.
--Return ord_no, purch_amt, ord_date, customer_id and salesman_id.

select * from orders a
where purch_amt< (select avg(purch_amt) from  orders b
				   where a.customer_id=b.customer_id)
				   
				   
				   
--13 From the following tables write a SQL query to find those orders that are equal or higher than the average amount 
--of the orders. Return ord_no, purch_amt, ord_date, customer_id and salesman_id.

select * from orders a
where purch_amt>=(select avg(purch_amt) from orders b
				  where a.customer_id=b.customer_id )

--14 Write a query to find the sums of the amounts from the orders table, grouped by date, and eliminate all dates where the sum 
--was not at least 1000.00 above the maximum order amount for that date.
 select  sum(purch_amt) as total ,ord_date from orders a 
 group by ord_date
 having sum(purch_amt)>(select 1000+max(purch_amt) from orders b
						 where a.ord_date= b.ord_date)

--15 15. Write a query to extract all data from the customer table if and only if one or more of the
-- customers in the customer table are located in London. Sample table : Customer
select * from  customer (select cust_name from customer 
			    where city='London')
				

SELECT CAST(AVG(grade) AS DECIMAL(10, 1)) FROM customer;
select cust_name,grade from  customer  c1
where exists (select avg(grade) from customer c2
			 where c1.grade=c2.grade)
			 
			
--16. From the following tables write a SQL query to find salespeople who deal
-- with multiple customers. Return salesman_id, name, city and commission.


SELECT * 
FROM salesman 
WHERE salesman_id IN (
   SELECT DISTINCT salesman_id 
   FROM customer a 
   WHERE EXISTS (
      SELECT * 
      FROM customer b 
      WHERE b.salesman_id = a.salesman_id 
      AND b.cust_name <> a.cust_name
   )
);

 select * from customer a
 join customer b
 on a.customer_id=b.customer_id
 where b.cust_name <> a.cust_name
 

--17. From the following tables write a SQL query to
-- find salespeople who deal with a single customer. Return salesman_id, name, city and commission.

select * from salesman
where  salesman_id IN (select  distinct salesman_id from customer a
					   where NOT EXISTS(select * from customer b
									    where a.salesman_id=b.salesman_id
									    and a.cust_name<>b.cust_name))
 
-- 18. From the following tables, write a SQL query to find the salespeople who deal the customers 
--with more than one order. Return salesman_id, name, city and commission
SELECT * 
FROM salesman a 
WHERE EXISTS     
   (SELECT * FROM customer b ,salesman a  
    WHERE a.salesman_id = b.salesman_id     
	 AND  <             
	     (SELECT COUNT (*)              
		  FROM orders         
		  WHERE orders.customer_id = b.customer_id)
   );
   
   
      select * from orders a
   where EXISTS (select * from orders b
				 where a.customer_id=b.customer_id
				and 500 <(select avg(purch_amt) from orders))