require_relative "./movie_rating_predictor"
require_relative "./cluster_engine"

class MovieRatingPredictorByClustering < MovieRatingPredictor
  def initialize; end

  def predict_movie_rating_for_user(user, movie)
    user_movie_ratings  = other_movie_ratings_by_user(user, movie)
    other_users_ratings = users_ratings_for_movie(movie).reject { |other_user, rate| other_user == user }
    similar_users       = get_similar_users_based_on_ratings(user, user_movie_ratings, other_users_ratings.keys)
    calculate_predicted_rating_from_cluster(other_users_ratings, similar_users)
  end

  def get_similar_users_based_on_ratings(user, user_movie_ratings, other_users)
    cluster_engine = ClusterEngine.new(user, user_movie_ratings, other_users)
    cluster_engine.similar_users
  end

  def calculate_predicted_rating_from_cluster(users_ratings, similar_users)
    sum = 0
    similar_users.each { |user_id| sum += users_ratings[user_id] }
    sum / similar_users.count.to_f
  end
end

movies = ["0008387", "0009049", "0010042", "0011283", "0012084", "0016139"]

if __FILE__ == $0
  movies.each do |movie|
    predictor = MovieRatingPredictorByClustering.new
    puts "#{movie} => #{predictor.predict_movie_rating_for_user("1003353", movie)}"
  end
end
