class DashboardController < ApplicationController
  # GET /
  def show
    @page = ShowDashboardPage.new
  end
end
