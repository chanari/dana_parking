class ParkingSlotReservation < ApplicationRecord
  belongs_to :user
  belongs_to :parking_slot

  before_save :set_is_paid
  after_find :set_total_time

  attr_accessor :total_time

  def self.get_histories(park, type, from, to)
    hash = { '0' => [true, false], '1' => false, '2' => true }
    park = '' if park == '0'
    where(park_id: park, is_monthly: hash[type], timeout: from..to)
  end

  # def self.export_file
  #   @payments = ParkingSlotReservation.all
  #   workbook = RubyXL::Workbook.new
  #   worksheet = workbook.worksheets[0]
  #   worksheet.sheet_name = "Lich Su Thanh Toan"
  #   worksheet.add_cell(0, 0, '#')
  #   worksheet.add_cell(0, 1, 'BKS')
  #   worksheet.add_cell(0, 2, 'Giờ vào')
  #   worksheet.add_cell(0, 3, 'Giờ ra/Hết hạn')
  #   worksheet.add_cell(0, 4, 'Thuê theo')
  #   worksheet.add_cell(0, 5, 'Tổng tiền')
  #   @payments.each_with_index do |h,i|
  #     worksheet.add_cell(i+1, 0, i+1)
  #     worksheet.add_cell(i+1, 1, h.number_plate)
  #     worksheet.add_cell(i+1, 2, h.timein.strftime("%d-%m-%Y %H:%M:%S"))
  #     worksheet.add_cell(i+1, 3, h.timeout.strftime("%d-%m-%Y %H:%M:%S"))
  #     worksheet.add_cell(i+1, 4, h.is_monthly ? 'Tháng' : 'Ngày')
  #     worksheet.add_cell(i+1, 5, h.subtotal)
  #   end
  #   workbook.stream
  # end

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
