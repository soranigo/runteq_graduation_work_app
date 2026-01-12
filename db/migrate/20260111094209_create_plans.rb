class CreatePlans < ActiveRecord::Migration[7.2]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :starting_day_of_week, null: false
      t.time :starting_time_before_type_conversion, null: false
      t.string :starting_time, null: false
      t.integer :ending_day_of_week, null: false
      t.time :ending_time_before_type_conversion, null: false
      t.string :ending_time, null: false
      t.references :user, foreign_key: true
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
