class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def get_checked_ratings(ratings)
    if ratings
       ratings.each do |rating, active|
         @all_ratings[rating] = true
       end    
    end
    checked_ratings = @all_ratings.select {|k,v| v == true}

    if checked_ratings.empty?
       @movies = Movie.all
    else
       @movies = Movie.filter(checked_ratings)
    end

  end

  def index

    @all_ratings = {'G' => false, 'PG' => false, 'PG-13' => false, 'R' => false}

    get_checked_ratings(params[:ratings])

    if /_header$/ =~ params[:id]
	column = params[:id].gsub(/_header$/,'')
    	@movies = @movies.order(column + " asc")
    end
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
