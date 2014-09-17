class RenameUserToLogin < ActiveRecord::Migration
  def change
    rename_table :users, :logins
  end
end
