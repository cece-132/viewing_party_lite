# frozen_string_literal: true

class MoviesController < ApplicationController
  before_action :require_user
  def show
    # @user = User.find(params[:user_id])
    @movie = MovieFacade.movie_details(params[:id])
  end
end
