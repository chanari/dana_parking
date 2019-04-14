class ParkingSlotReservation < ApplicationRecord
  belongs_to :user
  belongs_to :parking_slot

  before_save :set_is_paid

  private
  def set_is_paid
    self.is_paid = false if self.is_paid.nil?
  end
end
