class ParkingSlot < ApplicationRecord
  belongs_to :block

  before_save :set_status

  private

  def set_status
    self.status = '0' if self.status.nil?
  end
end
