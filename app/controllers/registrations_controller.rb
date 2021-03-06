class RegistrationsController < Devise::RegistrationsController
  def new
    self.resource = resource_class.new {}
    store_location_for resource, params[:redirect_to]
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end
