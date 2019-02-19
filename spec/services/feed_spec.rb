require 'rails_helper'

describe Feed do
  it 'uses current (time zone aware) date if date is not specified'
  it 'works with dates passed as a string'
  it 'works with dates'

  describe '(next date)' do
    it 'returns the next date after the selected one'
    it 'has no next date if the selected date is today'
  end

  describe '(previous date)' do
    it 'returns the date before the selected date'
  end

  it 'returns reports for the selected according to the time zone of the user' do
    time_zone = ActiveSupport::TimeZone['Hawaii']
    Timecop.freeze time_zone.parse("2019-01-02 00:00:00")

    user = create :user, time_zone: time_zone.name

    create :morning_report, created_at: time_zone.parse('2018-12-31 23:59:59'), user: user
    create :morning_report, created_at: time_zone.parse('2019-01-01 00:00:00'), user: user
    create :morning_report, created_at: time_zone.parse('2019-01-01 23:59:59'), user: user
    create :morning_report, created_at: time_zone.parse('2019-01-02 00:00:00'), user: user

    browser = Feed.new user: user, selected_date: '2019-01-01'

    p Report.pluck :created_at
    p browser.reports.count

    Timecop.return
  end
end
