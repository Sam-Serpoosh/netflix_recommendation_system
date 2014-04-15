require_relative "../recommendation_engine/movie_rating_predictor_by_pearson_correlation"
require_relative "../recommendation_engine/movie_rating_predictor_by_clustering"


def movie_ratings_prediction_by_pearson_correlation_for_user(user, movies) 
  puts "Movie Rating Predictions For User #{user} By Pearson Correlation Coefficient"
  movies.each do |movie|
    predictor = MovieRatingPredictorByPearsonCorrelation.new
    puts "\t#{movie} => #{predictor.predict_movie_rating_for_user(user, movie)}"
  end
end

def movie_ratings_prediction_by_clustering_for_user(user, movies) 
  puts "Movie Rating Predictions For User #{user} By Clustering"
  movies.each do |movie|
    predictor = MovieRatingPredictorByClustering.new
    puts "\t#{movie} => #{predictor.predict_movie_rating_for_user(user, movie)}"
  end
end

def run_tests_for_user_and_movies(user, movies) 
  movie_ratings_prediction_by_pearson_correlation_for_user(user, movies)
  puts("=========================================================================")
  movie_ratings_prediction_by_clustering_for_user(user, movies)
  puts; puts
end

#run_tests_for_user_and_movies("2577095", ["0003320", "0006720", "0010225", "0011283"])
run_tests_for_user_and_movies("725544", ["0005317", "0006859", "0011149", "0012911", "0015764"])

# Potential Long Running Good Test
# 461371_ratings
