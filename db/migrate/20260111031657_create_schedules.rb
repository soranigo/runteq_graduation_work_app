class CreateSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :schedules do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
