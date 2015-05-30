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

      post 'authenticate' do
        user = User.where(:email => params[:email]).first
        if user && user.valid_password?(params[:password])
          {:user => user.as_json, :status => true, :message => "Authentication Successful."}
        else
          {:id => nil, :status => false, :message => "Authentication Failed.", :errors => "Invalid User!"}
        end
      end
    end

    resource :activation_call_requests do

      desc "Return all activation call requests."
      get do
        ActivationCallRequest.all.as_json
      end

      desc "It will create activation_call_requests for corresponding request data"
      params do
        requires :imi_number, :type => String, :desc => "imi_number"
        requires :cell_number, :type => String, :desc => "cell_number"
        requires :longitude, :type => Float, :desc => "longitude"
        requires :latitude, :type => Float, :desc => "latitude"
      end
      post do
        begin
          activation_call_request = ActivationCallRequest.new(imi_number: params[:imi_number], cell_number: params[:cell_number], longitude: params[:longitude], latitude: params[:latitude])
          activation_call_request.save
          return {:activation_call_request => activation_call_request.as_json, :status => true, :message => "ActivationCallRequest was successfully created."}
        rescue Exception => ex
          return {:activation_call_request => nil, :status => false, :message => "Can not create ActivationCallRequest.", :errors => ex.message}
        end
      end

    end

  end
end