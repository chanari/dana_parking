class ParkingSlotReservation < ApplicationRecord
  belongs_to :user
  belongs_to :parking_slot

  before_save :set_is_paid
  after_find :set_total_time

  attr_accessor :total_time

  private
  def set_is_paid
    self.is_paid = false if self.is_paid.nil?
  end

  def set_total_time
    diff = DateTime.now.to_f - self.timein.to_f
    if diff < 3600
      self.total_time = 1
    else
      self.total_time = ((diff/3600).round(1)).ceil
    end
  end
end
