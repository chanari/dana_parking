class ParkingSlotReservation < ApplicationRecord
  belongs_to :user
  belongs_to :parking_slot
end
