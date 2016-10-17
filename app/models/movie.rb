class Movie < ActiveRecord::Base

	validates :title, presence: true, length: { maximum: 50 }
        validates_uniqueness_of :title, case_sensitive: false, scope: [:rating, :release_date]

	def self.all_ratings
            ['G', 'PG', 'PG-13','R']
        end

        def self.filter_and_order(filter, order)
            if filter
               where(rating: filter).order(order)
            else
               all.order(order)
            end
	end
end
