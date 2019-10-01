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
    
    @sort = params[:sort]
    @all_ratings = Movie.ratings
    
    #set up checked ratings
    if params[:ratings]
      @checked_ratings = params[:ratings].keys
    else
      @checked_ratings = @all_ratings
    end
    
    #output movie list
    @checked_movies = Movie.movie_with_ratings(@checked_ratings)
    if params[:sort] == 'title' and MoviesController.count != 1
      MoviesController.count = 1
      @movies = Movie.all.sort_by(&:title)
    elsif params[:sort] == 'date' and MoviesController.count != -1
      MoviesController.count = -1
      @movies = Movie.all.sort_by(&:release_date)
    else
      @sort = nil
      MoviesController.count = 0
      @movies = @checked_movies
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
