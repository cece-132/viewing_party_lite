class DashboardController < ApplicationController
  before_action :require_user, on: [:show]
  def show
  end

  def index
    session.delete(:user_id)
  end

end