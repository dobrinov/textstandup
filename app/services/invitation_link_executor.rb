module InvitationLinkExecutor
  extend self

  def execute(invitation_link, user)
    ActiveRecord::Base.transaction do
      Membership.create! user: user, team: invitation_link.team, admin: false
      invitation_link.update! used_at: Time.current, invited_user: user
    end
  end
end
