create or replace package pc_employees
 as
  function get_employee(p_id  in  employees.emp_id%type)
    return employees%rowtype;
  --
  procedure insert_employees(p_name      in  employees.emp_name%type,
                             p_salary    in  employees.emp_salary%type,
                             p_emp_dept  in  employees.emp_dept_id%type);
  --
  function get_employee_name(p_id  in  employees.emp_id%type)
    return employees.emp_name%type;
  --
  procedure aumenta_salario(p_id  in  employees.emp_id%type);
end pc_employees;
/
--
--
create or replace package body pc_employees
 as
  function get_employee(p_id  in  employees.emp_id%type)
    return employees%rowtype
   as
    v_employee  employees%rowtype;
  begin
    select emp_id,
           emp_name,
           emp_salary,
           emp_dept_id
      into v_employee.emp_id,
           v_employee.emp_name,
           v_employee.emp_salary,
           v_employee.emp_dept_id
      from employees
     where emp_id = p_id;
    --
    return v_employee;
  exception
    when no_data_found then
      return null;
    when others then
      raise_application_error(-20101, sqlerrm);
  end get_employee;
  --
  procedure insert_employees(p_name      in  employees.emp_name%type,
                             p_salary    in  employees.emp_salary%type,
                             p_emp_dept  in  employees.emp_dept_id%type)
   as
  begin
    insert into employees(emp_id,
                          emp_name,
                          emp_salary,
                          emp_dept_id)
                   values(seq_employees.nextval,
                          p_name,
                          p_salary,
                          p_emp_dept);
  exception
    when others then
      raise_application_error(-20101, sqlerrm);
  end insert_employees;
  --
  function get_employee_name(p_id  in  employees.emp_id%type)
    return employees.emp_name%type
   is
  begin
    return get_employee(p_id => p_id).emp_name;
  end get_employee_name;
  --
  procedure aumenta_salario(p_id  in  employees.emp_id%type)
   is
    v_salary    employees.emp_salary%type;
    v_hiredate  employees.emp_hiredate%type;
    v_dept_id   employees.emp_dept_id%type;
    --
    v_sta_bonus  departments.dept_sta_bonus%type;
  begin
    select emp_salary,
           emp_hiredate,
           emp_dept_id
      into v_salary,
           v_hiredate,
           v_dept_id
      from employees
     where emp_id = p_id;
    --
    if months_between(sysdate, v_hiredate) >= 12 then
      select dept_sta_bonus
        into v_sta_bonus
        from departments
       where dept_id = v_dept_id;
      --
      if v_sta_bonus = 'S' then
        update employees
           set emp_salary = emp_salary * 1.1
         where emp_id = p_id;
      end if;
    end if;
  end aumenta_salario;
end pc_employees;
/
