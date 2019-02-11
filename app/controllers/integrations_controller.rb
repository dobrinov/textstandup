class IntegrationsController < ApplicationController
  def index
    @company = current_user.company
  end

  def slack_callback
    SlackInstaller.execute params[:code], current_user

    redirect_to integrations_path, notice: 'Slack integration successful'
  end

  def uninstall_slack
    SlackUninstaller.execute current_user

    redirect_to integrations_path, notice: 'Slack integration removed successful'
  end
end
