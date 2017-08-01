class AddColumnToEvaluatecoursesearches < ActiveRecord::Migration
  def change
    add_column :evaluatecoursesearches, :visitor_id, :integer
  end
end
