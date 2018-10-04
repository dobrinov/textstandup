class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :daily_reports

  class << self
    def todays_update
      daily_reports.where date: Date.today
    end

    def from_omniauth(access_token)
      data = access_token.info
      user = User.find_by email: data['email']

      return user if user.present?

      create! email: data['email'], password: Devise.friendly_token[0,20]
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
