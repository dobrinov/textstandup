class RootLocationsController < ApplicationController
  def navigate
    path =
      if current_user.company
        reports_path
      else
        new_company_path
      end

    redirect_to path
  end
end
