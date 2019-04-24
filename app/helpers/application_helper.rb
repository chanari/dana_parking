module ApplicationHelper
  def active_class?(test_path)
    return 'active' if request.path == test_path
  end
  def date_format(date)
    return date.strftime("%d-%m-%Y %H:%M:%S") if date.present?
  end
end
