module ApplicationHelper
  def slack_authorization_url
    "https://slack.com/oauth/authorize?scope=#{['users.profile:read', 'chat:write:bot'].join(' ')}&client_id=#{ENV['SLACK_CLIENT_ID']}"
  end
end
