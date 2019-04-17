class SlotExpiredJob < ApplicationJob
  queue_as :default

  def perform(slot_id)
    @slot = ParkingSlot.find_by id: slot_id
    @slot.reserve_expired if @slot.present?
  end
end
