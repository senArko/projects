use employees;

/*
Change the “Business Analysis” department name to “Data Analysis”.
*/

-- Update statement

select * from departments;

update departments 
set dept_name = "Customer Support"
where dept_no = "d009";

-- Delete statement

insert into departments values("d010", "Business Analyst");

delete from departments 
where dept_no = "d010";

select * from departments;


-- Count

/*
How many departments are there in the “employees” database? Use the ‘dept_emp’ table to answer the question.
*/

select * from dept_emp;

select count(distinct dept_no) as total_departments
from dept_emp;


-- Sum

select * from salaries;

/*
What is the total amount of money spent on salaries for all contracts starting after the 1st of January 1997?
*/

select sum(salary) as total_salary from salaries
where from_date > "1997-01-01";


-- Min and Max

/*
1. Which is the lowest employee number in the database?

2. Which is the highest employee number in the database?
*/

select * from employees;

select max(emp_no) from employees;

select min(emp_no) from employees;


-- Ifnull , Coalesce

create table dept_dup select * from departments;

ALTER TABLE dept_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL; 

INSERT INTO dept_dup(dept_no) VALUES ('d010'), ('d011');

ALTER TABLE employees.dept_dup
ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;


select * from dept_dup;

commit;

SELECT
*
FROM
dept_dup
ORDER BY dept_no ASC; 

select dept_no, ifnull(dept_name, "Department name not provided") as dept_name from dept_dup;

select * from dept_dup;

select dept_no, dept_name, coalesce(dept_manager, dept_name, "N/A") as dept_manager
from dept_dup;

select dept_no, dept_name, coalesce("department manager name") as fak_col
from dept_dup;

/*
Select the department number and name from the ‘departments_dup’ table and add a third column where you name the department number (‘dept_no’) as ‘dept_info’. 
If ‘dept_no’ does not have a value, use ‘dept_name’.
*/

select dept_no, dept_name, coalesce(dept_no, dept_name) as dept_info
from dept_dup;

/*
Modify the code obtained from the previous exercise in the following way. Apply the IFNULL() function to the values from the first and second column, 
so that ‘N/A’ is displayed whenever a department number has no value, and ‘Department name not provided’ 
is shown if there is no value for ‘dept_name’.
*/

select  ifnull(dept_no, "N/A") as dept_no, ifnull(dept_name, "Department name not provided") as dept_name,
coalesce(dept_no, dept_name) as dept_info
from dept_dup;

select * from dept_dup;

-- Joins

/*
If you currently have the ‘departments_dup’ table set up, use DROP COLUMN to remove the ‘dept_manager’ column from the ‘departments_dup’ table.

Then, use CHANGE COLUMN to change the ‘dept_no’ and ‘dept_name’ columns to NULL.
*/

alter table dept_dup drop column dept_manager;

select * from dept_dup;

alter table dept_dup modify column dept_no varchar(20) null;
alter table dept_dup modify column dept_name varchar(20) null;

describe dept_dup;


-- Joins

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (

  emp_no int NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );
  
  INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');
                               

DELETE FROM dept_manager_dup

WHERE

    dept_no = 'd001';
    

select * from dept_manager;

SELECT 
    e.emp_no, e.first_name, e.last_name, dm.dept_no, e.hire_date
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no;
    
    
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    dm.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY dm.dept_no DESC , e.emp_no;



/*
Extract a list containing information about all managers’ employee number, first and last name, department number, 
and hire date. Use the old type of join syntax to obtain the result.
*/

select e.emp_no, e.first_name, e.last_name, dm. dept_no, e.hire_date
from employees e,
dept_manager dm
where e.emp_no = dm.emp_no;


/*
Select the first and last name, the hire date, and the job title of all employees whose first name is “Margareta” and have the last name “Markovitch”.
*/

select * from titles;

SELECT 
    e.first_name, e.last_name, e.hire_date, t.title AS job_title
FROM
    employees e
        JOIN
    titles t
WHERE
    e.emp_no = t.emp_no;
    
    
/*
Use a CROSS JOIN to return a list with all possible combinations between managers from the dept_manager table and department number 9.
*/

SELECT 
    dm.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
WHERE
    d.dept_no = 'd009'
ORDER BY d.dept_no;


/*
Return a list with the first 10 employees with all the departments they can be assigned to.
*/

SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;


select * from dept_manager;

/*
Select all managers’ first and last name, hire date, job title, start date, and department name.
*/

SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    dm.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
        JOIN
    dept_manager dm ON t.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;


select * from employees;


/*
How many male and how many female managers do we have in the ‘employees’ database?
*/

SELECT 
    e.gender, COUNT(dm.emp_no) AS total_employees
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY e.gender;


-- Subquery

/*
Select the entire information for all employees whose job title is “Assistant Engineer”. 
*/


select * from employees e
where exists
(select * from titles t 
where t.emp_no = e.emp_no
and title  = "Assistant Engineer");


Select * from employees where emp_no in
(select emp_no from titles
where title = "Assistant Engineer");


DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (

   emp_no INT(11) NOT NULL,

   dept_no CHAR(4) NULL,

   manager_no INT(11) NOT NULL

);

-- Views

/*
Create a view that will extract the average salary of all managers registered in the database. Round this value to the nearest cent.
*/

create view manager_avg_salary as(
select round(avg(salary),2)
from salaries s
join dept_manager dm on s.emp_no = dm.emp_no
);

select * from manager_avg_salary;


-- Stored routines
use employees;
DELIMITER $$
create procedure emp_1000()
Begin

select * from employees
limit 1000;

End$$

DELIMITER ;

call employees.emp_1000();

call emp_1000();

/*
Create a procedure that will provide the average salary of all employees.
*/

DELIMITER $$
create procedure avg_salary()
Begin
select avg(salary) as avg_salary
from salaries;
End$$

DELIMITER ;

call avg_salary();
call salary();

-- Procedures with IN parameter

DELIMITER $$

create procedure emp_details(in p_emp_no integer)
Begin
		select e.first_name, e.last_name, s.salary, s.from_date, s.to_date
        from employees e
        join
        salaries s on e.emp_no = s.emp_no
        where e.emp_no = p_emp_no;
End$$
DELIMITER ;


DELIMITER $$
drop procedure emp_avg_salary;
create procedure emp_avg_salary(in p_emp_no integer)
Begin
		select e.first_name, e.last_name, avg(s.salary) as avg_salary
        from employees e
        join
        salaries s on e.emp_no = s.emp_no
        where e.emp_no = p_emp_no
        group by e.first_name, e.last_name;
End$$
DELIMITER ;

call emp_avg_salary(11300);


-- Stored routine with In and Out parameter
drop procedure employee_average_salary_out;
Delimiter $$
create procedure employee_average_salary_out(in p_emp_no integer, out p_avg_salary decimal(10,2))
begin
		select avg(s.salary)
        into p_avg_salary from
        employees e
        join salaries s on e.emp_no = s.emp_no
        where e.emp_no = p_emp_no;
end$$
Delimiter ;


/*
Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.
*/
drop procedure emp_no;
Delimiter $$
create procedure emp_no(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
begin
	select e.emp_no
    into p_emp_no from
    employees e
    where e.first_name = p_first_name and
    e.last_name = p_last_name;
end$$
Delimiter ;

select * from employees;


-- Triggers 
-- Before Insert
drop trigger salary_insert;
commit;

Delimiter $$
create trigger salary_insert
before insert on salaries_dup
for each row
begin
	if new.Salary < 0 then
		set new.Salary = 0;
	end if;
end$$
Delimiter ;

create table salaries_dup select * from salaries;

Select * from salaries_dup;

insert into salaries_dup values(10001, -96354, "1997-12-29", "2023-09-15");

select * from salaries_dup where emp_no = 10001;

-- Before Update

update salaries_dup
set salary = 96354
where salary = -96354;

select * from salaries_dup
where emp_no = 10001;

Delimiter $$
create trigger before_update
before update on salaries_dup
for each row
begin
	if new.salary < 0 then
		set new.salary = old.salary;
	end if;
end $$
Delimiter ;

update salaries_dup 
set salary = -11524
where from_date = "1997-12-29";

select * from salaries_dup
where emp_no = 10001;


use employees;

delimiter $$
create trigger salara_insert
after insert on dept_manager
for each row
begin
declare v_curr_salary int;
select max(salary)
into v_curr_salary from 
salaries
where enp_no = new.emp_no;

if v_curr_salary is not null
then
update salaries
set to_date = sysdate()
where emp_no = new.emp_no and 
to_date = new.to_date;

insert into salaries values(new.emp_no, v_curr_salary + 20000, new.from_date, new.to_date);
end if;
end $$

Delimiter ;

insert into dept_manager values("111534", "d009", date_format(sysdate(),"%Y-%m-%d"),"9999-01-01");
delete from dept_manager where emp_no = 111534;

select * from dept_manager;
select * from salaries where emp_no = 111534;


-- Indexes

SELECT 
    *
FROM
    employees
WHERE
    hire_date = '2000-01-01';
    
# With index

create index i_hire_date 
on employees(hire_date);


# Composite index

select * from employees 
where first_name = "Georgi" and
last_name = "Facello";

create index c_names
on employees(first_name, last_name);


show index from employees from employees;


/*
Drop the ‘i_hire_date’ index.
*/
alter table employees
drop index i_hire_date;


/*
Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum.

Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.
*/

select * from salaries where salary > 89000;

create index i_salary
on salaries(salary);



-- Case Statements

select emp_no, first_name, last_name,
case
	when gender = "M" then "Male"
    else "Female"
end as gender
from employees;


# Another way

select first_name, last_name,
case gender
	when "M" then "Male"
    else "Female"
end as gender
from employees;


/*
Display manager when an employee is manager or employee when not manager
*/

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
WHERE
    e.emp_no > 109990;
    
# Using If

SELECT 
    emp_no,
    first_name,
    last_name,
    IF(gender = 'M', 'Male', 'Female')
FROM
    employees;
    

select dm.emp_no, e.first_name, e.last_name, max(s.salary) - min(s.salary) as difference,
case
	when max(s.salary)-min(s.salary) > 30000 then "Salary was raised more than $30000"
    when max(s.salary)-min(s.salary) between 20000 and 30000 then "Salary was raised more than $20000 but less than $30000"
    else "Salary was raised less than $20000"
end as salary_increase
from employees e
join dept_manager dm on e.emp_no = dm.emp_no
join salaries s on s.emp_no = dm.emp_no
group by s.emp_no;


/*
Similar to the exercises done in the lecture, obtain a result set containing the employee number, first name, and last name of all employees with a number higher than 109990. 
Create a fourth column in the query, indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee. 
*/

select e.emp_no, e.first_name, e.last_name,
case
	when dm.emp_no is not null then "Manager"
    else "Employee"
end as is_manager
from employees e
left join 
dept_manager dm on e.emp_no = dm.emp_no
where e.emp_no > 109990;


/*
Extract a dataset containing the following information about the managers: employee number, first name, and last name. 
Add two columns at the end – one showing the difference between the maximum and minimum salary of that employee, 
and another one saying whether this salary raise was higher than $30,000 or NOT.
*/

select dm.emp_no, e.first_name, e.last_name, max(s.salary)-min(s.salary) as difference,
case 
	when max(s.salary)-min(s.salary) > 30000 then "Salary was raised more than $30000"
	else "Salary was not raised more than 30000"
end as salary_increase
from employees e
join dept_manager dm on e.emp_no = dm.emp_no
join salaries s on s.emp_no  = dm.emp_no
group by dm.emp_no;


/*
Extract the employee number, first name, and last name of the first 100 employees, and add a fourth column, 
called “current_employee” saying “Is still employed” if the employee is still working in the company, or “Not an employee anymore” if they aren’t.
*/

select * from dept_emp;

select e.emp_no, e.first_name, e.last_name,
case
	when max(de.to_date) > sysdate() then "Is still employed"
    else "Not employed anymore"
end as current_employee
from employees e
join dept_emp de on e.emp_no = de.emp_no
group by de.emp_no
limit 100;


-- Window functions
# Row_Number

select emp_no, salary,
row_number() over() as row_num
from salaries;

# With a parameter inside the over 

select emp_no, salary,
row_number() over(partition by emp_no) as row_num
from salaries;

# Partition by with order by 

select emp_no, salary,
row_number() over(partition by emp_no order by salary desc) as row_num
from salaries;


/*
Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database (regardless of their department).

Let the numbering disregard the department the managers have worked in. 
Also, let it start from the value of 1. Assign that value to the manager with the lowest employee number.
*/

select emp_no, dept_no,
row_number() over(order by emp_no) as row_num
from dept_manager;

# Two window functions in the same query

select emp_no, salary,
row_number() over(partition by emp_no) as row_num1,
row_number() over(partition by emp_no order by salary desc) as row_num2
from salaries;

/*
Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the "employees" database.

Use window functions to add the following two columns to the final output:

- a column containing the row number of each row from the obtained dataset, starting from 1.

- a column containing the sequential row numbers associated to the rows for each manager, 
where their highest salary has been given a number equal to the number of rows in the given partition, and their lowest - the number 1.

Finally, while presenting the output, make sure that the data has been ordered by the values in the first of the row number columns, 
and then by the salary values for each partition in ascending order.
*/

select dm.emp_no, s.salary,
row_number() over() as row_num1,
row_number() over(partition by dm.emp_no order by s.salary desc) as row_num2
from dept_manager dm
join
salaries s on dm.emp_no = s.emp_no
order by emp_no, row_num1, salary asc;


/*
Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the "employees" database.

Use window functions to add the following two columns to the final output:

- a column containing the row numbers associated to each manager, where their highest salary has been given a number equal to the number of rows in the given partition, 
and their lowest - the number 1.

- a column containing the row numbers associated to each manager, where their highest salary has been given the number of 1, 
and the lowest - a value equal to the number of rows in the given partition.

Let your output be ordered by the salary values associated to each manager in descending order.
*/


select dm.emp_no, s.salary,
row_number() over(partition by dm.emp_no order by s.salary asc) as row_num1,
row_number() over(partition by dm.emp_no order by s.salary desc ) as row_num2
from dept_manager dm
join 
salaries s  on s.emp_no = dm.emp_no;

# Another way of writing window functions

/*
Write a query that provides row numbers for all workers from the "employees" table, 
partitioning the data by their first names and ordering each partition by their employee number in ascending order.
*/

select emp_no, first_name,
row_number() over w as row_num
from employees 
window w as (partition by first_name order by emp_no);


# Using a subquery for extracting the highest salary for each employee number


select a.emp_no, a.salary as max_salary from
(select emp_no, salary,
row_number() over w as row_num
from salaries
window w as (partition by emp_no order by salary desc))a
where row_num = 1;


/*
Find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, 
use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.
*/


select a.emp_no, min(salary) as min_salary from
(select emp_no, salary, 
row_number() over w as row_num
from salaries 
window w as(partition by emp_no order by salary))a
group by a.emp_no;



/*
Again, find out the lowest salary value each employee has ever signed a contract for. Once again, to obtain the desired output, use a subquery containing a window function. 
This time, however, introduce the window specification in the field list of the given subquery.
*/


select a.emp_no, min(salary) as min_salary from
(select emp_no, salary,
row_number() over(partition by emp_no order by salary)
from salaries)a
group by a.emp_no;


/*
Once again, find out the lowest salary value each employee has ever signed a contract for. 
This time, to obtain the desired output, avoid using a window function. Just use an aggregate function and a subquery.
*/
select a.emp_no, min(salary) from
(select emp_no, salary
from salaries)a
group by emp_no;


/*
Once more, find out the lowest salary value each employee has ever signed a contract for. 
To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword. 
Moreover, obtain the output without using a GROUP BY clause in the outer query.
*/

select a.emp_no, salary from
(select emp_no, salary,
row_number() over w as row_num
from salaries
window w as(partition by emp_no order by salary asc))a
where row_num = 1;


/*
Find out the second-lowest salary value each employee has ever signed a contract for. 
To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword. 
Moreover, obtain the desired result set without using a GROUP BY clause in the outer query.
*/

select a.emp_no, salary from
(select emp_no, salary,
row_number() over w as row_num
from salaries
window w as(partition by emp_no order by salary asc))a
where row_num = 2;



-- Rank and Dense rank

# fetching the employees who have signed who than one contract of the same salary amount

select emp_no, (count(salary) - count(distinct salary)) as diff
from salaries
 group by emp_no
 having diff > 0
 order by emp_no;
 
 # Rank
 
 select emp_no, salary,
 rank() over w as rank_num
 from salaries
 where emp_no = 11839
 window w as(partition by emp_no order by salary);
 
 
# Dense rank

select emp_no, salary,
dense_rank() over w as rank_num
from salaries
where emp_no = 11839
window w as(partition by emp_no order by salary);


/*
Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.

Order and display the obtained salary values from highest to lowest.
*/

select emp_no, salary,
row_number() over w as row_num
from salaries 
where emp_no = 10560
window w as(partition by emp_no order by salary desc);


/*
Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in the company.
*/

select dm.emp_no, (count(salary)) as no_of_contracts
from dept_manager dm
join
salaries s on dm.emp_no = s.emp_no
group by dm.emp_no;


/*
Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. 
Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and 
that gaps in the obtained ranks for subsequent rows are allowed.
*/

select emp_no, salary,
rank() over w as rank_num
from salaries
where emp_no = 10560
window w as(partition by emp_no order by salary desc);

/*
Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. 
Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and 
that gaps in the obtained ranks for subsequent rows are not allowed.
*/

select emp_no, salary,
dense_rank() over w as d_rank
from salaries 
where emp_no = 10560
window w as(partition by emp_no order by salary desc);


-- Important Task 

select
	d.dept_no, d.dept_name, dm.emp_no, 
    rank() over w as dept_salary_ranking,
    s.salary,
    s.from_date as salary_from_date,
    s.to_date as salary_to_date,
    dm.from_date as dept_manager_from_date,
    dm.to_date as dept_manager_to_date
from dept_manager dm
join salaries s on dm.emp_no = s.emp_no
	and s.from_date between dm.from_date and dm.to_date
    and s.to_date between dm.from_date and dm.to_date
join departments d on dm.dept_no = d.dept_no
window w as (partition by dm.dept_no order by s.salary desc);


select * from salaries;


/*
Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive. 
Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks obtained for their subsequent rows.
*/ 

select e.emp_no, s.salary,
rank() over w as salary_rank
from employees e 
join
salaries s on e.emp_no = s.emp_no
where e.emp_no between 10500 and 10600
window w as (partition by e.emp_no order by s.salary desc);


/*
Write a query that ranks the salary values in descending order of the following contracts from the "employees" database:

- contracts that have been signed by employees numbered between 10500 and 10600 inclusive.

- contracts that have been signed at least 4 full-years after the date when the given employee was hired in the company for the first time.

In addition, let equal salary values of a certain employee bear the same rank. Do not allow gaps in the ranks obtained for their subsequent rows.

*/ 

select * from employees;
select * from salary;


select e.emp_no, s.salary,
dense_rank() over w as salary_rank,
s.from_date,
e.hire_date,
(year(s.from_date) - year(e.hire_date)) as years_from_start
from employees e
join salaries s on e.emp_no = s.emp_no
	and year(s.from_date) - year(e.hire_date) >= 4
where e.emp_no between 10500 and 10600
window w as (partition by e.emp_no order by s.salary desc);


-- Lag() and Lead()


select
emp_no,
salary,
lag(salary) over w as previous_salary,
lead(salary) over w as next_salary,
salary - lag(salary) over w as diff_current_previous,
lead(salary) over w - salary as diff_salary_next_current
from 
salaries 
where emp_no = 10001
window w as(order by salary);


/*
Write a query that can extract the following information from the "employees" database:

- the salary values (in ascending order) of the contracts signed by all employees numbered between 10500 and 10600 inclusive

- a column showing the previous salary from the given ordered list

- a column showing the subsequent salary from the given ordered list

- a column displaying the difference between the current salary of a certain employee and their previous salary

- a column displaying the difference between the next salary of a certain employee and their current salary

Limit the output to salary values higher than $80,000 only.

Also, to obtain a meaningful result, partition the data by employee number.
*/


select emp_no, salary,
lag
(salary) over w as previous_salary,
lead(salary) over w as next_salary,
salary - lag(salary) over w as diff_cureent_previous,
lead(salary) over w - salary as diff_next_cureent
from salaries 
where salary > 80000 and emp_no between 10500 and 10600
window w as (partition by emp_no order by salary);


/*
With that in mind, create a query whose result set contains data arranged by the salary values associated to each employee number (in ascending order). Let the output contain the following six columns:

- the employee number

- the salary value of an employee's contract (i.e. which we’ll consider as the employee's current salary)

- the employee's previous salary

- the employee's contract salary value preceding their previous salary

- the employee's next salary

- the employee's contract salary value subsequent to their next salary

Restrict the output to the first 1000 records you can obtain.
*/

select emp_no, salary,
lag(salary) over w as previuos_salary,
lag(salary,2) over w as 1_before_previous_salary,
lead(salary) over w as next_salary,
lead(salary,2) over w as 1_after_next_salary
from salaries
window w as (partition by emp_no order by salary)
limit 1000;

use employees;

-- AGGREGATE WINDOW FUNTIONS



SELECT de2.emp_no, d.dept_name, s2.salary, AVG(s2.salary) OVER (PARTITION BY d.dept_name) AS avg_salary_per_dept
FROM (
  SELECT s1.emp_no, s.salary
  FROM salaries s
  JOIN (
    SELECT emp_no, MAX(from_date) AS from_date
    FROM salaries
    GROUP BY emp_no
  ) s1 ON s.emp_no = s1.emp_no
  WHERE s.to_date > CURDATE() AND s.from_date = s1.from_date
) s2
JOIN (
  SELECT de.emp_no, de.dept_no
  FROM dept_emp de
  JOIN (
    SELECT emp_no, MAX(from_date) AS from_date
    FROM dept_emp
    GROUP BY emp_no
  ) de1 ON de.emp_no = de1.emp_no
  WHERE de.to_date > CURDATE() AND de.from_date = de1.from_date
) de2 ON s2.emp_no = de2.emp_no
JOIN departments d ON d.dept_no = de2.dept_no
group by de.emp_no, d.dept_name
ORDER BY de2.emp_no, d.dept_name;


/*
Create a query that upon execution returns a result set containing the employee numbers, 
contract salary values, start, and end dates of the first ever contracts that each employee signed for the company
*/


select s1.emp_no, s.salary, s.from_date, s.to_date
from salaries s
join
(select emp_no, min(from_date) as from_date
from salaries
group by emp_no) s1 on s.emp_no = s1.emp_no
where s.from_date = s1.from_date;


/*
Consider the employees' contracts that have been signed after the 1st of January 2000 and terminated before the 1st of January 2002 (as registered in the "dept_emp" table).

Create a MySQL query that will extract the following information about these employees:

- Their employee number

- The salary values of the latest contracts they have signed during the suggested time period

- The department they have been working in (as specified in the latest contract they've signed during the suggested time period)

- Use a window function to create a fourth field containing the average salary paid 
in the department the employee was last working in during the suggested time period. Name that field "average_salary_per_department".
*/

select de2.emp_no, d.dept_name, s2.salary, avg(s2.salary) over w as avg_salary_per_dept
from
(select s1.emp_no, s.salary, s.from_date, s.to_date
from salaries s
join
(select emp_no, max(from_date) as from_date
from salaries 
group by emp_no) s1 on s.emp_no = s1.emp_no
where s.to_date < "2002-01-01" and s.from_date > "2000-01-01"
and s.from_date = s1.from_date) s2
join
(select de.emp_no, de.dept_no, de.from_date, de.to_date
from dept_emp de 
join
(select emp_no, max(from_date) as from_date
from dept_emp
group by emp_no) de1 on de.emp_no = de1.emp_no
where de.to_date < "2002-01-01" and de.from_date > "2000-01-01"
and de.from_date = de1.from_date) de2 on s2.emp_no = de2.emp_no
join
departments d on de2.dept_no = d.dept_no
group by de2.emp_no, d.dept_name
window w as(partition by de2.dept_no)
order by de2.emp_no, s2.salary;

use employees;
-- CTEs(Common Table Expressions)

with cte as(select avg(salary) as avg_salary from salaries)
select sum(case when s.salary > c.avg_salary then 1 else 0 end) as no_of_contracts_above_avg,
count(s.salary) as total_number_of_contracts
from salaries s
join employees e on s.emp_no = e.emp_no and e.gender = 'F'
cross join 
cte c;

# Alternative solution

with cte as(select avg(salary) as avg_salary from salaries)
select sum(case when s.salary > c.avg_salary then 1 else 0 end) as no_of_contracts_above_avg_w_sum,
count(case when s.salary > c.avg_salary then s.salary else null end) as no_of_contracts_above_avg_w_count,
count(s.salary) as total_number_of_contracts
from salaries s
join employees e on s.emp_no = e.emp_no and e.gender = 'F'
cross join 
cte c;


/*
Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement in a query to find out how many male employees have never signed a contract with a salary value higher 
than or equal to the all-time company salary average.
*/

with cte as(select avg(salary) as avg_salary from salaries)
select sum(case when s.salary < c.avg_salary then 1 else 0 end) as no_of_contracts,
count(s.salary) as total_contracts
from salaries s 
join employees e on s.emp_no = e.emp_no and e.gender = 'M'
cross join 
cte c;

/*
Use a CTE (a Common Table Expression) and (at least one) COUNT() function in the SELECT statement of a query to find out how many male employees have never signed a contract with a salary value higher 
than or equal to the all-time company salary average.
*/

with cte as(select avg(salary) as avg_salary from salaries)
select count(case when s.salary < c.avg_salary then s.salary else null end) as no_of_contracts,
count(s.salary) as total_contracts
from salaries s 
join employees e on s.emp_no = e.emp_no and e.gender = 'M'
cross join 
cte c;

/*
Use MySQL joins (and don’t use a Common Table Expression) in a query to find out how many male employees have never signed a contract with a 
salary value higher than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise).
*/
use employees;

select sum(case when s.salary < a.avg_salary then 1 else 0 end) as number_of_contracts,
count(s.salary) as total_contracts
from salaries s
join
(select avg(salary) as avg_salary from salaries s) a
join employees e on s.emp_no = e.emp_no and e.gender = 'M';


/*
Use a cross join in a query to find out how many male employees have never signed a contract with a salary value 
higher than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise)
*/

with cte as(select avg(salary) as avg_salary from salaries)
select sum(case when s.salary < c.avg_salary then 1 else 0 end) as number_of_contracts_w_sum,
count(case when s.salary < c.avg_salary then s.salary else null end) as number_of_contracts_w_count,
count(s.salary) as total_contracts
from salaries s
join employees e on s.emp_no = e.emp_no and e.gender = "M"
cross join cte c;

# Using multiple subclauses in a with clause

/*
How many female employees' highest contract salary values wre higher than the all time company salary average(accross all genders)
*/

with cte1 as(select avg(salary) as avg_salary from salaries),
cte2 as(select s.emp_no,max(s.salary) as f_max_salary from salaries s join employees e on s.emp_no = e.emp_no and e.gender = "F" group by s.emp_no)
select sum(case when c2.f_max_salary > c1.avg_salary then 1 else 0 end) as f_max_salary_above_avg,
count(case when c2.f_max_salary > c1.avg_salary then c2.f_max_salary else null end) as f_max_salary_above_avg_w_count,
count(e.emp_no) as total_contracts
from employees e
join cte2 c2 on c2.emp_no = e.emp_no
cross join cte1 c1;

# To see the percentage

with cte1 as(select avg(salary) as avg_salary from salaries),
cte2 as(select s.emp_no,max(s.salary) as f_max_salary from salaries s join employees e on s.emp_no = e.emp_no and e.gender = "F" group by s.emp_no)
select sum(case when c2.f_max_salary > c1.avg_salary then 1 else 0 end) as f_max_salary_above_avg,
count(e.emp_no) as total_contracts,
concat(round((sum(case when c2.f_max_salary > c1.avg_salary then 1 else 0 end)/count(e.emp_no))*100,2),"%") as percent_contracts
from employees e
join cte2 c2 on c2.emp_no = e.emp_no
cross join cte1 c1;


/*
Use two common table expressions and a SUM() function in the SELECT 
statement of a query to obtain the number of male employees whose highest salaries have been below the all-time average.
*/

with cte1 as(select avg(salary) avg_salary from salaries),
cte2 as(select s.emp_no, max(s.salary) as f_max_salary from salaries s 
join employees e on s.emp_no = e.emp_no and e.gender = "F" group by s.emp_no)
select sum(case when c2.f_max_salary < c1.avg_salary then 1 else 0 end) as no_of_contracts_below_avg,
count(e.emp_no)
from employees e
join cte2 c2 on e.emp_no = c2.emp_no
cross join cte1 c1;


/*
Use two common table expressions and a COUNT() function in the SELECT statement of a query to obtain the number of male employees whose highest 
salaries have been below the all-time average.
*/

with cte1 as(select avg(salary)as av_salary from salaries),
cte2 as(select s.emp_no, max(s.salary) as max_salary from salaries s 
join employees e on s.emp_no = e.emp_no and e.gender = "M" group by s.emp_no)
select count(case when c2.max_salary < c1.av_salary then c2.max_salary else null end) as_no_of_contracts
from employees e 
join cte2 c2 on c2.emp_no = e.emp_no
cross join cte1 c1;


/*
Does the result from the previous exercise change if you used the Common Table Expression (CTE) for the male employees' 
highest salaries in a FROM clause, as opposed to in a join?
*/

with cte1 as(select avg(salary)as av_salary from salaries),
cte2 as(select s.emp_no, max(s.salary) as max_salary from salaries s 
join employees e on s.emp_no = e.emp_no and e.gender = "M" group by s.emp_no)
select count(case when c2.max_salary < c1.av_salary then c2.max_salary else null end) as_no_of_contracts
from cte2 c2
cross join cte1 c1;


/*
Retrive the highest contract salary values pf all employees hired in 2000 or later
*/

with employee_hired_from_jan_2000 as(select * from employees where hire_date > "2000-01-01"),
highest_salary as(select e.emp_no,max(s.salary) as max_salary from employee_hired_from_jan_2000 e join salaries s on e.emp_no = s.emp_no group by e.emp_no)
select * from highest_salary;


-- Temporary Tables

create temporary table f_highest_salary
select s.emp_no, max(s.salary) as f_highest_salary
from salaries s
join employees e on e.emp_no = s.emp_no and e.gender = "F"
group by s.emp_no;

select * from f_highest_salary;


/*
Store the highest contract salary values of all male employees in a temporary table called male_max_salaries.
*/

create temporary table male_max_salary
select s.emp_no, max(s.salary) as max_salary
from salaries s 
join employees e on s.emp_no = e.emp_no and e.gender = "M"
group by s.emp_no;

select * from male_max_salary;


# Self join using cte

with cte as(select s.emp_no, max(s.salary) as f_highest_salary from salaries s
join employees e on e.emp_no = s.emp_no and e.gender = "F" group by s.emp_no limit 10)
select * from f_highest_salary f1 join cte c;

# Performing union all

with cte as(select s.emp_no, max(s.salary) as f_highest_salary from salaries s
join employees e on e.emp_no = s.emp_no and e.gender = "F" group by s.emp_no limit 10)
select * from f_highest_salary union all select * from cte;


/*
Create a temporary table called dates which contains the following datetime columns
1. The current date and time 
2.A month earlier than the current date and time
3.An year later than the current date and time
*/

create temporary table dates
select 
now() as current_date_time,
date_sub(now(), interval 1 month) as a_month_earlier,
date_sub(now(), interval -1 year) as year_later;

select * from dates;

# Self join using cte

with cte as(select 
now() as current_date_time,
date_sub(now(), interval 1 month) as a_month_earlier,
date_sub(now(), interval -1 year) as year_later)
select * from dates d1 join cte c;


/*
Create a temporary table called dates containing the following three columns:

- one displaying the current date and time,

- another one displaying two months earlier than the current date and time, and a

- third column displaying two years later than the current date and time.
*/

create temporary table d
select now() as current_date_time,
date_sub(now(), interval 2 month) as 2_months_earlier,
date_sub(now(), interval -2 year) as 2_years_later;

select * from d;

/*
Create a query joining the result sets from the dates temporary table you created 
during the previous lecture with a new Common Table Expression (CTE) containing the same columns. 
Let all columns in the result set appear on the same row.
*/

with cte as(select now() as current_date_time,
date_sub(now(),interval -2 month) as 2_months_earlier,
date_sub(now(), interval -2 year) as 2_years_later)
select * from dates d join cte c;

/*
Again, create a query joining the result sets from the dates temporary table you created during the previous lecture with 
a new Common Table Expression (CTE) containing the same columns. This time, combine the two sets vertically
*/

with cte as(select now() as current_date_time,
date_sub(now(),interval -2 month) as 2_months_earlier,
date_sub(now(), interval -2 year) as 2_years_later)
select * from dates union all select * from cte;

/*
Drop the male_max_salaries and dates temporary tables you recently created.
*/

drop table if exists d;