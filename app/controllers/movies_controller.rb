class MoviesController < ApplicationController 
  
  # count the number of click and return the previous values
  @@title_count = 0
  @@date_count  = 0
  
  class << self
    attr_accessor:title_count, :date_count
  end
  
  def after_initialize 
    MoviesController.title_count = 0
    MoviesController.date_count = 0;
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
    
    if params[:sort] == 'title' and MoviesController.title_count == 0
      MoviesController.title_count = 1
      MoviesController.date_count = 0
      @movies = Movie.all.sort_by(&:title)
    elsif params[:sort] == 'date' and MoviesController.date_count == 0
      MoviesController.title_count = 0
      MoviesController.date_count = 1
      @movies = Movie.all.sort_by(&:release_date)
    else
      @sort = nil
      MoviesController.title_count = 0
      MoviesController.date_count = 0
      @movies = Movie.all
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
