class AddColumnToTimetablePeriods < ActiveRecord::Migration
  def change
    add_column :timetable_periods, :non_class, :integer
  end
end
