class CreateDailyReports < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_reports do |t|
      t.integer :day, null: false
      t.integer :month, null: false
      t.integer :year, null: false
      t.references :user, null: false, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end

    add_index :daily_reports, [:user_id, :day, :month, :year], unique: true
  end
end
