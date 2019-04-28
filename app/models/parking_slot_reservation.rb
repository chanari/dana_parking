class ParkingSlotReservation < ApplicationRecord
  belongs_to :user
  belongs_to :parking_slot

  before_save :set_is_paid
  after_find :set_total_time

  attr_accessor :total_time

  scope :client_paid, -> (number_plate) { where(number_plate: number_plate, is_paid: true).sum(:subtotal) }
  scope :client_paid_month, -> (number_plate) { where(number_plate: number_plate, is_paid: true, updated_at: DateTime.now.beginning_of_month..DateTime.now).sum(:subtotal) }

  def self.get_histories(park, type, from, to)
    hash = { '0' => [true, false], '1' => false, '2' => true }
    park = '' if park == '0'
    where(park_id: park, is_monthly: hash[type], timeout: from..to)
  end

  def self.get_histories_xlsx(park, type, from, to)
    hash = { '0' => [true, false], '1' => false, '2' => true }
    park = '' if park == '0'
    @payments = where(park_id: park, is_monthly: hash[type], timeout: from..to)
    workbook = RubyXL::Workbook.new
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = "Lich Su Thanh Toan"
    worksheet.add_cell(0, 0, '#')
    worksheet.add_cell(0, 1, 'BKS')
    worksheet.add_cell(0, 2, 'Bãi')
    worksheet.add_cell(0, 3, 'Giờ vào')
    worksheet.add_cell(0, 4, 'Giờ ra/Hết hạn')
    worksheet.add_cell(0, 5, 'Thuê theo')
    worksheet.add_cell(0, 6, 'Tổng tiền')
    @payments.each_with_index do |h,i|
      worksheet.add_cell(i+1, 0, i+1)
      worksheet.add_cell(i+1, 1, h.number_plate)
      worksheet.add_cell(i+1, 2, h.park_id)
      worksheet.add_cell(i+1, 3, h.timein.present? ? h.timein.strftime("%d-%m-%Y %H:%M:%S") : '')
      worksheet.add_cell(i+1, 4, h.timeout.present? ? h.timeout.strftime("%d-%m-%Y %H:%M:%S") : '')
      worksheet.add_cell(i+1, 5, h.is_monthly ? 'Tháng' : 'Ngày')
      worksheet.add_cell(i+1, 6, h.subtotal)
    end
    worksheet.change_row_bold(0, true)
    workbook.stream.string
  end

  def self.export_file
    @payments = ParkingSlotReservation.all
    workbook = RubyXL::Workbook.new
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = "Lich Su Thanh Toan"
    worksheet.add_cell(0, 0, '#')
    worksheet.add_cell(0, 1, 'BKS')
    worksheet.add_cell(0, 2, 'Giờ vào')
    worksheet.add_cell(0, 3, 'Giờ ra/Hết hạn')
    worksheet.add_cell(0, 4, 'Thuê theo')
    worksheet.add_cell(0, 5, 'Tổng tiền')
    @payments.each_with_index do |h,i|
      worksheet.add_cell(i+1, 0, i+1)
      worksheet.add_cell(i+1, 1, h.number_plate)
      worksheet.add_cell(i+1, 2, h.timein.present? ? h.timein.strftime("%d-%m-%Y %H:%M:%S") : '')
      worksheet.add_cell(i+1, 3, h.timeout.present? ? h.timeout.strftime("%d-%m-%Y %H:%M:%S") : '')
      worksheet.add_cell(i+1, 4, h.is_monthly ? 'Tháng' : 'Ngày')
      worksheet.add_cell(i+1, 5, h.subtotal)
    end
    worksheet.change_row_bold(0, true)
    workbook.stream.string
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
