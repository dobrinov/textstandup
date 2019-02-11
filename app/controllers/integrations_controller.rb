class IntegrationsController < ApplicationController
  def index
    @company = current_user.company
  end

  def slack_callback
    if params[:code].present?
      SlackInstaller.execute params[:code], current_user
      redirect_to integrations_path, notice: 'Slack integration successful'
    else
      redirect_to integrations_path, alert: 'Slack integration was not successful'
    end
  end

  def uninstall_slack
    SlackUninstaller.execute current_user

    redirect_to integrations_path, notice: 'Slack integration removed successful'
  end
end
