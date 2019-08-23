class ChangeMovieMinutes < ActiveRecord::Migration[5.2]
  def change
  	rename_column :movies, :minutes, :duration
  end
end
