require_relative "../recommendation_engine/cluster_engine"

describe ClusterEngine do
  context ".euclidean_distance_of_users_based_on_ratings" do
    let(:user_movie_ratings) do
      {
        "movie1" => 2, 
        "movie2" => 1, 
        "movie3" => 4
      }
    end

    it "calculates distance based on movie ratings" do
      other_user_ratings = { "movie1" => 1, "movie2" => 3, "movie3" => 2 }
      cluster_engine = ClusterEngine.new(double, user_movie_ratings, [])
      distance = cluster_engine.
        euclidean_distance_of_users_based_on_ratings(other_user_ratings)
      distance.should == 3
    end

    it "ignores the 0 ratings" do
      other_user_ratings = { "movie1" => 0, "movie2" => 0, "movie3" => 3 }
      cluster_engine = ClusterEngine.new(double, user_movie_ratings, [])
      distance = cluster_engine.
        euclidean_distance_of_users_based_on_ratings(other_user_ratings)
      distance.should == 1
    end
  end
end
