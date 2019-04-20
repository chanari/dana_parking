class SlotExpiredJob < ApplicationJob
  queue_as :default

  def perform(slot_id)
    @slot = ParkingSlot.find_by id: slot_id
    if @slot.present? && ['1','2'].include?(@slot.status)
      @slot.reserve_expired
    end
  end
end
