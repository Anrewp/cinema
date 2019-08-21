class AddShowTimeToTickets < ActiveRecord::Migration[5.2]
  def change
    add_reference :tickets, :show_time, foreign_key: true
  end
end
