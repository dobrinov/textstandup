class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :daily_reports
  has_and_belongs_to_many :teams, join_table: 'members_teams', foreign_key: 'member_id'
  has_and_belongs_to_many :administrated_teams, join_table: 'admins_teams', foreign_key: 'admin_id'

  class << self
    def todays_update
      daily_reports.where date: Date.today
    end

    def from_omniauth(access_token)
      data = access_token.info
      user = User.find_by email: data['email']

      return user if user.present?

      create! email: data['email'],
              first_name: data['first_name'],
              last_name: data['last_name'],
              password: Devise.friendly_token[0,20]
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
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
