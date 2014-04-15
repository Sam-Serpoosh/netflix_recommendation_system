require_relative "./data_extractor"

class MovieRatingPredictor
  def initialize
    raise "Cannot Instantiate Me!"
  end

  def other_movie_ratings_by_user(user, movie)
    movies_ratings = {}
    DataExtractor.movies_rated_by_user(user) do |movie_id, rate|
      movies_ratings[movie_id] = rate
    end
    movies_ratings.reject { |movie_id, rate| movie_id == movie }
  end

  def users_ratings_for_movie(movie)
    users_ratings = {}
    DataExtractor.user_ratings_for_movie(movie) do |user_id, rate|
      users_ratings[user_id] = rate
    end
    users_ratings
  end
end
