class SlotExpiredJob < ApplicationJob
  queue_as :default

  def perform(slot_id)
    @slot = ParkingSlot.find_by id: slot_id
    @slot.reserve_expired if @slot.present? && @slot.staus == '1'
  end
end
