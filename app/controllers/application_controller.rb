class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def redirect_if_no_company
    redirect_to missing_company_path unless current_user.company
  end
end
