require_relative "./data_extractor"

class MovieRatingPredictorByAverage
  def predict_movie_rating_for_user(user, movie)
    other_movie_ratings = get_other_movie_ratings_by_user(user, movie)
    other_users_ratings = get_other_users_ratings_for_movie(movie, user)
    other_movie_ratings.values.inject(0) { |sum, rate| sum += rate } / other_movie_ratings.count.to_f
  end

  def get_other_movie_ratings_by_user(user, movie)
    movie_ratings = {}
    DataExtractor.movie_ratings_by_user(user) do |other_movie, rate|
      movie_ratings[other_movie] = rate if other_movie != movie
    end
    movie_ratings
  end

  def get_other_users_ratings_for_movie(movie, user)
    user_ratings = {}
    DataExtractor.users_ratings_for_movie(movie) do |other_user, rate|
      user_ratings[other_user] = rate if other_user != user
    end
    user_ratings
  end
end
