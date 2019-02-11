class AddSlackTokenToCompany < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :slack_access_token, :string
  end
end
