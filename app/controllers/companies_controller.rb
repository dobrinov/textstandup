class CompaniesController < ApplicationController
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

  def destroy
    current_user.company.destroy!

    redirect_to root_path
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end
end
