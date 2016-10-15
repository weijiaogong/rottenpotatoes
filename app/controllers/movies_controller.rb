class MoviesController < ApplicationController

##########################################################################
# get new movies' information  from params  #
##########################################################################
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  

##########################################################################
# return movies with selected ratings  #
##########################################################################
  def get_filtered_movies

    ratings = params[:ratings]
    # update ratings stored in session if new ratings are selected
    if  ratings
        session[:before_filter] = ratings
    end


    # get movies from model with selected ratings
    if session[:before_filter]
       @movies = Movie.filter(session[:before_filter])
    else
       @movies = Movie.all
    end

   end


##########################################################################
# order movies by specified column  #
##########################################################################
   def get_ordered_movies

    column = params[:column]
    # update the column used for sorting stored in session
    if column
       session[:before_sortby] = column unless column.empty?
    end
    
    # order movies by specified column
    if session[:before_sortby]
       @movies = @movies.order("lower(#{session[:before_sortby]})" + " asc")
    end
   end


##########################################################################
# set variables of ratings and column used in view  #
##########################################################################
   def get_setting

    # @all_ratings helps show the status of check_box of ratings
    @all_ratings = {'G' => false, 'PG' => false, 'PG-13' => false, 'R' => false}

    # update @all_ratings
    if session[:before_filter]
       session[:before_filter].each do |rating, active|
         @all_ratings[rating] = true
       end    
    end

    # @column helps highlight the specific column by which the movies are ordered
    @column = session[:before_sortby]

   end


##########################################################################
# render home page #
##########################################################################
  def index

    get_filtered_movies

    get_ordered_movies

    get_setting
  end

##########################################################################
# new action #
##########################################################################

  def new
    # default: render 'new' template
  end

##########################################################################
# add new movie #
##########################################################################
  def create
    @movie = Movie.create!(movie_params)

    p = Hash.new
    p[:ratings] = session[:before_filter]
    p[:column]  = session[:before_sortby]

    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(p)
  end

##########################################################################
# display the information of a specific movie #
##########################################################################

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    get_setting
  
    flash[:notice] = "#{@movie.title} was successfully created."
  end


##########################################################################
# edit an existing movie #
##########################################################################

  def edit
    @movie = Movie.find params[:id]
  end


##########################################################################
# update an existing movie #
##########################################################################

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

##########################################################################
# delete an existing movie #
##########################################################################

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    p = Hash.new
    p[:ratings] = session[:before_filter]
    p[:column]  = session[:before_sortby]

    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(p)
  end
end
