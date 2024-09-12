# frozen_string_literal: true

class LandingController < ApplicationController

    def index
      @user = current_user
      @users = User.all
    end
    
    def about
    end
end
