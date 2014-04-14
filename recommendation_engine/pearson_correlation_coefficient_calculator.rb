class PearsonCorrelationCoefficientCalculator
  def initialize(user, user_movie_ratings, other_users_ratings_for_movie)
    @user = user
    @user_movie_ratings = user_movie_ratings 
    @other_users_ratings_for_movie = other_users_ratings_for_movie.reject { |other_user, rate| other_user == @user }
    @other_users = @other_users_ratings_for_movie.keys
    @other_users_ratings_means = {}
  end

  def predict_rating
    weights = calculate_weight_with_other_users
    user_rating_mean = calculate_mean_of_rating(@user_movie_ratings)
    predicted_rate = user_rating_mean
    weights.each do |user, weight|
      predicted_rate += weight * (@other_users_ratings_for_movie[user] - @other_users_ratings_means[user])
    end
    predicted_rate
  end

  def calculate_weight_with_other_users
    weights = {}
    @other_users.each do |user|
      weights[user] = calculate_weight_with_user(user)
    end
    weights.reject { |user, w| w.nan? }
  end

  def calculate_weight_with_user(user)
    other_user_movie_ratings = get_movie_ratings_of_user(user)
    common_movies = get_movies_rated_by_both_users(other_user_movie_ratings)
    user_movie_ratings, other_user_movie_ratings = get_common_movie_ratings(
      common_movies, other_user_movie_ratings) 
    @other_users_ratings_means[user] = calculate_mean_of_rating(other_user_movie_ratings)
    numerator(user_movie_ratings, other_user_movie_ratings) / 
      denominator(user_movie_ratings, other_user_movie_ratings)
  end

  def get_movie_ratings_of_user(user)
    movies = @user_movie_ratings.keys
    movies_ratings = {}
    movies.each do |movie|
      movie_id, rate = DataExtractor.user_rating_for_movie(user, movie)
      movies_ratings[movie_id] = rate
    end
    movies_ratings.reject { |movie, rate| movie.nil? }
  end

  def get_movies_rated_by_both_users(other_user_movie_ratings)
    common_movies = []
    @user_movie_ratings.each do |movie, rate|
      next if rate == 0 || !other_user_movie_ratings.has_key?(movie) || 
        other_user_movie_ratings[movie] == 0 
      common_movies << movie
    end
    common_movies
  end

  def get_common_movie_ratings(common_movies, other_user_movie_ratings)
    user_movie_ratings = @user_movie_ratings.select do 
      |movie, rate| common_movies.include?(movie)
    end
    other_user_movie_ratings = other_user_movie_ratings.select do |movie, rate| 
      common_movies.include?(movie)
    end
    return user_movie_ratings, other_user_movie_ratings
  end

  def numerator(user_movie_ratings, other_user_movie_ratings)
    user_rating_mean = calculate_mean_of_rating(user_movie_ratings)
    other_user_rating_mean = calculate_mean_of_rating(other_user_movie_ratings)
    sum = 0
    user_movie_ratings.each do |movie, rate|
      sum += (rate - user_rating_mean) * (other_user_movie_ratings[movie] - other_user_rating_mean)
    end
    sum
  end

  def denominator(user_movie_ratings, other_user_movie_ratings)
    user_rating_mean = calculate_mean_of_rating(user_movie_ratings)
    other_user_rating_mean = calculate_mean_of_rating(other_user_movie_ratings)
    sum_squared_for_user, sum_squared_for_other_user = 0, 0
    user_movie_ratings.each do |movie, rate|
      sum_squared_for_user       += (rate - user_rating_mean) ** 2
      sum_squared_for_other_user += (other_user_movie_ratings[movie] - other_user_rating_mean) ** 2
    end
    Math.sqrt(sum_squared_for_user * sum_squared_for_other_user)
  end

  def calculate_mean_of_rating(movie_ratings) 
    sum = 0
    movie_ratings.each { |movie, rating| sum += rating }
    sum / movie_ratings.count.to_f
  end
end
