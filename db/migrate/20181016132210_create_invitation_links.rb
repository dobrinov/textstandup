class CreateInvitationLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :invitation_links do |t|
      t.references :company, index: true, null: false, foreign_key: {on_delete: :cascade}
      t.references :inviting_user, references: :user, index: true, null: false, foreign_key: {to_table: :users, on_delete: :cascade}
      t.references :invited_user, references: :user, index: true, foreign_key: {to_table: :users, on_delete: :cascade}
      t.string :code, null: false

      t.datetime :used_at

      t.timestamps
    end
  end
end
