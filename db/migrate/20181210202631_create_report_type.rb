class CreateReportType < ActiveRecord::Migration[5.2]
  def up
    execute "CREATE TYPE report_type AS ENUM('DeliveryReport', 'MorningReport')"
  end

  def down
    execute 'DROP TYPE report_type'
  end
end
