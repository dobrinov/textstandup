class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'landingpage'

  def landingpage
    redirect_to reports_path if user_signed_in?
  end

  def changelog
    render layout: 'application'
  end
end
