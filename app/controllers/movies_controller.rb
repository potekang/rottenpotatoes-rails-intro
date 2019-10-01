class MoviesController < ApplicationController 
  
  # count the number of click and return the previous values
  @@count  = 0
  
  class << self
    attr_accessor:count
  end
  
  def after_initialize 
    MoviesController.count = 0;
  end
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
      
    # set session sort
    @sort = params[:sort] || session[:sort]
    if(params[:sort])
      session[:sort] = params[:sort]
    end
    
    #set up checked ratings & session[:ratings]
    @all_ratings = Movie.ratings
    if params[:ratings]
      if(params[:ratings].is_a? Hash)
        params[:ratings] = params[:ratings].keys
      end
      @checked_ratings = params[:ratings]
      session[:ratings] = @checked_ratings
    elsif session[:ratings]
      @checked_ratings = session[:ratings]
    else
      @checked_ratings = @all_ratings
    end
    session[:ratings] = @checked_ratings
    
    #@movies = Movie.movie_with_ratings(@checked_ratings).order(@sort)
    
    #output movie list
    #trying to elemiate seconde click
    @checked_movies = Movie.movie_with_ratings(@checked_ratings)
    if params[:sort] == 'title' and MoviesController.count == 1 and params[:click]
      @sort = ''
      MoviesController.count = 0
    elsif params[:sort] == 'release_date' and MoviesController.count == -1 and params[:click]
      @sort = ''
      MoviesController.count = 0
    else
      if @sort =='title'
        MoviesController.count = 1
      elsif @sort =='release_date'
        MoviesController.count = -1
      end
    end
    if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
      params[:sort] = session[:sort]
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    else
      @movies = Movie.movie_with_ratings(@checked_ratings).order(@sort)
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
