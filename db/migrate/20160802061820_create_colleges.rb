class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :code
      t.string :name
      t.text :data
      t.timestamps
    end
  end
end
