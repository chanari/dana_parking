class SlotExpiredJob < ApplicationJob
  queue_as :default

  def perform(slot_id)
    @slot = ParkingSlot.find_by id: slot_id
    if @slot.present? && @slot.status == '1'
      @slot.reserve_expired
      ActionCable.server.broadcast 'booking_channel', @slot.as_json(only: [:id, :status])
    end
  end
end
