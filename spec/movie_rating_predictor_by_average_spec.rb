require_relative "../recommendation_engine/movie_rating_predictor_by_average"

describe MovieRatingPredictorByAverage do
  context ".get_other_movie_ratings_by_user" do
    it "gets movie ratings by user OTHER than the one under prediction" do
      movie_ratings = subject.get_other_movie_ratings_by_user("foo user", "bar")
      movie_ratings.should == { "baz" => 1, "lorem" => 4 }
    end
  end

  context ".get_other_users_ratings_for_movie" do
    it "get ratings of other users for the movie under prediction" do
      users_ratings = subject.get_other_users_ratings_for_movie("bar", "foo user")
      users_ratings.should == { "bob" => 2, "alice" => 4 }
    end
  end
end

class DataExtractor
  def self.movie_ratings_by_user(user)
    yield "baz",   1
    yield "bar",   3
    yield "lorem", 4
  end

  def self.users_ratings_for_movie(movie)
    yield "bob",      2
    yield "alice",    4
    yield "foo user", 3
  end
end
