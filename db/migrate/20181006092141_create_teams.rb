class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_join_table :admins, :teams do |t|
      t.references :admin, index: true, foreign_key: {to_table: :users, on_delete: :cascade}
      t.references :team, index: true, foreign_key: {on_delete: :cascade}
    end

    create_join_table :members, :teams do |t|
      t.references :member, index: true, foreign_key: {to_table: :users, on_delete: :cascade}
      t.references :team, index: true, foreign_key: {on_delete: :cascade}
    end
  end
end
