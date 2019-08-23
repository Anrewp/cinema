class Ticket < ApplicationRecord
  belongs_to :show_time
  validates :seat, presence: true
  validates :email, presence: true
  validate :valid_seat
  validate :available_seat

  after_create :subtract_tickets_available

  def subtract_tickets_available
    if self.show_time.tickets_available > 0
  	  sub_tickets = self.show_time.tickets_available - 1
  	  self.show_time.update_attribute(:tickets_available, sub_tickets)
    end
  end

  def valid_seat
    unless self.seat <= self.show_time.auditorium.capacity && self.seat > 0
      errors.add(:seat, "There is no such seat")
    end 
  end

  def available_seat
  	if self.show_time.tickets.find_by(seat: self.seat)
  	  errors.add(:seat, "Seat has already been taken")
  	end
  end
end
