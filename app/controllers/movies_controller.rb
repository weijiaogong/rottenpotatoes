class MoviesController < ApplicationController
##########################################################################
# get new movies' information  from params  #
##########################################################################
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date,:director)
  end
##########################################################################
# update filter and sortby in session #
##########################################################################
   def update_session
       ratings = params[:ratings] || {}
       # update ratings stored in session if new ratings are selected
       session[:before_ratings] = ratings unless ratings.empty?

       sortby = params[:sortby] || ""
       # update the column used for sorting stored in session
       session[:before_sortby] = sortby unless sortby.empty?
   end
##########################################################################
# construct filter parameter for Movie Model #
##########################################################################
   def get_filter
    # order movies by specified column
    if session[:before_ratings]
       filter = session[:before_ratings].keys
    end
   end
##########################################################################
# construct order parameter for Movie Model #
##########################################################################
   def get_order
    # order movies by specified column
    if session[:before_sortby]
       if  session[:before_sortby] == 'title'
           order = "lower(#{session[:before_sortby]})" + " ASC"
       elsif  session[:before_sortby] == 'release_date'
           order = session[:before_sortby] + " ASC"
       end
    end
   end
##########################################################################
# set variables of ratings and column used in view  #
##########################################################################
   def set_session
    # @all_ratings helps show the status of check_box of ratings
    @filter = session[:before_ratings] || {}
    # @sortby helps highlight the specific column by which the movies are ordered
    @sortby = session[:before_sortby]
   end
##########################################################################
# render home page #
##########################################################################
  def index
    @all_ratings = Movie.all_ratings
    update_session
    set_session
    #  add filter and sortby parameters into Url if they are not added yet#
    #params[:sortby] is nil and session[:before_sortby] is not, otherwise
    #either session[:before_sortby] and params[:sortby] are both nil
    #or params[:sortby] is setted by user
    if params[:sortby] != session[:before_sortby]
          flash.keep
          redirect_to :sortby => session[:before_sortby], :ratings => session[:before_ratings] and return
     end
     #params[:ratings] is nil and session[:before_ratings] is not

    if params[:ratings] != session[:before_ratings]
          flash.keep
          redirect_to :sortby => session[:before_sortby], :ratings => session[:before_ratings] and return
    end
   
    @movies = Movie.filter_and_order(get_filter, get_order )
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
     begin
      @movie = Movie.create!(movie_params)
	    flash[:notice] = "#{@movie.title} was successfully created."
	    redirect_to movies_path
     rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = invalid
      render 'new'
     end
  end
##########################################################################
# display the information of a specific movie #
##########################################################################
  def show
    @similar = false
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    @all_ratings = Movie.all_ratings
  end
##########################################################################
# display the information of a specific movie #
##########################################################################
  def similar
    @movie = Movie.find(params[:movie_id])
    director = @movie.director || ""
    # will render app/views/movies/show.<extension> by default
    if director.empty?
       flash[:notice] = "'#{@movie.title}' has no director info"
       redirect_to movies_path and return
    else
       @similar = true
       @all_ratings = Movie.all_ratings
       @movies = Movie.find_similar_by_director(@movie.director) # look up movie by unique ID
       render :show
    end
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
   begin
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
   rescue ActiveRecord::RecordInvalid => invalid
    flash[:notice] = invalid.message
    redirect_to edit_movie_path(@movie)
    end
  end
##########################################################################
# delete an existing movie #
##########################################################################
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
