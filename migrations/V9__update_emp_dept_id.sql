update employees
   set emp_dept_id = 2
 where emp_id in(1, 4);
--
update employees
   set emp_dept_id = 1
 where emp_dept_id is null;
