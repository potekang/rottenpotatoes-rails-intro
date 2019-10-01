class Movie < ActiveRecord::Base
    def self.ratings
        Movie.uniq.pluck(:rating).sort
    end
    def self.movie_with_ratings(checked)
        Movie.where(:rating => checked )
    end
end
