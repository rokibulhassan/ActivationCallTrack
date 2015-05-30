require "rails_helper"

RSpec.describe ActivationCallRequestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/activation_call_requests").to route_to("activation_call_requests#index")
    end

    it "routes to #new" do
      expect(:get => "/activation_call_requests/new").to route_to("activation_call_requests#new")
    end

    it "routes to #show" do
      expect(:get => "/activation_call_requests/1").to route_to("activation_call_requests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/activation_call_requests/1/edit").to route_to("activation_call_requests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/activation_call_requests").to route_to("activation_call_requests#create")
    end

    it "routes to #update" do
      expect(:put => "/activation_call_requests/1").to route_to("activation_call_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/activation_call_requests/1").to route_to("activation_call_requests#destroy", :id => "1")
    end

  end
end
