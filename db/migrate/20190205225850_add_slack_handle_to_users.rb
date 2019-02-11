class AddSlackHandleToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack_handle, :string
  end
end
