class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :name
      t.integer :category
      t.integer :college_id
      t.text :data
      
      t.timestamps
    end
  end
end
