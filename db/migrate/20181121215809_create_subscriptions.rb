class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :follower, null: false, index: true, foreign_key: {to_table: :users, on_delete: :cascade}
      t.references :followee, null: false, index: true, foreign_key: {to_table: :users, on_delete: :cascade}

      t.timestamps
    end

    add_index :subscriptions, [:follower_id, :followee_id], unique: true
  end
end
