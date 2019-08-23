class AddSeatToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :seat, :integer
  end
end
