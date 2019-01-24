class EmployeesController < ApplicationController
  before_action :redirect_if_no_company

  def index
    @company = current_user.company
    @employees = @company.employees
  end
end
