class Api::V1::MoviesController < Api::V1::ApiController
  def index
    render json: Movie.all, status: :ok
  end
end