class AddIsAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_admin, :boolean, default: 0
  end
end
