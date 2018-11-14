class MembershipsController < ApplicationController
  before_action :authorize

  def update
    team = find_team
    member = find_member
    membership = Membership.find_by! team: team, user: member

    if params[:promote]
      membership.update! admin: true
    end

    case params[:operation]
    when 'promote'
      membership.update! admin: true
    when 'revoke'
      membership.update! admin: false
    else
      raise "Unknown operation #{params[:operation]}"
    end

    redirect_back fallback_location: team_path(team)
  end

  def destroy
    team = find_team
    member = find_member

    if member == current_user
      leave_team
    else
      team.members.delete member
    end

    redirect_back fallback_location: team_path(team)
  end

  private

  def find_team
    current_user.teams.find params[:team_id]
  end

  def find_member
    find_team.members.find params[:id]
  end

  def authorize
    team = current_user.teams.find params[:team_id]
    member = team.members.find params[:id]

    redirect_back fallback_location: team_path(team) unless team.administrated_by?(current_user)
  end
end
