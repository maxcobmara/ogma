class AddColumnToStudentDisciplineCase < ActiveRecord::Migration
  def change
    add_column :student_discipline_cases, :comandant_id, :integer
  end
end
