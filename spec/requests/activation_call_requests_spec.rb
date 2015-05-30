require 'rails_helper'

RSpec.describe "ActivationCallRequests", type: :request do
  describe "GET /activation_call_requests" do
    it "works! (now write some real specs)" do
      get activation_call_requests_path
      expect(response).to have_http_status(200)
    end
  end
end
