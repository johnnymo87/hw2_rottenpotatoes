class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    if params[:ratings].nil? && params[:sort].nil? && params[:direction].nil?
      session[:ratings] = Movie::all_ratings
      session[:sort] = 'id'
      session[:direction] = 'asc'
    end
    if params[:ratings]
      # stupid haml requirement makes me take params[:ratings] in a hash rather than an array
      params[:ratings] = params[:ratings].keys
      session[:ratings] = params[:ratings]
    end
    session[:sort] = params[:sort] if params[:sort]
    session[:direction] = params[:direction] if params[:direction]
    params[:ratings] ||= session[:ratings]
    params[:sort] ||= session[:sort]
    params[:direction] ||= session[:direction]



    #debugger
    #if params[:ratings]
    #  session[:ratings] = @selected_ratings = params[:ratings]
    #else
    #  @selected_ratings = session[:ratings] || Movie::all_ratings
    #end
    #if params[:sort]
    #  session[:sort] = @selected_sort = params[:sort] + " " + params[:direction]
    #else
    #  @selected_sort = session[:sort] || 'id'
    #end

    #params[:ratings] = params[:ratings].keys if params[:ratings]
    #session[:ratings] = params[:ratings] || session[:ratings] || Movie::all_ratings
    #session[:sort] = params[:sort] || session[:sort] || 'id'
    #session[:direction] = params[:direction] || session[:direction] || 'asc'

    @movies = Movie.where(:rating => params[:ratings]).order(params[:sort] + " " + params[:direction]).all
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