class TeamsController < ApplicationController
  def index
    @teams = current_user.teams
    @invite = TeamInvite.new
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new team_params

    ActiveRecord::Base.transaction do
      if @team.save && current_user.teams << @team
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
