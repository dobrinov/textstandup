class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'landingpage', only: :landingpage

  def landingpage
    redirect_to reports_path if user_signed_in?
  end
end
