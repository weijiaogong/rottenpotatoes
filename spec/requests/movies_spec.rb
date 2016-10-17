require 'rails_helper'

describe "Movies", type: :request do
	before do
           @movie = Movie.new(title: "Example Movie", rating: 'G', release_date: "6-Apr-2008")
        end
	subject { @movie }
	it { should respond_to(:title) }
	it { should respond_to(:rating) }
        it { should respond_to(:release_date) }
        it { should be_valid }


         describe "when title is not present" do
		before { @movie.title = ' ' }
		it { should_not be_valid }
	end

	describe "when movie is already created" do
	   before do
		movie_with_same_info = @movie.dup
		movie_with_same_info.title = @movie.title.upcase
		movie_with_same_info.save
	   end
           
	   it { should_not be_valid }
	end


end
