module SubscriptionReport
  extend self

  def all(follower)
    followee_ids = Subscription.where(follower: follower).pluck(:followee_id)

    Report.where(user_id: followee_ids + [follower.id]).order created_at: :desc
  end
end
