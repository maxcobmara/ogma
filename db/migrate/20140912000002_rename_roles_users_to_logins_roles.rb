class RenameRolesUsersToLoginsRoles < ActiveRecord::Migration
  def change
    rename_table :roles_users, :logins_roles
    rename_column :logins_roles, :user_id, :login_id
  end
end