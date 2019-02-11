module SlackUninstaller
  extend self

  def execute(user)
    raise UnauthorizedAction unless user.company.administrated_by? user

    user.company.update! slack_access_token: nil
  end
end
