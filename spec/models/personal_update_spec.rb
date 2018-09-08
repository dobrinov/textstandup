require 'rails_helper'

describe DailyReport do
  it 'works' do
    date = Date.new 2018, 1, 1
    user = create :user

    create :task, state: 'planned', day: 1, month: 1, year: 2018, user: user
    create :task, state: 'in_progress', day: 1, month: 1, year: 2018, user: user
    create :task, state: 'delivered', day: 1, month: 1, year: 2018, user: user
    create :blocker, day: 1, month: 1, year: 2018, user: user
    create :announcement, day: 1, month: 1, year: 2018, user: user

    daily_report = DailyReport.new user, date

    p daily_report.present?
  end
end
