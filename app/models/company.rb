class Company < ApplicationRecord
  validates :name, presence: true

  has_many :employments
  has_many :employees, through: :employments, source: :user
  has_many :invitation_links

  def admins
    employees.where employments: {admin: true}
  end

  def administrated_by?(user)
    admins.where(employments: {user: user}).exists?
  end
end
