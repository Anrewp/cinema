class Api::V1::TicketsController < Api::V1::ApiController
  before_action :find_ticket, except: [:index, :create]

  def index
    render json: Ticket.unscoped, status: :ok
  end

  def show
    render json: @ticket
  end

  def create

    ticket = Ticket.new(ticket_params)
    if ticket.save
      head :ok
    else
      render json: ticket.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @ticket.destroy
      head :ok
    else
      render json: { ticket: "Something went wrong" }, status: :unprocessable_entity
    end
  end

  def update
    @ticket.attributes = ticket_params
    if @ticket.save
      head :ok
    else
      render json: { ticket: "Something went wrong" }, status: :unprocessable_entity
    end
    
  end

 
private

  def find_ticket
    @ticket = Ticket.find_by(id: params[:id])
    render json: { ticket: "not found" }, status: :not_found unless @ticket
  end
 
  def ticket_params
    params.require(:ticket).permit(:email, :seat, :show_time_id)
  end
end