module SlackInstaller
  extend self

  def execute(code, user)
    raise UnauthorizedAction unless user.company.administrated_by? user

    client = Slack::Web::Client.new

    response =
      client.oauth_access(
        {
          client_id: ENV['SLACK_CLIENT_ID'],
          client_secret: ENV['SLACK_CLIENT_SECRET'],
          code: code
        }
      )

    raise "Cannot obtain access token: #{response.error}" unless response.ok?

    user.company.update! slack_access_token: response['access_token']
  end
end
