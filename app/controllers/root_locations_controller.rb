class RootLocationsController < ApplicationController
  def navigate
    path =
      if current_user.teams.empty?
        new_team_path
      else
        teams_path
      end

    redirect_to path
  end
end
