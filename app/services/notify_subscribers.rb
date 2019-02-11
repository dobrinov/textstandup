class NotifySubscribers
  class << self
    def execute(report)
      new(report).execute
    end
  end

  def initialize(report)
    @report = report
  end

  def execute
    SlackNotifier.execute @report if @report.user.company.slack_access_token
  end
end
