50 -
select * from employees.departments order by dept_name asc; 
select * from company.department order by departmentname asc; 
select * from all_departments order by dept_name asc; 

51 -
select ed.dept_name 
from employees.departments ed,
     company.department cd
where ed.dept_name = cd.departmentname;
	
52- 
select distinct(title) from employees.titles order by title;
select distinct(jobtitle) from company.employees order by jobtitle;
select distinct(title) from all_titles order by title;

53 - select * 
     from employees.titles et,
     	  company.employees ce
     where et.title = ce.jobtitle

