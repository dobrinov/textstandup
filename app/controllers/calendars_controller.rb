class CalendarsController < ApplicationController
  def index
    @calendar = Calendar.new current_user, Date.today.year, Date.today.month
  end
end
