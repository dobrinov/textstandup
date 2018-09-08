class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :daily_reports

  class << self
    def todays_update
      daily_reports.where date: Date.today
    end
  end

  def last_daily_report
    today = Date.today

    daily_reports.
      where('year <= ?', today.year).
      where('month <= ?', today.month).
      where('day < ?', today.day).
      order(year: :asc, month: :asc, day: :asc).
      last
  end
end
