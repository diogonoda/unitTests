alter table employees
  add constraint fk_emp_dept
      foreign key (emp_dept_id)
       references departments(dept_id);
