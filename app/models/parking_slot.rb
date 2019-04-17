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

  def reserve(number_plate, client)
    return false if User.where(id: client, role: '0').empty?
    SlotExpiredJob.set(wait: 30.seconds).perform_later(self.id) if self.update(status: '1', date_in: DateTime.now, number_plate: number_plate, client: client)
  end

  def reserve_expired
    self.update(status: '0', date_in: nil, number_plate: nil, client: nil)
  end

  private

  def set_status
    self.status = '0' if self.status.nil?
  end
end
