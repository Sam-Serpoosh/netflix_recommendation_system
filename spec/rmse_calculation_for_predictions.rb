require_relative "../recommendation_engine/rmse_calculator"

def calculate_rmse_for_user_and_approach(approach_name, predicted_ratings, actual_ratings)
  puts "RMSE For Approach #{approach_name}"
  puts "\tRMSE ==> #{RMSECalculator.calculate(predicted_ratings, actual_ratings)}"
end

puts %Q{User 725544 For Movies: 'Miss Congeniality', 'Agent Cody Banks 2', 'Maid in Manhattan', 'Double Jeoparday', 'Legally Blonde'}
calculate_rmse_for_user_and_approach("Clustering", 
  [3.1530612244897958, 3.488038277511962, 2.996078431372549, 3.5868055555555554, 2.874015748031496], [4, 3, 3, 3, 2])

calculate_rmse_for_user_and_approach("Pearson Correlation Coefficient", 
  [1.001346575017792, 4.7184796939629, 3.339143919902513, 1.6784547412972712, 3.303881920120242], [4, 3, 3, 3, 2])

calculate_rmse_for_user_and_approach("Averaging Other Users Ratings For The Movie", 
  [3.361264343637714, 3.511758736539276, 3.1451257974054037, 3.639590952187458, 2.906791797947802], [4, 3, 3, 3, 2])

puts "=================================================================================================================================="

puts %Q{User 1003353 For Movies: 'Minority Report', 'Boogie Nights', 'Raiders of the Lost Ark', 'Forrest Gump', 'Adaptation', 'Father of the Bride'}
calculate_rmse_for_user_and_approach("Clustering", 
  [3.645669291338583, 3.643835616438356, 4.526970954356846, 4.275862068965517, 3.33953488372093, 3.6714285714285713], [3, 4, 5, 5, 4, 3])

calculate_rmse_for_user_and_approach("Pearson Correlation Coefficient", 
  [4.179342137799378, 4.066375786073658, 4.572445708638856, 4.329894412089659, 3.634896164715297, 4.196838492385914], [3, 4, 5, 5, 4, 3])

calculate_rmse_for_user_and_approach("Averaging Other Movie Ratings By User", 
  [3.5238095238095237, 3.5, 3.4761904761904763, 3.4761904761904763, 3.5, 3.5238095238095237], [3, 4, 5, 5, 4, 3])

puts "=================================================================================================================================="

puts %Q{User 2577095 For Movies: 'About a Boy', 'Black Hawk Down', 'Groundhog Day', 'Forrest Gump'}
calculate_rmse_for_user_and_approach("Clustering", 
  [3.6666666666666665, 3.8922155688622753, 3.887218045112782, 4.350132625994695], [5, 4, 4, 4])

calculate_rmse_for_user_and_approach("Pearson Correlation Coefficient", 
  [4.0, 4.46231184673529, 4.50104700092809, 4.606032301516182], [5, 4, 4, 4])

puts "=================================================================================================================================="
