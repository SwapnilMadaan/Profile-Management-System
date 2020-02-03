class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :user_email
      t.integer :parent_id
      t.string :password_digest
      t.integer :user_contact

      t.timestamps
     end
  end
end
