class TeamsController < ApplicationController
  def index
    if current_user.teams.any?
      redirect_to team_path current_user.teams.first
    else
      redirect_to new_team_path
    end
  end

  def show
    @teams = current_user.teams
    @team = @teams.find params[:id]
  end

  def new
    @teams = current_user.teams
    @team = Team.new
  end

  def create
    @teams = current_user.teams
    @team = Team.new team_params

    ActiveRecord::Base.transaction do
      if @team.save && Membership.create!(team: @team, user: current_user, admin: true)
        redirect_to team_path(@team), notice: 'Team created'
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
