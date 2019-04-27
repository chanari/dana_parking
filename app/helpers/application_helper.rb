module ApplicationHelper
  def active_class?(test_path)
    return 'active' if request.path == test_path
  end
  def date_format(date)
    return date.strftime("%d-%m-%Y %H:%M:%S") if date.present?
  end
  def export_file histories
    workbook = RubyXL::Workbook.new
    worksheet = workbook.worksheets[0]
    worksheet.sheet_name = "Lich Su Thanh Toan"
    worksheet.add_cell(0, 0, '#')
    worksheet.add_cell(0, 1, 'BKS')
    worksheet.change_row_bold(0, true)
    histories.each_with_index do |h,i|
      worksheet.add_cell(i+1, i+1, histories.number_plate)
    end
    workbook.stream
  end
end
