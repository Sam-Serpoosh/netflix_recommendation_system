class RatingPredictor
  def initialize
    @user_ratings_dir = "../sample_netflix_dataset/test_user_ratings/"
  end

  def predict(user, movie)
    users = users_rated_for_movie(movie)
    #users.each { |u| ratings_of_similar_movies_by_both_users(user, u) }
  end

  def users_rated_for_movie(movie)
    command = %Q{ls #{@user_ratings_dir} | while read rating_file; do grep -m 1 "\\b#{movie}:" #{@user_ratings_dir}$rating_file /dev/null; done}
    users = `#{command}`.split("\n")
    user_ids = []
    users.each do |user|
      rating_filepath = user.split(":")[0]
      rating_filename = rating_filepath.split("/")[3]
      user_ids << rating_filename.gsub(/_ratings/, "")
    end
    print user_ids
  end
end

RatingPredictor.new.users_rated_for_movie("00010")
