module ReportUpdater
  extend self

  def execute(user, report_id, attributes)
    report = user.reports.find report_id

    report.transaction do
      report.items.where.not(id: attributes[:items].map { |item| item[:id] }).destroy_all

      attributes[:items].each do |item|
        id = item[:id]
        title = item.fetch :title
        description = item.fetch :description
        type = item[:type]

        if id.blank?
          ReportItem.create! title: title, description: description, type: type, report: report
        else
          report.items.where(id: id).update_all title: title, description: description
        end
      end

      report.destroy if report.items.empty?
    end

    report
  end
end
