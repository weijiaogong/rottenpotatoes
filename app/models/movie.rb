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

    def self.find_similar_by_director(director)
        # we use ',' as the delimiter for multiple directors
        director = director.gsub(/(^\s)|(\s$)/,"")
        #movies = Movie.where("director LIKE ?", director)
        movies = Movie.where("director ~* ?", "(^|(.*[,\s]+))" + director + "($|([,\s]+.*))")

        directors = director.split(/[,;]/)
        directors.each do |dir|
            dir = dir.gsub(/(^\s)|(\s$)/,"")
            #movies = movies.or(where("director LIKE ?",dir)
            movies = movies.or(where("director ~* ?",'(^|(.*[,\s]+))' + dir + '($|([,\s]+.*))'))
        end

        return movies
    end
end
