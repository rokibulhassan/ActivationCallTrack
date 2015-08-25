module QueryReportFilterHelper
  def query_report_text_filter(name, value, options={})
    text_field_tag name, value, options
  end
  
  def query_report_datetime_filter(name, value, options={})
    text_field_tag name, value, options.merge(class: :datetimepicker)
  end

end