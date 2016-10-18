class Movie < ActiveRecord::Base

        #validation, title cannot be blank or longer than 50 letters
	validates :title, presence: true, length: { maximum: 50 }
        #movie (title,rating,release_date) must be unique
        validates_uniqueness_of :title, case_sensitive: false, scope: [:rating, :release_date]

        # collection of all ratings
	def self.all_ratings
            ['G', 'PG', 'PG-13','NC-17','R']
        end

        #select movies with specific ratings and order them by specific attribute
        def self.filter_and_order(filter, order)
            if filter
               where(rating: filter).order(order)
            else
               all.order(order)
            end
	end
end
