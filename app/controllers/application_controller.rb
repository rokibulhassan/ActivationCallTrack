require 'query_report/helper'
class ApplicationController < ActionController::Base
  include QueryReport::Helper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
