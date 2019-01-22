class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.column :type, :report_type, null: false, index: true
      t.references :user, index: true, foreign_key: {on_delete: :cascade}
      t.timestamps
    end
  end
end
