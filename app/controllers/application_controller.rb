class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def redirect_if_no_company
    redirect_to missing_company_path unless current_user.company
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
