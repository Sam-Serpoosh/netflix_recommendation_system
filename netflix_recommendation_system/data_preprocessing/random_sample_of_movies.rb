class MovieRandomSampler
  def initialize(movies_dir)
    @movies_dir = movies_dir
  end

  # Random Sampling without Replacement
  def random_sample_of_size(size=2000)
    movie_files = Dir["#{@movies_dir}/*"]
    random_sample_movies = []
    size.times do
      index = rand(movie_files.count)
      random_sample_movies << movie_files.delete_at(index)
    end
    random_sample_movies
  end

  def output_random_sample_movies_to_file(filename) 
    random_sample_movies = random_sample_of_size
    File.open(filename, "w") do |f|
      random_sample_movies.each { |movie| f.puts(movie) }
    end
  end
end

movie_random_sampler = MovieRandomSampler.new("../../netflix_dataset/training_set")
movie_random_sampler.output_random_sample_movies_to_file("../../sample_netflix_dataset/random_movies")
