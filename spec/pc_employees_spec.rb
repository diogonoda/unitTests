require_relative '../spec/spec_helper'

# encoding: utf-8
describe 'Testa rotinas da pc_employees' do

  after(:all) do
    plsql.rollback
  end

  it 'Retorna nome do employee com id 1' do

    v_name = "Rodrigo"

    expect(plsql.pc_employees.get_employee_name(:p_id => 1)).to eq(v_name)

  end

  it 'Retorna o registro do employee' do

    v_employee = {
                  :emp_id       => 2,
                  :emp_name     => "Diogo",
                  :emp_salary   => 2000,
                  :emp_hiredate => Time.local(2015, 8, 2, 23, 52, 37),
                  :emp_dept_id  => 1
                 }

    expect(plsql.pc_employees.get_employee(:p_id => 2)).to eq(v_employee)

  end

  it 'Testa o retorno de um employee que não existe' do

    v_employee = {
                  :emp_id       => nil,
                  :emp_name     => nil,
                  :emp_salary   => nil,
                  :emp_hiredate => nil,
                  :emp_dept_id  => nil
                 }

    expect(plsql.pc_employees.get_employee(:p_id => -1)).to eq(v_employee)

  end

  it 'Testa o insert de um employee' do

    v_qtd_inicial = plsql.select_one("select count(1) from employees where emp_name = 'Abreu'")

    plsql.pc_employees.insert_employees(:p_name => "Mussum Forevis", :p_salary => 9500, :p_emp_dept => 2)

    expect(plsql.select_one("select count(1) from employees where emp_name = 'Mussum Forevis'")).to eq(v_qtd_inicial + 1)

  end

  it 'Testa aumento de salário de employee com menos de 1 ano' do

    v_department = {
                    :dept_id        => -1,
                    :dept_name      => "US Mariners",
                    :dept_sta_bonus => "S"
                   }

    plsql.departments.insert v_department

    v_employee = {
                  :emp_id       => -1,
                  :emp_name     => "Mussum Forevis",
                  :emp_salary   => 1000,
                  :emp_hiredate => plsql.sysdate,
                  :emp_dept_id  => -1
                 }

    plsql.employees.insert v_employee

    plsql.pc_employees.aumenta_salario(:p_id => -1)

    expect(plsql.select_one("select emp_salary from employees where emp_id = -1")).to eq(v_employee[:emp_salary])

  end

  it 'Testa aumento de salário de employee com mais de 1 ano' do

    v_employee = plsql.pc_employees.get_employee(:p_id => 3)

    plsql.pc_employees.aumenta_salario(:p_id => v_employee[:emp_id])

    expect(plsql.select_one("select emp_salary " +
                            "  from employees " +
                            " where emp_id = " + v_employee[:emp_id].to_s)).to eq(v_employee[:emp_salary] * 1.1)

  end
end
