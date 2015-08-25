class ActivationCallRequestsController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_if_admin, only: [:download]
  before_action :set_activation_call_request, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @activation_call_requests = ActivationCallRequest.order_by_date.page params[:page]
    respond_with(@activation_call_requests)
  end

  def show
    respond_with(@activation_call_request)
  end

  def new
    @activation_call_request = ActivationCallRequest.new
    respond_with(@activation_call_request)
  end

  def edit
  end

  def create
    @activation_call_request = ActivationCallRequest.new(activation_call_request_params)
    flash[:notice] = 'ActivationCallRequest was successfully created.' if @activation_call_request.save
    respond_with(@activation_call_request)
  end

  def update
    flash[:notice] = 'ActivationCallRequest was successfully updated.' if @activation_call_request.update(activation_call_request_params)
    respond_with(@activation_call_request)
  end

  def destroy
    @activation_call_request.destroy
    respond_with(@activation_call_request)
  end

  def download
    @activation_call_requests = ActivationCallRequest.order_by_date
    respond_to do |format|
      format.xlsx { render xlsx: 'download', filename: "activation_call_requests.xlsx" }
    end
  end

  def summary
    @activation_call_requests = ActivationCallRequest.order_by_date
    respond_with(@activation_call_requests)
  end

  def report
    @activation_call_requests = ActivationCallRequest.order_by_date
    reporter(@activation_call_requests, per_page: 20) do
      filter :device_phone_number, type: :text
      filter :project_name, type: :text
      filter :team_area, type: :text
      filter :team_number, type: :text
      filter :created_at, type: :datetime do |query, from, to|
        query.in_between(from, to)
      end

      column(:date_time) { |acr| formatted_datetime(acr.created_at) }
      column :imi_number
      column :device_phone_number
      column :project_name
      column :team_number
      column :team_area
      if current_user.admin?
        column :longitude
        column :latitude
        column :address
      end
      column :cell_number
      column(:previously_called) { |acr| acr.previously_called? ? 'YES' : 'NO' }
    end
  end

  private
  def set_activation_call_request
    @activation_call_request = ActivationCallRequest.find(params[:id])
  end

  def activation_call_request_params
    params.require(:activation_call_request).permit(:imi_number, :cell_number, :longitude, :latitude, :attempt, :address, :device_phone_number, :project_name, :team_number, :team_area)
  end

  protected

  def check_if_admin
    redirect_to root_path, notice: 'Only admins allowed!' if signed_in? && !current_user.admin?
  end

end
