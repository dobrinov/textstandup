class DailyReport < ApplicationRecord
  belongs_to :user
  has_many :tasks
  has_many :announcements
  has_many :blockers

  def delivered
    tasks.where state: 'delivered'
  end

  def in_progress
    tasks.where state: 'in_progress'
  end

  def planned
    tasks.where state: 'planned'
  end

  def date
    Date.new year, month, day
  end

  def weekday_name
    date == Date.today ? 'Today' : date.strftime('%A')
  end
end
