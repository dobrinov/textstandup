class AddSlackAttributesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack_direct_message_channel, :string
    add_column :users, :slack_avatar_url, :string
  end
end
