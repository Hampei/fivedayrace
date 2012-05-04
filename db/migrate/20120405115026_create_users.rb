class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :fitbit_token
      t.string :fitbit_secret
      t.string :fitbit_uid

      t.timestamps
    end
  end
end
