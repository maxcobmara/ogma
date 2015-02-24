class CreateStationerySearch < ActiveRecord::Migration
  def change
    create_table :stationerysearches do |t|
      t.string :product
      t.string :document
      t.date :received
      t.date :received2
      t.integer :issuedby
      t.integer :receivedby
      t.date :issuedate
      t.date :issuedate2
    end
  end
end
