class DataExtractor
  USER_RATINGS = "../sample_netflix_dataset/user_ratings/"
  
  def self.user_rating_for_movie(user, movie)
    command = %Q{ grep -m 1 "\\b#{movie}:" #{USER_RATINGS}#{user}_ratings }
    movie_rating = `#{command}`
    if movie_rating == ""
      return movie, 0
    else
      return movie_rating.split(":")[0], movie_rating.split(":")[1].to_i
    end
  end

  def self.movies_rated_by_user(user)
    command = %Q{ tail -n+2 #{USER_RATINGS}#{user}_ratings }
    ratings = `#{command}`.split("\n").select { |rating| rating =~ /.*:.*/ }
    ratings.each do |rating|
      yield rating.split(":")[0], rating.split(":")[1].to_i
    end
  end

  def self.user_ratings_for_movie(movie)
    command = %Q{ls #{USER_RATINGS} | while read rating_file; do grep -m 1 "\\b#{movie}:" #{USER_RATINGS}$rating_file /dev/null; done}
    users_ratings_info = `#{command}`.split("\n")
    users_ratings_info.each do |rating_info|
      user_id, rate = extract_user_id_and_rating_value(rating_info)
      yield user_id, rate
    end
  end

  def self.extract_user_id_and_rating_value(user_rating_file_and_rating_info)
    rating_filepath = user_rating_file_and_rating_info.split(":")[0]
    rate            = user_rating_file_and_rating_info.split(":")[2].to_i
    rating_filename = rating_filepath.split("/")[3]
    user_id         = rating_filename.gsub(/_ratings/, "")
    return user_id, rate
  end
end
