module ReportSubscriptions
  extend self

  def all(user)
    followee_ids =
      Subscription.
        where(follower: user).
        pluck(:followee_id)

    reports =
      Report.
        where(user_id: followee_ids + [user.id]).
        order(created_at: :desc)

    reports.map { |report| ReportToJson.execute(report, user) }
  end
end
