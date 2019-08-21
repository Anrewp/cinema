class AddAuditoriumToShowTime < ActiveRecord::Migration[5.2]
  def change
    add_reference :show_times, :auditorium, foreign_key: true
  end
end
