class ShowTime < ApplicationRecord
  has_many   :tickets, dependent: :destroy
  belongs_to :movie
  belongs_to :auditorium
  validates  :start_time, presence: true
  validates  :end_time, presence: true
  validates  :price, presence: true

  before_create :set_tickets_available


  def set_tickets_available
  	self.tickets_available = self.auditorium.capacity
  end
end
