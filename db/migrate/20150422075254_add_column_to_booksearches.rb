class AddColumnToBooksearches < ActiveRecord::Migration
  def change
    add_column :booksearches, :publisher, :string
  end
end
