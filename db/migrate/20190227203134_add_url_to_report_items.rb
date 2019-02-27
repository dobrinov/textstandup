class AddUrlToReportItems < ActiveRecord::Migration[5.2]
  def change
    add_column :report_items, :url, :string
  end
end
