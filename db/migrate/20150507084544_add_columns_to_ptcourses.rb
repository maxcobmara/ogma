class AddColumnsToPtcourses < ActiveRecord::Migration
  def change
    add_column :ptcourses, :training_classification, :integer
  end
end
