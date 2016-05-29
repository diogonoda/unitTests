create table employees(
                       emp_id        number(3),
                       emp_name      varchar2(50),
                       emp_salary    number(17,2),
                       emp_hiredate  date,
            constraint pk_emp
               primary key(emp_id)
                      );
