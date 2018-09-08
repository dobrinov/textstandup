class DailyReport < ApplicationRecord
  belongs_to :user
  has_many :tasks
  has_many :announcements
  has_many :blockers

  def date
    Date.new year, month, day
  end

  def weekday_name
    date == Date.today ? 'Today' : date.strftime('%A')
  end
end
