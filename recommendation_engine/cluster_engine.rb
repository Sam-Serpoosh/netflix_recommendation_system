class ClusterEngine
  def initialize(user, user_movies_ratings, users_rated_the_movie)
    @user = user
    @user_movies_ratings = user_movies_ratings
    users_rated_the_movie.delete(@user)
    @other_users = users_rated_the_movie
  end

  def similar_users
    user_distances = {}
    @other_users.each do |user|
      movies_ratings = get_movie_ratings_of_user(user)
      user_distances[user] = euclidean_distance_of_users_based_on_ratings(movies_ratings)
    end
    get_closer_half_users(user_distances)
  end

  def get_movie_ratings_of_user(user)
    movies = @user_movies_ratings.keys
    movies_ratings = {}
    movies.each do |movie|
      movie_id, rate = DataExtractor.user_rating_for_movie(user, movie)
      movies_ratings[movie_id] = rate
    end
    movies_ratings.reject { |movie, rate| movie.nil? }
  end

  def euclidean_distance_of_users_based_on_ratings(movies_ratings)
    sum = 0
    @user_movies_ratings.each do |movie, rate|
      next if rate == 0 || movies_ratings[movie] == 0
      sum += (rate - movies_ratings[movie]).abs ** 2
    end
    Math.sqrt(sum)
  end

  def get_closer_half_users(user_distances)
    sorted_user_distances = user_distances.sort_by { |key, value| value }
    users = sorted_user_distances.map { |user_distance| user_distance[0] }
    users[0..(users.count / 2)]
  end
end
