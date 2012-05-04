class CreateActivityDays < ActiveRecord::Migration
  def change
    create_table :activity_days do |t|
      t.integer :user_id
      t.date :date
      t.integer :steps
      t.integer :stairs

      t.timestamps
    end
  end
end
