module QueryReportFilterHelper
  def query_report_text_filter(name, value, options={})
    text_field_tag name, value, options
  end

  def query_report_datetime_filter(name, value, options={})
    text_field_tag name, value, options.merge(class: :datetimepicker)
  end

  def query_report_project_filter(name, value, options={})
    projects = Project.order_by_name
    select_tag name, options_for_select(projects.collect{|p| [p.name, p.id]}, value), {prompt: "Choose Project"}
  end

end