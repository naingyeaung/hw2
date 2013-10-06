class Movie < ActiveRecord::Base
  def Movie.allratings()
    ratings = Set.new()
    movies = Movie.all()
    movies.each do |movie|
        ratings.add(movie.rating)
    end
    return ratings
  end
end
