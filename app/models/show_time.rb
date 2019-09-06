class ShowTime < ApplicationRecord
  has_many   :tickets, dependent: :destroy
  belongs_to :movie
  belongs_to :auditorium
  validates  :start_time, presence: true
  validates  :price, presence: true
  validate   :show_time_available

  before_create :set_tickets_available
  before_create :set_end_time


  def set_tickets_available
  	self.tickets_available = self.auditorium.capacity
  end

  def set_end_time
    self.end_time= self.start_time + self.movie.duration.minutes
  end

  def show_time_available
    auditoria_showtimes = ShowTime.where(auditorium_id: self.auditorium_id)
    end_time = self.start_time + self.movie.duration.minutes
    auditoria_showtimes.each do |showtime|
      unless self.id == showtime.id
        if self.start_time.between?(showtime.start_time, showtime.end_time) ||
                  end_time.between?(showtime.start_time, showtime.end_time) ||
                  showtime.start_time.between?(self.start_time, end_time)
          errors.add(:start_time, "ShowTime id:#{showtime.id} exists")
        end
      end
    end
  end

end
