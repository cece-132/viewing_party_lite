class ViewingPartiesController < ApplicationController

  def new
    @user = User.find(params[:user_id])
    @viewing_party = ViewingParty.new
    @movie = Movie.new(MovieService.get_movie_data(params[:movie_id]))
    @all_other_users = User.all.where.not("id = ?", params[:user_id])
  end

  def create
    @viewing_party = ViewingParty.new(viewing_party_params)
    @user = User.find(params[:user_id])
    if @viewing_party.save
      params[:viewing_party][:invited_users].each do |user_id|
        ViewingPartyUser.create!(viewing_party_id: @viewing_party.id, user_id: user_id) if User.find(user_id)
      end
      redirect_to user_path
    else
      redirect_to new_user_movie_viewing_party_path(@user, @viewing_party.movie_id)
      flash[:alert] = @user.errors.full_messages.to_sentence
    end
  end

  private

  def viewing_party_params
    params[:viewing_party][:start_time] = Time.new(params[:start]["date(1i)"].to_i,
                                                    params[:start]["date(2i)"].to_i,
                                                    params[:start]["date(3i)"].to_i,
                                                    params[:start]["time(4i)"].to_i,
                                                    params[:start]["time(5i)"].to_i)
    params.require(:viewing_party).permit(:host, :image_path, :movie_title, :start_time, :duration, :movie_id)
  end
end
