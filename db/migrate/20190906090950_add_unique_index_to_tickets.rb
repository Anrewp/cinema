class AddUniqueIndexToTickets < ActiveRecord::Migration[5.2]
  def change
  	add_index :tickets, [:seat, :show_time_id], unique: true
  end
end
