module InvitationLinkCreator
  extend self

  def execute(team, inviting_user)
    return unless team.administrated_by?(inviting_user)

    InvitationLink.create! team: team, inviting_user: inviting_user, code: SecureRandom.hex(6)
  end
end
