class SlackNotifier
  User = Struct.new :id, :full_name, :username, :avatar_url, keyword_init: true

  class << self
    def execute(report)
      new(report).execute
    end
  end

  def initialize(report)
    @report = report
    @slack = SlackApi.new report.user.company.slack_access_token
  end

  def execute
    sender = slack_user_by_username @report.user.slack_handle

    return unless sender.present?

    @report.user.followers.each do |follower|
      recipient = slack_user_by_username follower.slack_handle

      next unless recipient.present?

      @slack.send_message receiver_channel: recipient.id, attachments: attachments(sender)
    end
  end

  private

  def slack_user_by_username(username)
    slack_user = @slack.find_user_by username

    return unless slack_user.present?

    User.new id: slack_user.id,
             full_name: slack_user.profile.real_name,
             username: slack_user.profile.display_name,
             avatar_url: slack_user.profile.image_48
  end

  def attachments(sender)
    items = @report.items.group_by &:type

    attachments =
      attachment_settings.
        select { |type, _| items[type].present? }.
        map do |type, section|
          fields = items[type].map { |item| {title: item.title, value: item.description}}

          section.merge({fields: fields})
        end

    [author_attachment(sender)] + attachments
  end

  def author_attachment(sender)
    {
      author_name: sender.full_name,
      author_icon: sender.avatar_url,
    }
  end

  def attachment_settings
    {
      'OngoingReportItem'      => {title: 'CURRENT PROGRESS'},
      'PlannedReportItem'      => {title: 'PLAN FOR THE DAY'},
      'BlockerReportItem'      => {title: 'BLOCKERS', color: 'danger'},
      'AnnouncementReportItem' => {title: 'ANNOUNCEMENTS'},
      'DeliveredReportItem'    => {title: 'DELIVERED', color: 'good'},
    }
  end
end
