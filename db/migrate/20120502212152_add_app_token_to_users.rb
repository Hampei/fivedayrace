class AddAppTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :app_token, :string, limit: 32, null: false, default: ''
  end
end
