# frozen_string_literal: true

class MoviesController < ApplicationController
  def show
    # @user = User.find(params[:user_id])
    @movie = MovieFacade.movie_details(params[:id])
  end
end
