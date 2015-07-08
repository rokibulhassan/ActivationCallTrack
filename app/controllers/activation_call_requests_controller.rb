class ActivationCallRequestsController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_if_admin, only: [:download]
  before_action :set_activation_call_request, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @activation_call_requests = ActivationCallRequest.order_by_date
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
