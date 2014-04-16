require_relative "../recommendation_engine/rmse_calculator"

describe RMSECalculator do
  context "::calculate" do
    it "calculates root mean squared error" do
      predicted_rating = [5, 3, 1, 2, 3]
      actual_ratings   = [4, 1, 1, 4, 3]
      rmse = RMSECalculator.calculate(predicted_rating, actual_ratings)
      rmse.should be_within(0.1).of(1.3)
    end
  end
end
