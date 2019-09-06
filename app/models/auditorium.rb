class Auditorium < ApplicationRecord
  has_many :show_times, dependent: :destroy
  validates :title, uniqueness: true
  validates :title, presence: true
  validates :capacity, presence: true
  validate  :capacity_range

  def capacity_range
  	if self.capacity
  	  errors.add(:capacity, "Capacity can't be 0 or negetive number") unless self.capacity > 0
  	end
  end
end
