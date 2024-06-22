select * from departments
select * from employees
select  * from locations 
select * from  countries 
select * from grade_level
--1 From the following tables, write a SQL query to find out the full name (first and last name) of the employee 
--with an ID and the name of the country where he/she is currently employed.
 select concat(first_name,' ',last_name)as Full_Name,e.employee_id,c.country_name from employees e
 join departments d
 on e.department_id=d.department_id
 join locations l
 on d.location_id=l.location_id
 join countries c
 on l.country_id=c.country_id
 order by e.employee_id
 
-- OR

SELECT first_name || ' ' || last_name AS Employee_name, employee_id, country_name 
FROM employees 
JOIN departments USING(department_id) 
JOIN locations USING(location_id) 
JOIN countries USING(country_id);

--2  From the following tables, write a SQL query to find the department 
--name, department ID, and number of employees in each department.
 select d.department_name,d.department_id,count(employee_id)as total_employee from employees e
 join departments d
 on e.department_id=d.department_id
 group by d.department_id
 
 --3. From the following table, write a SQL query to find 
 --the first name, last name, salary, and job grade for all employees.
 select e.first_name,e.last_name,e.salary,g.grade_level from employees e
 join grade_level g
 on e.salary between g.lowest_sal and g.highest_sal
 
 --4. From the following tables, write a SQL query to find all those employees who work in 
--department ID 80 or 40. Return first name, last name, department number and department name.
select e.first_name,e.last_name,e.department_id,d.department_name from employees e
join departments d
on e.department_id=d.department_id
and e.department_id in(30,20)

--5 From the following tables, write a SQL query to find those employees whose first name contains the letter ‘z’. 
--Return first name, last name, department, city, and state province.
select e.first_name,e.last_name,d.department_name,l.city,l.state_province from employees e
join departments d  on e.department_id=d.department_id
join locations l on d.location_id=l.location_id
where e.first_name like '%z%'

--6. From the following tables, write a SQL query to find the department name, 
--department ID, and number of employees in each department.
select d.department_name,d.department_id,count(e.employee_id)as number_of_employee from departments d
join employees e
on d.department_id=e.department_id
group by d.department_name,d.department_id

--7. From the following tables, write a SQL query to find full name (first and last name), 
--job title, start and end date of last jobs of employees who did not receive commissions.
select concat(first_name,'',last_name) as Full_Name ,job_id,max(start_date),max(end_date) from employees
where commission_pct is not null