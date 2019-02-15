class SlackNotifier
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
    return unless slack_installed?
    return unless sender.slack_handle.present?

    sender.followers.each { |follower| send_notification_to follower }
  end

  private

  def sender
    @report.user
  end

  def slack_installed?
    @report.user.company.slack_installed?
  end

  def send_notification_to(recipient)
    return unless recipient.slack_handle.present?

    unless recipient.slack_direct_message_channel.present?
      recipient.update! slack_direct_message_channel: @slack.direct_message_channel_for(recipient.slack_handle)
    end

    @slack.send_message channel: recipient.slack_direct_message_channel, attachments: attachments
  end

  def attachments
    items = @report.items.group_by &:type

    attachments =
      attachment_settings.
        select { |type, _| items[type].present? }.
        map do |type, section|
          fields = items[type].map { |item| {title: item.title, value: item.description}}

          section.merge({fields: fields})
        end

    [author_attachment] + attachments
  end

  def author_attachment
    unless sender.slack_avatar_url.present?
      sender.update! slack_avatar_url: @slack.find_workspace_member_by(sender.slack_handle).profile.image_48
    end

    {
      author_name: sender.full_name,
      author_icon: sender.slack_avatar_url,
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
