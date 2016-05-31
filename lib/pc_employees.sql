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
  --
  function pode_receber_aumento(p_employee  in  employees%rowtype)
    return boolean;
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
           emp_hiredate,
           emp_dept_id
      into v_employee.emp_id,
           v_employee.emp_name,
           v_employee.emp_salary,
           v_employee.emp_hiredate,
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
    v_employee  employees%rowtype;
  begin
    v_employee := pc_employees.get_employee(p_id => p_id);
    --
    if pc_employees.pode_receber_aumento(p_employee => v_employee) then
      update employees
         set emp_salary = emp_salary * 1.1
       where emp_id = p_id;
    end if;
  end aumenta_salario;
  --
  function pode_receber_aumento(p_employee  in  employees%rowtype)
    return boolean
   is
  begin
    if months_between(sysdate, p_employee.emp_hiredate) < 12 then
      return false;
    end if;
    --
    if pc_departments.get_department(p_id => p_employee.emp_dept_id).dept_sta_bonus = 'N' then
      return false;
    end if;
    --
    return true;
  end pode_receber_aumento;
end pc_employees;
/
