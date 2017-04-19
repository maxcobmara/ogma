class CreateRepositorysearches < ActiveRecord::Migration
  def change
    create_table :repositorysearches do |t|
      t.text :keyword
      t.integer :college_id
      t.text :data

      t.timestamps
    end
  end
end
