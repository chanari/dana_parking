class ParkingSlot < ApplicationRecord
  belongs_to :block
  has_many :parking_slot_reservations

  before_save :set_status

  def price_by_hours
    return Floor.joins(blocks: :parking_slots).where(parking_slots: { id: self.id }).pluck(:price_by_hours)[0]
  end

  def price_by_months
    return Floor.joins(blocks: :parking_slots).where(parking_slots: { id: self.id }).pluck(:price_by_months)[0]
  end

  private

  def set_status
    self.status = '0' if self.status.nil?
  end
end
