require 'rails_helper'

describe TeamMorningReport do
  it 'generates a morning report from two consecutive days' do
    team = create :team
    user = create :user, teams: [team]

    current_date = Date.new 2018, 10, 20
    previous_date = Date.new 2018, 10, 19

    current_day_report = create :daily_report, user: user, day: current_date.day, month: current_date.month, year: current_date.year
    previous_day_report = create :daily_report, user: user, day: previous_date.day, month: previous_date.month, year: previous_date.year

    team_morning_report = TeamMorningReport.new team: team, date: current_date
    user_morning_report = team_morning_report.morning_reports[user.id]

    user_morning_report.should be_present
    user_morning_report.current_day_report.should eq current_day_report
    user_morning_report.previous_day_report.should eq previous_day_report
  end

  it 'generates a morning reprot from two non consecutive days' do
    team = create :team
    user = create :user, teams: [team]

    current_date = Date.new 2018, 10, 20
    previous_date = Date.new 2018, 10, 15

    current_day_report = create :daily_report, user: user, day: current_date.day, month: current_date.month, year: current_date.year
    previous_day_report = create :daily_report, user: user, day: previous_date.day, month: previous_date.month, year: previous_date.year

    team_morning_report = TeamMorningReport.new team: team, date: current_date
    user_morning_report = team_morning_report.morning_reports[user.id]

    user_morning_report.should be_present
    user_morning_report.current_day_report.should eq current_day_report
    user_morning_report.previous_day_report.should eq previous_day_report
  end
end
