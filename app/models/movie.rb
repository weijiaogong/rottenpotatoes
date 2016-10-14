class Movie < ActiveRecord::Base

	def self.filter(ratings)
            where(rating: ratings.keys) 
	end

end
