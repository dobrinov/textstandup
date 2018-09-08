class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  helper_method :morning_report_missing?

  private

  def parse_date(date)
    case date
    when 'today', nil
      Date.today
    else
      Date.parse date
    end
  end

  def today
    @today ||= Date.today
  end

  def todays_report
    @todays_report ||= DailyReport.find_by day: today.day, month: today.month, year: today.year
  end

  def morning_report_missing?
    return unless today.wday.in? 1..5

    todays_report.nil?
  end
end
