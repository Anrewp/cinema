class Api::V1::MoviesController < Api::V1::ApiController
  before_action :find_movie, except: [:index, :create]

  def index
    render json: Movie.unscoped, status: :ok
  end

  def show
    render json: @movie
  end

  def create
    movie = Movie.new(movie_params)
    if movie.save
      head :ok
      # render status: :created
    else
      render json: movie.errors, status: :unprocessable_entity
    end
  end

  def destroy
   if @movie.destroy
     head :ok
   else
     render json: { movie: "Something went wrong" }, status: :unprocessable_entity
   end
  end

  def update
    @movie.attributes = movie_params
    if @movie.save
      head :ok
    else
      render json: { movie: "#{@movie.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
    end
    
  end

 
private

  def find_movie
    @movie = if params[:id]
               Movie.find_by(id: params[:id])
             else
               Movie.find_by(title: params[:title])
             end 
    render json: { movie: "not found" }, status: :not_found unless @movie
  end
 
  def movie_params
    params.require(:movie).permit(:duration, :genre, :rating, :title)
  end
end