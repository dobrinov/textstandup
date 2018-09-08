class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.column :state, :task_states, null: false
      t.string :title, null: false
      t.string :summary, null: false

      t.references :daily_report, null: false, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end

    add_index :tasks, :state
  end
end
