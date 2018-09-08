class CreateBlockers < ActiveRecord::Migration[5.2]
  def change
    create_table :blockers do |t|
      t.string :title, null: false
      t.string :summary, null: false

      t.references :daily_report, null: false, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
