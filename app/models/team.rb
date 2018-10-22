class Team < ApplicationRecord
  validates :name, presence: true

  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :invitation_links

  def admins
    members.where memberships: {admin: true}
  end

  def administrated_by?(user)
    admins.where(memberships: {user: user}).exists?
  end
end
