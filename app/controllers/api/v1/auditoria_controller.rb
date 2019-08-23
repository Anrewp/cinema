class Api::V1::AuditoriaController < Api::V1::ApiController
  before_action :find_auditorium, except: [:index, :create]

  def index
    render json: Auditorium.unscoped, status: :ok
  end

  def show
    render json: @auditorium
  end

  def create
    auditorium = Auditorium.new(auditorium_params)
    if auditorium.save
      head :ok
    else
      render json: auditorium.errors, status: :unprocessable_entity
    end
  end

  def destroy
   if @auditorium.destroy
    head :ok
   else
    render json: { auditorium: "Something went wrong" }, status: :unprocessable_entity
   end
  end

  def update
    @auditorium.attributes = auditorium_params
    if @auditorium.save
      head :ok
    else
      render json: { auditorium: "Something went wrong" }, status: :unprocessable_entity
    end
    
  end

 
private

  def find_auditorium
    @auditorium = if params[:id]
                    Auditorium.find_by(id: params[:id])
                  else
                    Auditorium.find_by(title: params[:title])
                  end 
    render json: { auditorium: "not found" }, status: :not_found unless @auditorium
  end
 
  def auditorium_params
    params.require(:auditorium).permit(:capacity, :title)
  end
end