require_relative "../recommendation_engine/pearson_correlation_coefficient_calculator"

describe PearsonCorrelationCoefficientCalculator do
  let(:user_movie_ratings) do
    {
      "movie1" => 1, 
      "movie2" => 3,
      "movie3" => 2, 
      "movie4" => 5
    }
  end
  let(:pearson_calculator) do 
    PearsonCorrelationCoefficientCalculator.new(double, user_movie_ratings, {})
  end

  context ".get_movies_rated_by_both_users"do
    it "returns common movies rated by both users" do
      other_user_movie_ratings = { "movie1" => 3, "movie4" => 2, "movie3" => 0 }
      common_movies = pearson_calculator.
        get_movies_rated_by_both_users(other_user_movie_ratings)
      common_movies.should == ["movie1", "movie4"]
    end
  end

  context ".get_common_movie_ratings" do
    it "filters out uncommon movies from movie ratings of users" do
      other_user_movie_ratings = { "movie1" => 3, "movie4" => 2, "movie10" => 2 }
      common_movies = ["movie1", "movie4"]
      user_movie_ratings, other_user_movie_ratings = pearson_calculator.
        get_common_movie_ratings(common_movies, other_user_movie_ratings)
      user_movie_ratings.should == { "movie1" => 1, "movie4" => 5 }
      other_user_movie_ratings.should == { "movie1" => 3, "movie4" => 2 }
    end
  end

  context ".numerator" do
    it "returns the numerator of pearson correlation coefficient formula" do
      user_movie_ratings = { "movie1" => 2, "movie2" => 4 }
      other_user_movie_ratings = { "movie1" => 1, "movie2" => 3 }
      numerator = pearson_calculator.numerator(user_movie_ratings, other_user_movie_ratings)
      numerator.should == 2
    end
  end

  context ".denominator" do
    it "returns the denominator of perason correlation coefficient formula" do
      user_movie_ratings = { "movie1" => 2, "movie2" => 4 }
      other_user_movie_ratings = { "movie1" => 1, "movie2" => 5 }
      denominator = pearson_calculator.denominator(user_movie_ratings, other_user_movie_ratings)
      denominator.should == 4
    end
  end

  context ".calculate_mean_of_rating" do
    it "returns mean of ratings by a user" do
      mean = pearson_calculator.calculate_mean_of_rating(user_movie_ratings)
      mean.should == 2.75
    end
  end
end
