# frozen_string_literal: true

class ApplicationController < ActionController::Base

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    if current_user
      @user = current_user
    else
      flash[:error] = "Please login"
      redirect_to "/"
    end
  end

end
