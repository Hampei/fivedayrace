class CreateFriendsUsers < ActiveRecord::Migration
  def change
    create_table :following_users do |t|
      t.integer :user_id, null: false
      t.integer :following_id, null: false
    end
    add_index :following_users, :user_id
    add_index :following_users, :following_id
  end
end
