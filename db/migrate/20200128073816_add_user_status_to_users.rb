class AddUserStatusToUsers < ActiveRecord::Migration[5.1]
  def change
  	execute <<-SQL
    CREATE TYPE user_activity AS ENUM ('active', 'inactive');
    SQL
    add_column :users, :user_status, :user_activity, :default => 'active'
  end
end
