class CreateReportItems < ActiveRecord::Migration[5.2]
  def change
    create_table :report_items do |t|
      t.text :title, null: false
      t.text :description, null: false
      t.column :type, :report_item_type, null: false, index: true

      t.references :report, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
