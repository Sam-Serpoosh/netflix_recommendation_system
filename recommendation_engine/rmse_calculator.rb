class RMSECalculator
  def self.calculate(predicted_ratings, actual_ratings)
    squared_sum = 0
    predicted_ratings.each_with_index do |rate, index|
      squared_sum += (rate - actual_ratings[index]) ** 2
    end
    avg_squared_error = squared_sum / predicted_ratings.count.to_f
    Math.sqrt(avg_squared_error)
  end
end
