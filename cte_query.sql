CREATE TABLE supporter (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE project (
    id INT PRIMARY KEY,
    category VARCHAR(50),
    author_id INT,
    minimal_amount DECIMAL(10, 2),
    FOREIGN KEY (author_id) REFERENCES supporter(id)
);
CREATE TABLE donation (
    id INT PRIMARY KEY,
    project_id INT,
    supporter_id INT,
    amount DECIMAL(10, 2),
    donated DATE,
    FOREIGN KEY (project_id) REFERENCES project(id)
);


INSERT INTO supporter (id, first_name, last_name) VALUES
(1, 'Marlene', 'Wagner'),
(2, 'Lonnie', 'Goodwin'),
(3, 'Sophie', 'Peters'),
(4, 'Edwin', 'Paul'),
(5, 'Hugh', 'Thornton');

INSERT INTO project (id, category, author_id, minimal_amount) VALUES
(1, 'music', 1, 1677),
(2, 'music', 5, 21573),
(3, 'traveling', 2, 4952),
(4, 'traveling', 5, 3135),
(5, 'traveling', 2, 8555);

INSERT INTO donation (id, project_id, supporter_id, amount, donated) VALUES
(1, 4, 4, 928.40, '2016-09-07'),  
(2, 2, 18, 384.38, '2016-12-16'),
(3, 3, 12, 367.21, '2016-01-21'),
(4, 2, 19, 108.62, '2016-12-29'), 
(5, 1, 20, 842.58, '2016-11-30'); 

select * from donation 
select * from supporter
select * from project


--Using a CTE to Get Totalized Data
--Obtain the project ID, minimal amount, and total donations for 
--projects that have received donations over the minimum amount.
 
with  revenue as
(
	select project_id,sum(amount) as sum_amount
	from donation
	group by project_id
	
)
select project.id,sum_amount
from revenue
inner join project 
on project.id=revenue.project_id
where sum_amount>=minimal_amount


WITH project_revenue AS (
  SELECT
    project_id,
    SUM(amount) AS sum_amount
  FROM donation
  GROUP BY project_id
)
SELECT project.id, minimal_amount, sum_amount
FROM project_revenue
INNER JOIN project ON
project.id = project_revenue.project_id
WHERE sum_amount <= minimal_amount;

--Retrieve total donations and the corresponding donation IDs using a CTE
with total as 
(
	select id,amount as total_donations
	from donation
)
select * from total

--Use a CTE to find donations greater than $500.
with greater as
(
	select * from donation 
	where amount>500
)
select * from  greater 

--Create a CTE to list all projects with a minimal amount less than $500.
select * from project

with minimal_amy as
(
	select category ,sum(minimal_amount)
	from project
	where minimal_amount < 50000
	group by category
	
)
select * from minimal_amy

--Create a CTE to list donations along with their project IDs if available.
with pt as 
(
	select d.amount,p.id as project_id
	from donation d
	join project p
	on d.id=p.id
)
select * from pt

--Create a CTE to find the number of projects with a minimal 
-- amount less than the average donation amount.
with find as
( 
	select avg(amount) as avg_amount
	from donation d
), result as
	(
		select count(*) as count_of_project
		from project p
		where p.minimal_amount >(select avg_amount from find)
	)

select * from result

--Use a CTE to list donations along with their rank based on amount in descending order.
with rank_amt as
(
	
	select project_id,amount,
	Rank() Over(order by amount desc) as total_re
	from donation
)
select * from rank_amt

--Intermidiate level query
--1. Total Donations by Each Supporter
with t_donation as 
(
	select supporter_id, sum(amount) as total_amt from donation
	group by supporter_id
)
select s.first_name,s.last_name,td.total_amt
from t_donation td
join supporter s
on s.id=td.supporter_id

--2. List all projects along with their authors' first and last names.
select * from supporter
select * from project

with find as
( 
	select p.author_id ,p.category,s.first_name,s.last_name from project p
	join supporter s
	on  p.author_id=s.id
)
select * from find

---3. Calculate the total donations received for each project category.
WITH category_donations AS (
    SELECT p.category, SUM(d.amount) AS total_donations
    FROM project p
    JOIN donation d ON p.id = d.project_id
    GROUP BY p.category
)
SELECT * FROM category_donations;

--4. Find the average donation amount for each project.
with avg_don as
(
	select id ,category from project 
)
select p.category,avg(amount)as total 
from avg_don p
join donation d
on p.id=d.project_id 
group by p.category

--5. List supporters who have donated more than a specific amount in total.
select * from supporter
select * from donation

with more_amt as
(
	select supporter_id,amount from  donation
	where amount >=15000
)
select s.first_name,s.last_name,am.amount from more_amt am
join supporter s
on s.id=am.supporter_id




---update multipal row on one go
select * from donation
UPDATE donation
SET amount = CASE
    WHEN id = 1 THEN 10000
    WHEN id = 2 THEN 30000
    WHEN id = 3 THEN 55000
    WHEN id = 4 THEN 28000
    WHEN id = 5 THEN 42000
END
WHERE id IN (1, 2, 3, 4, 5);

--6. Find all projects that have received at least one donation.
WITH projects_with_donations AS (
    SELECT DISTINCT project_id
    FROM donation
)
SELECT p.*
FROM project p
JOIN projects_with_donations pd ON p.id = pd.project_id;

--7 Calculate the total amount of donations made each month.

select * from donation

with total_amt as
(
	select sum(amount) as Total_amount,date_trunc('month',donated) as Data_of_date from donation 
	group by Data_of_date	
)
select * from total_amt 


--9 Identify projects that need more funding, i.e., projects
-- whose total donations are less than the minimal amount needed.

with  project_fun as 
( 
	select project_id,cast(avg(amount)as int)as Total_amt from  donation 
	group by  project_id
)
select p.id,p.category,pf.Total_amt 
from project_fun pf
join project p
on p.id=pf.project_id
where p.minimal_amount <pf.Total_amt


WITH funding_status AS (
    SELECT p.id AS project_id, p.minimal_amount, COALESCE(SUM(d.amount), 0) AS total_donated
    FROM project p
    LEFT JOIN donation d ON p.id = d.project_id
    GROUP BY p.id, p.minimal_amount
)
SELECT fs.project_id, fs.minimal_amount, fs.total_donated, (fs.minimal_amount - fs.total_donated) AS amount_needed
FROM funding_status fs
WHERE (fs.minimal_amount - fs.total_donated) > 0;

--10 . Find the top 3 projects by total donations received.
with total_donation as 
(
	select project_id,sum(amount)as tsum from donation
	group by project_id
)
select p.id,p.category,td.tsum from total_donation td
join project p
on p.id=td.project_id
order by td.tsum desc
limit 3

WITH project_donations AS (
    SELECT project_id, SUM(amount) AS total_donations
    FROM donation
    GROUP BY project_id
)
SELECT pd.project_id, p.category, pd.total_donations
FROM project_donations pd
JOIN project p ON pd.project_id = p.id
ORDER BY pd.total_donations DESC
LIMIT 3;

--11. List supporters and the count of donations they have made.
select * from supporter
select * from donation 

with count_don as 
(
	select supporter_id,sum(amount) as t_amt from donation
	group by  supporter_id
)
select s.id,s.first_name,s.last_name,cd.t_amt
from count_don cd
join supporter s
on s.id=cd.supporter_id

WITH supporter_donation_count AS (
    SELECT supporter_id, COUNT(*) AS donation_count
    FROM donation
    GROUP BY supporter_id
)
SELECT s.first_name, s.last_name, sdc.donation_count
FROM supporter_donation_count sdc
JOIN supporter s ON s.id = sdc.supporter_id;

--Hard Queries
--14. CTEs with Aggregation: Average Donation Amount by Employee
--Question: Write a query to calculate the average donation amount made by each employee.
select * from donation
select * from supporter

WITH employee_donations AS (
    SELECT
        e.id AS employee_id,
        e.first_name,
        e.last_name,
        AVG(d.amount) AS average_donation
    FROM
        employees e
    JOIN
        donation d ON e.id = d.supporter_id
    GROUP BY
        e.id, e.first_name, e.last_name
)
SELECT
    employee_id,
    first_name,
    last_name,
    average_donation
FROM
    employee_donations
ORDER BY
    average_donation DESC;
	
--13. Conditional Aggregation: Donations by Category
--Question: Write a query to calculate the total donations received by each project category.

with t_don as 
(
	select project_id,amount from donation
)
select p.category,sum(td.amount) from project p
join t_don td
on p.id=td.project_id
group by  p.category

--12. Nested Subqueries: Most Frequent Donation Days
--Question: Write a query to find the day of the week on which the highest number of donations are made.

with f_day as
(
	select extract(dow from donated)as date_week,avg(amount)as amount
	from donation
	group by date_week
	
)
select d2.date_week,d2.amount from donation d1,f_day d2
where d1.amount >d2.amount
order by d2.amount desc

SELECT
    EXTRACT(DOW FROM donated) AS day_of_week,
    COUNT(*) AS donation_count
FROM
    donation
GROUP BY
    day_of_week
ORDER BY
    donation_count DESC
LIMIT 1;

--11. Correlated Subqueries: Identify Projects with Unique Donors
--Question: Write a query to find projects that have received donations from only one unique supporter.
 

select * from project