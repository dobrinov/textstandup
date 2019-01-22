class EmploymentsController < ApplicationController
  before_action :authorize

  def update
    employment = current_user.company.employments.find params[:id]

    case params[:operation]
    when 'promote'
      employment.update! admin: true
    when 'revoke'
      employment.update! admin: false
    else
      raise "Unknown operation #{params[:operation]}"
    end

    redirect_back fallback_location: employees_path
  end

  def destroy
    company = current_user.company
    employment = company.employments.find params[:id]

    if employment.user == current_user && company.administrated_by?(current_user)
      raise 'Not allowed yet'
    else
      employment.destroy
    end

    redirect_back fallback_location: employees_path
  end

  private

  def authorize
    company = current_user.company
    employment = company.employments.find params[:id]

    unless employment.user == current_user || company.administrated_by?(current_user)
      redirect_back fallback_location: employees_path unless company.administrated_by?(current_user)
    end
  end
end
