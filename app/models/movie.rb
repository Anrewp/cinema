class Movie < ApplicationRecord
 has_many :show_times, dependent: :destroy
 validates :title, uniqueness: true
 validates :title, presence: true
end
