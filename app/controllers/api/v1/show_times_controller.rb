class Api::V1::ShowTimesController < Api::V1::ApiController
  before_action :find_show_time, except: [:index, :create]

  def index
    showtimes = ShowTime.unscoped
    showtimes = showtimes.where(movie_id: params[:movie_id]) if params[:movie_id]
    render json: showtimes, status: :ok
  end

  def show
    render json: @show_time
  end

  def create
    show_time = ShowTime.new(show_time_params)
    if show_time.save
      head :ok
    else
      render json: show_time.errors, status: :unprocessable_entity
    end
  end

  def destroy
   if @show_time.destroy
     head :ok
   else
     render json: { show_time: "Something went wrong" }, status: :unprocessable_entity
   end
  end

  def update
    @show_time.attributes = show_time_params
    if @show_time.save
      head :ok
    else
      render json: @show_time.errors, status: :unprocessable_entity
    end
    
  end

 
private

  def find_show_time
    @show_time = ShowTime.find_by(id: params[:id])
    render json: { show_time: "not found" }, status: :not_found unless @show_time
  end
 
  def show_time_params
    params.require(:show_time).permit(:start_time, 
                                      :price,
                                      :auditorium_id,
                                      :movie_id)
  end
end