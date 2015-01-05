class AddColumnsToWeeklytimetableDetail < ActiveRecord::Migration
  def change
    add_column :weeklytimetable_details, :location_desc, :string
  end
end
