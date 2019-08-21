class CreateShowTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :show_times do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.decimal  :price
      t.integer  :tickets_available

      t.timestamps
    end
  end
end
