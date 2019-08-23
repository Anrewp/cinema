class Auditorium < ApplicationRecord
  has_many :show_times, dependent: :destroy
end
