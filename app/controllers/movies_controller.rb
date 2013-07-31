class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # This method call passes these functions to application_helper.rb
  helper_method :sort_column, :sort_direction

  def index
    debugger
    @selected_ratings = params[:ratings] || session[:ratings] || Movie::all_ratings
    session[:ratings] = params[:ratings]
    if params[:movies_sort]
      @selected_sort = sort_column + " " + sort_direction
      session[:movies_sort] = @selected_sort
    else
      @selected_sort = session[:movies_sort] || 'id'
    end
    @movies = Movie.where(:rating => @selected_ratings).order(@selected_sort).all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
    @all_ratings = Movie.all_ratings
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sort_column
    # This accessor method prevents SQL injection attacks.
    if params[:movies_sort]
      %w[title rating release_date].include?(params[:movies_sort]) ? params[:movies_sort] : 'title'
    end
  end

  def sort_direction
    if params[:direction]
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
  end
end