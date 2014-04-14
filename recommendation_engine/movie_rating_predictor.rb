require_relative "./cluster_engine"
require_relative "./data_extractor"
require_relative "./pearson_correlation_coefficient_calculator"

class MovieRatingPredictor
  def predict_movie_rate_for_user_by_pearson_correlation(user, movie)
    user_movie_ratings  = other_movie_ratings_by_user(user, movie)
    other_users_ratings = users_ratings_for_movie(movie).reject { |other_user, rate| other_user == user }
    correlation_weights = get_correlation_weight_with_other_users(user, user_movie_ratings, other_users_ratings)
    calculate_predicted_rating_from_correlation(correlation_weights, user_movie_ratings, other_users_ratings)
  end

  def predict_movie_rate_for_user_by_clustering(user, movie)
    user_movie_ratings = other_movie_ratings_by_user(user, movie)
    users_ratings      = users_ratings_for_movie(movie)
    similar_users      = get_similar_users_based_on_ratings(user, user_movie_ratings, users_ratings.keys)
    calculate_predicted_rating_from_cluster(users_ratings, similar_users)
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

  def get_correlation_weight_with_other_users(user, user_movie_ratings, other_users_ratings)
    @pearson_calculator = PearsonCorrelationCoefficientCalculator.new(
      user, user_movie_ratings, other_users_ratings)
    @pearson_calculator.calculate_weight_with_other_users
  end

  def calculate_predicted_rating_from_correlation(weights, user_movie_ratings, other_users_ratings)
    user_ratings_mean = @pearson_calculator.calculate_mean_of_rating(user_movie_ratings)
    user_ratings_mean + weighted_sum_of_ratings(weights, other_users_ratings)
  end

  def weighted_sum_of_ratings(weights, other_users_ratings)
    sum = 0
    weights.each do |user, weight|
      user_ratings_mean = @pearson_calculator.movie_ratings_mean_for_user(user)
      sum += weight * (other_users_ratings[user] - user_ratings_mean)
    end
    total_weight = weights.values.inject(0) { |sum, w| sum += w }
    sum / total_weight
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
    predictor = MovieRatingPredictor.new
    puts "#{movie} => #{predictor.predict_movie_rate_for_user_by_pearson_correlation("1003353", movie)}"
  end
end
