module InvitationLinkCreator
  extend self

  def execute(company, inviting_user)
    return unless company.administrated_by?(inviting_user)

    InvitationLink.create! company: company, inviting_user: inviting_user, code: SecureRandom.hex(6)
  end
end
