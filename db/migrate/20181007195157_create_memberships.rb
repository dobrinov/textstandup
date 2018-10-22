class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, index: true, foreign_key: {on_delete: :cascade}
      t.references :team, null: false, index: true, foreign_key: {on_delete: :cascade}
      t.boolean :admin, null: false, default: false

      t.timestamps
    end

    add_index :memberships, [:team_id, :user_id], unique: true
  end
end
