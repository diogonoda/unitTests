create or replace package pc_departments
 as
  function get_department(p_id  in  departments.dept_id%type)
    return departments%rowtype;
end pc_departments;
/
--
--
create or replace package body pc_departments
 as
  function get_department(p_id  in  departments.dept_id%type)
    return departments%rowtype
   as
    v_department  departments%rowtype;
  begin
    select dept_id,
           dept_name,
           dept_sta_bonus
      into v_department.dept_id,
           v_department.dept_name,
           v_department.dept_sta_bonus
      from departments
     where dept_id = p_id;
    --
    return v_department;
  exception
    when no_data_found then
      return null;
    when others then
      raise_application_error(-20101, sqlerrm);
  end get_department;
end pc_departments;
/
