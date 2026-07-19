                                            --  HR Analytics project 

-- creating database named hr_analytics
create database hr_analytics;

use hr_analytics;

select * from employee_attrition;

-- counting number of rows from table employee_attrition;
select count(*)from employee_attrition; 

-- first five employees
select * from employee_attrition limit 5;

-- number of employees left the company
select attrition, count(*) 
from employee_attrition
where attrition = 'yes'
group by attrition 

-- The average age of employees who left the company
select attrition, avg(age)
from employee_attrition
where attrition = 'yes'
group by attrition

-- Department having the highest number of employees who left the company
select department, attrition, count(*) as employees_left
from employee_attrition
where attrition = 'yes'
group by department
order by employees_left desc;

-- department having the highest attrition rate
with attrition_rate as
(
  select department, attrition, count(*) as employees_left
from employee_attrition
where attrition = 'yes'
group by department
),
total_employee as
(
   select department, count(*) as total_member
   from employee_attrition
   group by department
)
select ar.department,
       ar.employees_left, 
       te.total_member,
       (ar.employees_left * 100.0 / te.total_member) as attrition_rate
from attrition_rate as ar
join total_employee as te
on ar.department = te.department
order by attrition_rate desc;

-- Jobe role having the highest attrition rate
with employee_left as
(
  select jobrole, attrition, count(*) as employees_left
  from employee_attrition
  where attrition = 'yes'
  group by jobrole
),
total_employee as
(
  select jobrole, count(*) as total_employees
  from employee_attrition
  group by jobrole
)

select el.jobrole,
	   el.employees_left,
       te.total_employees,
       (el.employees_left * 100.0 / te.total_employees) as attrition_rate
       from employee_left as el
       join total_employee as te 
       on el.jobrole = te.jobrole
       order by attrition_rate desc;

-- does monthly income affect attrition
select attrition, avg(monthlyincome) as average_monthly_income
from employee_attrition
group by attrition; 

