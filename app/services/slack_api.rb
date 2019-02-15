class SlackApi
  def initialize(access_token)
    @client = Slack::Web::Client.new token: access_token
  end

  def send_message(channel:, attachments: [])
    @client.chat_postMessage channel: channel, mrkdwn: true, as_user: false, attachments: attachments
  end

  def workspace_members
    @client.users_list.members
  end

  def find_workspace_member_by(username)
    workspace_members.
      select { |member| member.profile.display_name == username }.
      first
  end

  def direct_message_channel_for(username)
    find_workspace_member_by(username).id
  end
end
