require_relative "../recommendation_engine/movie_rating_predictor"

class MovieRatingPredictorDummy < MovieRatingPredictor
  def initialize; end
end

describe MovieRatingPredictorDummy do
  # DataExtractor has been Mocked here!
  context ".other_movie_ratings_by_user" do
    it "fills info of movie ratings by given user" do
      movie_ratings = subject.other_movie_ratings_by_user(double, "movie10")
      movie_ratings.should == { "movie1" => 1, "movie2" => 5, "movie3" => 3 }
    end 

    it "gets rid of the movie it wants to predict" do
      movie_ratings = subject.other_movie_ratings_by_user(double, "movie3")
      movie_ratings.should == { "movie1" => 1, "movie2" => 5 }
    end
  end

  context ".users_ratings_for_movie" do
    it "fills info about users ratings for a given movie" do
      users_ratings = subject.users_ratings_for_movie(double)
      users_ratings.should == { "user1" => 2, "user2" => 4 }
    end
  end
end

class DataExtractor
  def self.movies_rated_by_user(user)
    yield "movie1", 1
    yield "movie2", 5
    yield "movie3", 3
  end

  def self.user_ratings_for_movie(movie) 
    yield "user1", 2
    yield "user2", 4
  end
end
