require_relative "../recommendation_engine/cluster_engine"

class DataExtractor; end

describe ClusterEngine do
  let(:user_movie_ratings) do
    {
      "movie1" => 2, 
      "movie2" => 1, 
      "movie3" => 4
    }
  end
  let(:cluster_engine) { ClusterEngine.new(double, user_movie_ratings, []) }

  context ".euclidean_distance_of_users_based_on_ratings" do
    it "calculates distance based on movie ratings" do
      other_user_ratings = { "movie1" => 1, "movie2" => 3, "movie3" => 2 }
      distance = cluster_engine.
        euclidean_distance_of_users_based_on_ratings(other_user_ratings)
      distance.should == 3
    end

    it "ignores the 0 ratings" do
      other_user_ratings = { "movie1" => 0, "movie2" => 0, "movie3" => 3 }
      distance = cluster_engine.
        euclidean_distance_of_users_based_on_ratings(other_user_ratings)
      distance.should == 1
    end
  end

  context ".get_movie_ratings_of_user" do
    before do
      DataExtractor.stub(:user_rating_for_movie) { [nil, 0] }
    end

    it "fills the info about movie ratings of the given user" do
      user = double
      user_movie_ratings.keys.each do |movie|
        DataExtractor.should_receive(:user_rating_for_movie).
          with(user, movie) { [movie, 1] }
      end
      movie_ratings = cluster_engine.get_movie_ratings_of_user(user)
      movie_ratings.should == { "movie1" => 1, "movie2" => 1, "movie3" => 1 }
    end

    it "gets rid of the nil movie ids" do
      movie_ratings = cluster_engine.get_movie_ratings_of_user(double)
      movie_ratings.count.should == 0
    end
  end

  context ".get_closer_half_users" do
    let(:user_distances) do
      {
        "1" => 20, 
        "2" => 10, 
        "3" => 5, 
        "4" => 7, 
        "5" => 15
      }
    end

    it "returns the closer users" do
      closer_users = cluster_engine.get_closer_half_users(user_distances)
      closer_users.should == ["3", "4", "2"]
    end
  end
end
