require_relative "../recommendation_engine/movie_rating_predictor_by_clustering"

describe MovieRatingPredictorByClustering do 
  context ".calculate_predicted_rating_from_cluster" do
    let(:users_ratings) do
      {
        "user1" => 2,
        "user2" => 5, 
        "user3" => 1,
        "user4" => 3
      }
    end
    let(:similar_users) { ["user1", "user3"] }

    it "calculates predicted rating based on given user ratings" do
      predicted_rating = subject.
        calculate_predicted_rating_from_cluster(users_ratings, similar_users)
      predicted_rating.should == 1.5
    end
  end
end
