require_relative "./movie_rating_predictor"
require_relative "./pearson_correlation_coefficient_calculator"

class MovieRatingPredictorByPearsonCorrelation < MovieRatingPredictor
  def initialize; end

  def predict_movie_rating_for_user(user, movie)
    user_movie_ratings  = other_movie_ratings_by_user(user, movie)
    other_users_ratings = users_ratings_for_movie(movie).reject { |other_user, rate| other_user == user }
    correlation_weights = get_correlation_weight_with_other_users(user, user_movie_ratings, other_users_ratings)
    calculate_predicted_rating_from_correlation(correlation_weights, user_movie_ratings, other_users_ratings)
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
    total_weight == 0 ? 0 : sum / total_weight
  end
end

movies = ["0008387", "0009049", "0010042", "0011283", "0012084", "0016139"]

if __FILE__ == $0
  movies.each do |movie|
    predictor = MovieRatingPredictorByPearsonCorrelation.new
    puts "#{movie} => #{predictor.predict_movie_rating_for_user("1003353", movie)}"
  end
end
