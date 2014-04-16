require_relative "./data_extractor"

class MovieRatingPredictorByAverage
  def predict_movie_rating_for_user(user, movie)
    other_movie_ratings = get_other_movie_ratings_by_user(user)
    # other_users_ratings = get_other_users_ratings_for_movie(movie)
    # average of some kind
  end

  def get_other_movie_ratings_by_user(user, movie)
    movie_ratings = {}
    DataExtractor.movie_ratings_by_user(user) do |movie, rate|
      movie_ratings[movie] = rate
    end
    movie_ratings
  end

#  def get_other_users_ratings_for_movie(movie, user)
#    user_ratings = {}
#    DataExtractor.users_ratings_for_movie(movie) do |user, rate|
#      user_ratings[user] = rate
#    end
#    user_ratings
#  end
end

print MovieRatingPredictorByAverage.new.get_other_movie_ratings_by_user("699878", "0000010")
