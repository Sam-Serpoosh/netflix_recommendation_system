class ClusterEngine
  def initialize(user, user_movies_ratings, users_rated_the_movie)
    @user = user
    @user_movies_ratings = user_movies_ratings
    users_rated_the_movie.delete(@user)
    @other_users = users_rated_the_movie
    @user_ratings_dir = "../sample_netflix_dataset/user_ratings/"
  end

  def similar_users
    user_distances = {}
    @other_users.each do |user|
      movies_ratings = get_movie_ratings_of_user(user)
      user_distances[user] = euclidean_distance_of_users_based_on_ratings(movies_ratings)
    end
    user_distances
    # decide which half to return out of the distances as similar
  end

  def get_movie_ratings_of_user(user)
    movies = @user_movies_ratings.keys
    movies_ratings = {}
    movies.each do |movie|
      command = %Q{ grep -m 1 "\\b#{movie}:" #{@user_ratings_dir}/#{user}_ratings }
      movie_rating = `#{command}`
      movies_ratings[movie] = 0 if movie_rating == ""
      movie_id, rate = movie_rating.split(":")[0], movie_rating.split(":")[1].to_i
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
end

user_movie_ratings = {
  "0008387" => 3, "0009049" => 4, 
  "0010042" => 5, "0011283" => 5, 
  "0012084" => 4, "0016139" => 3
}

if __FILE__ == $0
  engine = ClusterEngine.new("1003353", user_movie_ratings, ["1003353", "1021494"])
  print engine.similar_users
  puts
end
