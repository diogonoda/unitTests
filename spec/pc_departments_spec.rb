require_relative '../spec/spec_helper'

# encoding: utf-8
describe 'Testa rotinas da pc_employees' do

  after(:all) do
    plsql.rollback
  end

  it 'Retorna o registro do department' do

    v_department = {
                    :dept_id        => -1,
                    :dept_name      => "US Mariners",
                    :dept_sta_bonus => 'S'
                   }

    plsql.departments.insert v_department

    expect(plsql.pc_departments.get_department(:p_id => v_department[:dept_id])).to eq(v_department)

  end

end
