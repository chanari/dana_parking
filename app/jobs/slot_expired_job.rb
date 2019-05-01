class SlotExpiredJob < ApplicationJob
  queue_as :default

  def perform(slot_id, is_monthly)
    @slot = ParkingSlot.find_by id: slot_id
    if @slot.present?
      if is_monthly
        @slot.reserve_expired
      elsif !is_monthly && @slot.status == '1'
        @slot.reserve_expired
      end
    end
  end
end
