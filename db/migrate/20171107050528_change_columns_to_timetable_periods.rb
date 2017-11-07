class ChangeColumnsToTimetablePeriods < ActiveRecord::Migration
  def change
    add_column :timetable_periods, :seq, :integer
  end
end
