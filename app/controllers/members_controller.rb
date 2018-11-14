class MembersController < ApplicationController
  before_action :authorize

  def destroy
    team = current_user.teams.find params[:team_id]
    member = team.members.find params[:id]

    if member == current_user
      leave_team
    else
      team.members.delete member
    end

    redirect_back fallback_location: team_path(team)
  end

  private

  def authorize
    team = current_user.teams.find params[:team_id]
    member = team.members.find params[:id]

    redirect_back fallback_location: team_path(team) unless team.administrated_by?(current_user)
  end
end
