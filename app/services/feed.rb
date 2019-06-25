class Feed
  def initialize(user:, selected_date: nil)
    @user = user
    @selected_date =
      if selected_date.present?
        parse_date selected_date
      else
        today
      end
  end

  def to_h
    {
      posting_allowed: posting_allowed,
      posts: posts,
      user: {
        name: @user.full_name,
        initials: @user.initials,
      }
    }
  end

  def posts
    followee_ids =
      Subscription.
        where(follower: @user).
        pluck(:followee_id)

    reports =
      Report.
        where(user_id: followee_ids + [@user.id]).
        where(created_at: beginning_of_selected_date..end_of_selected_date).
        order(created_at: :desc)

    reports.map { |report| ReportToJson.execute(report, @user) }
  end

  def posting_allowed
    @selected_date == today
  end

  def next_date
    @selected_date.tomorrow if today > @selected_date
  end

  def next_date_path
    return unless next_date.present?
    Rails.application.routes.url_helpers.reports_path date: next_date
  end

  def selected_date
    @selected_date.strftime '%d %b'
  end

  def prev_date
    @selected_date.yesterday
  end

  def prev_date_path
    return unless prev_date.present?
    Rails.application.routes.url_helpers.reports_path date: prev_date
  end

  private

  def time_zone
    ActiveSupport::TimeZone[@user.time_zone]
  end

  def now
    time_zone.now
  end

  def today
    now.to_date
  end

  def beginning_of_selected_date
    time_zone.parse "#{@selected_date} 00:00:00"
  end

  def end_of_selected_date
    time_zone.parse "#{@selected_date} 23:59:59"
  end

  def parse_date(date)
    if date.is_a? Date
      date
    elsif date.is_a? String
      Date.parse date
    else
      raise "Unsupported date class #{date.class}"
    end
  end
end
