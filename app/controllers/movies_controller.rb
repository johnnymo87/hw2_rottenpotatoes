class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    if session.empty?
      session[:ratings] = Movie::all_ratings
      session[:sort] = 'id'
      session[:direction] = 'asc'
    end
    params[:ratings] = params[:ratings].keys if params[:ratings].is_a?(Hash)
    flag = nil
    [:ratings, :sort, :direction].each do |var|
      params[var] ? session[var] = params[var] : flag = params[var] = session[var]
    end
    @movies = Movie.where(:rating => params[:ratings]).order(params[:sort] + " " + params[:direction]).all
    if flag
      flash.keep
      redirect_to movies_path(@movies, params)
    end
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
end