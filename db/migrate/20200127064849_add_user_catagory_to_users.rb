class AddUserCatagoryToUsers < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      DROP TYPE user_type;

      CREATE TYPE user_type AS ENUM ('owner', 'user', 'broker');
    SQL
    add_column :users, :user_catagory, :user_type ,  :default => 'user'
  end
end
