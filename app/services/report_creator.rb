module ReportCreator
  extend self

  def execute(owner, attributes)
    raise EmptyReportError if attributes[:items].empty?

    report = Report.new user: owner, type: attributes[:type]

    report.transaction do
      report.save!

      attributes[:items].each do |item|
        title = item.fetch :title
        description = item.fetch :description
        type = item.fetch :type

        ReportItem.create! title: title, description: description, type: type, report: report
      end
    end

    report
  end

  class EmptyReportError < StandardError
    def initialize
      super 'Cannot create an empty report'
    end
  end
end
