class ParkingSlotReservation < ApplicationRecord
  belongs_to :user
  belongs_to :parking_slot

  before_save :set_is_paid
  after_find :set_total_time

  attr_accessor :total_time

  def self.get_histories(park, type, from, to)
    hash = { '0' => [true, false], '1' => false, '2' => true }
    park = '' if park == '0'
    where(park_id: park, is_monthly: hash[type])
  end

  private
  def set_is_paid
    self.is_paid = false if self.is_paid.nil?
  end

  def set_total_time
    diff = DateTime.now.to_f - self.timein.to_f
    if diff < 3600
      self.total_time = 1
    else
      self.total_time = ((diff/3600).round(1)).ceil
    end
  end
end
