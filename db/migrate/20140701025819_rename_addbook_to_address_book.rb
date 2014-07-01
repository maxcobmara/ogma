class RenameAddbookToAddressBook < ActiveRecord::Migration
  def change
    rename_table :addbooks, :address_books
  end
end
