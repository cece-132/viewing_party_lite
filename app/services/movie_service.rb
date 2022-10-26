require 'faraday'
require 'json'

class MovieService

  def self.parse(response)
    JSON.parse(response, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.params["api_key"] = ENV["tmdb_api_key"]
    end
  end

  def self.get_movie_data(movie_id)
    response = conn.get("/3/movie/#{movie_id}?append_to_response=credits,reviews")
    parse(response.body)
  end

  def self.get_rated_movies_asc(page_number)
    response = conn.get("/3/movie/top_rated?language=en-US&page=#{page_number}")
    parse(response.body)
  end

  def self.search(search_params, page)
    response = conn.get("/3/search/movie?query=#{search_params}&page=#{page}")
    parse(response.body)
  end

  # def self.find_movie(id)
  #   response = conn.get("/movie/#{id}")
  #   parse(response.body)
  # end
end 