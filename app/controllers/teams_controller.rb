class TeamsController < ApplicationController
  def index
    @teams = current_user.teams
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new team_params

    ActiveRecord::Base.transaction do
      if @team.save && Membership.create!(team: @team, user: current_user, admin: true)
        redirect_to teams_path, notice: 'Team created'
      else
        render :new
      end
    end
  end

  def destroy
    current_user.teams.find(params[:id]).destroy!

    redirect_to teams_path
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
