class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_one :employment
  has_one :company, through: :employment

  has_many :follower_subscriptions, class_name: 'Subscription', foreign_key: :followee_id
  has_many :followers, through: :follower_subscriptions

  has_many :followee_subscriptions, class_name: 'Subscription', foreign_key: :follower_id
  has_many :followees, through: :followee_subscriptions

  has_many :reports

  class << self
    def from_omniauth(access_token)
      email = access_token['extra']['id_info']['email']
      user = User.find_by email: email

      return user if user.present?

      create! email: email,
              first_name: access_token.info['first_name'],
              last_name: access_token.info['last_name'],
              password: Devise.friendly_token[0,20]
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def follows?(user)
    followee_subscription_for user
  end

  def followee_subscription_for(user)
    followee_subscriptions.find_by followee: user
  end
end
