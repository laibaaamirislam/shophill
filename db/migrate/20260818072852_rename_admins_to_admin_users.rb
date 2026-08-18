# db/migrate/..._rename_admins_to_admin_users.rb
class RenameAdminsToAdminUsers < ActiveRecord::Migration[8.1]
  def change
    rename_table :admins, :admin_users
  end
end