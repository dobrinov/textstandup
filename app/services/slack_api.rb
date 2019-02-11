class SlackApi
  def initialize(access_token)
    @client = Slack::Web::Client.new token: access_token
  end

  def send_message(receiver_channel:, attachments: [])
    @client.chat_postMessage channel: receiver_channel,
                             mrkdwn: true,
                             as_user: false,
                             attachments: attachments
  end

  def find_user_by(username)
    @client.
      users_list.
      members.
      select { |member| member.profile.display_name == username }.
      first
  end
end
