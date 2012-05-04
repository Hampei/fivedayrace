class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string, null: false, default: ''
  end
end
