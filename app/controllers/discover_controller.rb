# frozen_string_literal: true

class DiscoverController < ApplicationController
  before_action :require_user

  def search
    # @user = current_user
    @top_movies = []
    @movies = []
    @search = ""
    if params[:format] == 'top_rated'
      @top_movies = MovieFacade.top_40_movies
    elsif params[:query].present?
      if MovieFacade.search_first_40(params[:query]).empty?
        @movies = ["No Movies Found, Please Try Again"]
        @search = params[:query]
      else
        @movies = MovieFacade.search_first_40(params[:query])
        @search = params[:query]
      end
    end
  end

end
