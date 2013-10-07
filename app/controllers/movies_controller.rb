class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  def index
    session["init"] = true
    @change_date = false
    @change_title = false
    @all_ratings = Movie.allratings()
    @all_checked = true
    @cache = Hash.new()
    if (params[:sort_by] == nil and params[:ratings] == nil and !session.has_key?(:sort_by) and !session.has_key?(:ratings))
      params[:ratings] = Hash[@all_ratings.zip  Array.new(@all_ratings.size,1)]
      session[:ratings] = params[:ratings]
    elsif (params[:ratings] == nil and params[:sort_by] == nil and session.has_key?(:ratings))
      params[:ratings] = session[:ratings]
      params[:sort_by] = session[:sort_by]
      flash.keep
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    end
    if (params[:sort_by] != nil and session.has_key?(:ratings)) #sort_by chosen, ratings is not overrided
      params[:ratings] = session[:ratings] #happen only when sort_by is chosen
    end
    if (params[:sort_by] == nil and session.has_key?(:sort_by)) #sort by not chosen but there is one at the past
      params[:sort_by] = session[:sort_by] #happen when only ratings are chosen
    end
    
    ratings = params[:ratings].keys

    if (params[:ratings] and params[:sort_by])
      @movies = Movie.find(:all,:conditions=>{:rating => ratings}, :order => params[:sort_by])
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
    elsif (params[:ratings])
      @movies = Movie.find(:all, :conditions=>{:rating => ratings})
      session[:ratings] = params[:ratings]
    end



    if (params[:sort_by] == "release_date")
      @change_date = true
      @change_title = false
    elsif (params[:sort_by] == "title")
      @change_date = false
      @change_title = true
    end
    if (params[:ratings])
      ratings.each do |rating|
        @cache[rating] = true
        @all_checked = false
      end
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
