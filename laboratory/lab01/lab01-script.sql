select 
  de.dept_no, 
  d.dept_name, 
  sum(s.salary) as salary 
from 
  dept_emp de, 
  departments d, 
  (select emp_no, salary from salaries 
   where from_date <= current_date and to_date >= current_date) as s 
where de.dept_no = d.dept_no 
  and s.emp_no = de.emp_no 
  and from_date <= current_date and to_date >= current_date 
group by de.dept_no, 
  	 d.dept_name 
order by salary desc;

