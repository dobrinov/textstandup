class EmployeesController < ApplicationController
  before_action :redirect_if_no_company

  def index
    @company = current_user.company
    @employees = @company.employees
  end

  private

  def redirect_if_no_company
    redirect_to new_company_path unless current_user.company
  end
end
