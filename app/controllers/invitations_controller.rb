class InvitationsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :redirect_unless_active, only: %i(show use)
  before_action :redirect_if_already_employee, only: %i(show use)

  def show
    @invitation_link = InvitationLink.find_by! code: params[:code]
    @current_path = invitation_path code: @invitation_link.code
  end

  def create
    company = current_user.company
    invitation_link = InvitationLinkCreator.execute company, current_user

    render json: {url: invitation_url(code: invitation_link.code)}
  end

  def use
    invitation_link = InvitationLink.find_by! code: params[:code]

    InvitationLinkExecutor.execute invitation_link, current_user

    redirect_to root_path, notice: "Successfully joined company '#{invitation_link.company.name}'"
  end

  private

  def redirect_unless_active
    invitation_link = InvitationLink.find_by! code: params[:code]

    redirect_to(root_path, alert: 'Invitation link is not active anymore.') unless invitation_link.active?
  end

  def redirect_if_already_employee
    invitation_link = InvitationLink.find_by! code: params[:code]

    if Employment.where(company: invitation_link.company, user: current_user).exists?
      redirect_to(root_path, alert: 'You are already an employee of this company.')
    end
  end
end
