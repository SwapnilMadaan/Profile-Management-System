class AddIndexToNormalUsersId < ActiveRecord::Migration[5.1]
  def change
  	add_index :users, :user_email
  	add_index :users, :user_contact
  	add_index :users, :created_at

  end
end
