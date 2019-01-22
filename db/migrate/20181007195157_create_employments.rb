class CreateEmployments < ActiveRecord::Migration[5.2]
  def change
    create_table :employments do |t|
      t.references :user, null: false, index: true, foreign_key: {on_delete: :cascade}
      t.references :company, null: false, index: true, foreign_key: {on_delete: :cascade}
      t.boolean :admin, null: false, default: false

      t.timestamps
    end

    add_index :employments, [:company_id, :user_id], unique: true
  end
end
