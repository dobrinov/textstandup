class SubscriptionsController < ApplicationController
  def create
    user = current_user.company.employees.find params[:user_id]
    Subscription.create! follower: current_user, followee: user

    redirect_back fallback_location: employees_path
  end

  def destroy
    Subscription.find_by!(follower: current_user, id: params[:id]).destroy!

    redirect_back fallback_location: employees_path
  end
end
