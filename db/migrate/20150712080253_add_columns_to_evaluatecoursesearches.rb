class AddColumnsToEvaluatecoursesearches < ActiveRecord::Migration
  def change
    add_column :evaluatecoursesearches, :invite_lecturer, :string
    add_column :evaluatecoursesearches, :evaldate_end, :date
    add_column :evaluatecoursesearches, :programme_id2, :integer
    add_column :evaluatecoursesearches, :is_staff, :boolean
  end
end
