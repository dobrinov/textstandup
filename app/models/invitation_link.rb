class InvitationLink < ApplicationRecord
  VALIDITY = 3.days

  belongs_to :company
  belongs_to :inviting_user, class_name: 'User'
  belongs_to :invited_user, class_name: 'User', optional: true

  validates :code, presence: true

  def active?
    used_at.blank? && !expired?
  end

  def expired?
    Time.current - VALIDITY > created_at
  end
end
