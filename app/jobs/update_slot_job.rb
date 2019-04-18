class UpdateSlotJob < ApplicationJob
  queue_as :default

  def perform(slot_id, slot_status)
    # @slot = ParkingSlot.find_by id: slot_id
    ActionCable.server.broadcast 'booking_channel', id: slot_id, status: slot_status
  end
end
