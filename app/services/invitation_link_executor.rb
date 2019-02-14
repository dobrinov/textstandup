module InvitationLinkExecutor
  extend self

  def execute(invitation_link, user)
    ActiveRecord::Base.transaction do
      user.employment.destroy! if user.company.present?

      Employment.create! user: user, company: invitation_link.company, admin: false
      invitation_link.update! used_at: Time.current, invited_user: user

      user.company = invitation_link.company
    end
  end
end
