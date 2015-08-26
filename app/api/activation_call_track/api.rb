module ActivationCallTrack
  class API < Grape::API
    version 'v1', :using => :path, :vendor => 'activation_call_track', :format => :json
    helpers do
      def current_user
        return false unless params[:auth_token]
        @current_user ||= User.where(authentication_token: params[:auth_token]).first
      end

      def current_client
        @current_client ||= current_user.present? ? current_user.client : nil
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    before do
      authenticate! unless ['/users/authenticate'].any? { |w| request.path_info =~ /#{w}/ }
    end

    resources :users do
      desc "Authenticate user and return user object, access token, and permissions(on demand)"
      params do
        requires :email, :type => String, :desc => "User email"
        requires :password, :type => String, :desc => "User password"
      end

      get 'authenticate' do
        user = User.where(:email => params[:email]).first
        if user && user.valid_password?(params[:password])
          {:status => true, :object => user.as_json, :message => "Authentication Successful."}
        else
          {:status => false, :message => "Authentication Failed.", :errors => "Invalid User!"}
        end
      end
    end

    resource :activation_call_requests do

      desc "Return all activation call requests."
      get do
        ActivationCallRequest.all.as_json
      end

      desc "It will create activation_call_requests for corresponding request data."
      params do
        requires :imi_number, :type => String, :desc => "imi_number"
        requires :cell_number, :type => String, :desc => "cell_number"
        requires :longitude, :type => Float, :desc => "longitude"
        requires :latitude, :type => Float, :desc => "latitude"
        optional :device_phone_number, :type => String, :desc => "device_phone_number"
        optional :project_name, :type => String, :desc => "project_name"
        optional :team_number, :type => String, :desc => "team_number"
        optional :team_area, :type => String, :desc => "team_area"
      end
      post do
        begin
          project_name = params[:project_name]
          project_name = project_name.present? ? project_name : "Unknown Project"
          project = Project.where(name: project_name).first_or_create
          activation_call_request = ActivationCallRequest.new(imi_number: params[:imi_number], cell_number: params[:cell_number],
                                                              longitude: params[:longitude], latitude: params[:latitude],
                                                              device_phone_number: params[:device_phone_number], project_id: project.id,
                                                              team_number: params[:team_number], team_area: params[:team_area])
          activation_call_request.save
          return {:status => true, :object => activation_call_request.as_json, :message => "ActivationCallRequest was successfully created."}
        rescue Exception => ex
          return {:status => false, :object => nil, :message => "Can not create ActivationCallRequest.", :errors => ex.message}
        end
      end

      desc "Return true/false if already enrolled or not."
      params do
        requires :id, :type => Integer, :desc => "id"
      end
      get '/:id' do
        activation_call_request = ActivationCallRequest.where(id: params[:id]).first
        if activation_call_request.present?
          return {status: true, object: activation_call_request.as_json, previously_called: activation_call_request.previously_called?}
        else
          return {status: false, object: nil, message: "ActivationCallRequest Not found for id #{params[:id]}"}
        end
      end


    end

  end
end