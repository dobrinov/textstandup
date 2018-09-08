require 'rails_helper'

describe DailyReportForm do
  it 'works' do
    user = create :user
    x = create :daily_report, day: 1, month: 1, year: 2018, user: user

    y = DailyReportForm.new daily_report: x

    p y.tasks
    p y.delivered
    y.build_delivered
    p y.tasks
    p y.delivered
  end
end
