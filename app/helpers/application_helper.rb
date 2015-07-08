module ApplicationHelper
  def formated_date(data)
    return "" if data.nil?
    data.strftime("%b %d, %Y")
  end

  def formatted_datetime(data)
    return "" if data.nil?
    data.strftime("%b %d, %Y | %I:%M %p")
  end

  def custom_date_view(data)
    return "" if data.nil?
    data.strftime("%Y-%m-%d")
  end
end
