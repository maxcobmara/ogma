class AddColumnToStudentCounselingSearches < ActiveRecord::Migration
  def change
    add_column :studentcounselingsearches, :confirmed_at_start, :datetime
    add_column :studentcounselingsearches, :confirmed_at_end, :datetime
    add_column :studentcounselingsearches, :is_confirmed, :boolean
    add_column :studentcounselingsearches, :name, :string
  end
end
