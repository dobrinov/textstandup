class CompaniesController < ApplicationController
  before_action :authorize_company_administrator, only: %i(show update)

  def missing
    redirect_to employees_path if current_user.company.present?
  end

  def show
    @company = current_user.company
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new company_params

    ActiveRecord::Base.transaction do
      if @company.save && Employment.create!(company: @company, user: current_user, admin: true)
        redirect_to employees_path
      else
        render :new
      end
    end
  end

  def update
    @company = current_user.company

    if @company.update company_params
      redirect_to company_path, notice: 'Company updated successfully'
    else
      render :show
    end
  end

  def destroy
    current_user.company.destroy!

    redirect_to missing_company_path
  end

  private

  def authorize_company_administrator
    redurect_to root_path unless current_user.company.administrated_by?(current_user)
  end

  def company_params
    params.require(:company).permit(:name)
  end
end
