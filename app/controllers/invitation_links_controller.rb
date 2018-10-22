class InvitationLinksController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :redirect_unless_active, only: %i(show use)
  before_action :redirect_if_already_member, only: %i(show use)

  def show
    @invitation_link = InvitationLink.find_by! code: params[:code]
    @current_path = invitation_link_path code: @invitation_link.code
  end

  def create
    team = current_user.teams.find params[:team_id]
    invitation_link = InvitationLinkCreator.execute team, current_user

    render json: {url: invitation_link_url(code: invitation_link.code)}
  end

  def use
    invitation_link = InvitationLink.find_by! code: params[:code]

    InvitationLinkExecutor.execute invitation_link, current_user

    redirect_to teams_path, notice: "Successfully joined team '#{invitation_link.team.name}'"
  end

  private

  def redirect_unless_active
    invitation_link = InvitationLink.find_by! code: params[:code]

    redirect_to(root_path, alert: 'Invitation link is not active anymore.') unless invitation_link.active?
  end

  def redirect_if_already_member
    invitation_link = InvitationLink.find_by! code: params[:code]

    if Membership.where(team: invitation_link.team, user: current_user).exists?
      redirect_to(root_path, alert: 'You are already a member of this team.')
    end
  end
end
