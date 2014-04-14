class UserRandomSampler
  def initialize(user_ids_file)
    @user_ids_file = user_ids_file
  end

  # Random Sampling Without Replacement
  def random_sample_of_size(size=2027)
    ids = File.open(@user_ids_file, "r").read.split("\n")
    random_sample_ids = []
    size.times do
      index = rand(ids.count)
      random_sample_ids << ids.delete_at(index)
    end
    random_sample_ids
  end

  def output_random_sample_ids_to_file(filename)
    random_sample_ids = random_sample_of_size
    File.open(filename, "w") do |f|
      random_sample_ids.each { |id| f.puts(id) }
    end
  end
end

user_random_sampler = UserRandomSampler.new("./unique_user_ids")
user_random_sampler.output_random_sample_ids_to_file("./random_sample_users")
