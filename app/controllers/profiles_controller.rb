class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update user_params
      redirect_to profile_path, notice: 'Profile updated successfully'
    else
      render :show
    end
  end

  def destroy
    current_user.destroy
    sign_out :user

    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit :first_name, :last_name, :time_zone, :slack_handle
  end
end
