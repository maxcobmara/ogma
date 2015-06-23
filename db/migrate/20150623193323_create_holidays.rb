class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :hname
      t.date :hdate
    end
  end
end
