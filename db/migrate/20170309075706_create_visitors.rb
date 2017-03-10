class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :name
      t.string :icno
      t.integer :rank_id
      t.integer :title_id
      t.string :phoneno
      t.string :hpno
      t.string :email
      t.string :expertise
      t.boolean :corporate
      t.string :department
      t.integer :address_book_id

      t.timestamps
    end
  end
end
