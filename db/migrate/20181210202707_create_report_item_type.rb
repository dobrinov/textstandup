class CreateReportItemType < ActiveRecord::Migration[5.2]
  def up
    execute "CREATE TYPE report_item_type AS ENUM('DeliveredReportItem', 'OngoingReportItem', 'PlannedReportItem', 'BlockerReportItem', 'AnnouncementReportItem')"
  end

  def down
    execute 'DROP TYPE report_item_type'
  end
end
