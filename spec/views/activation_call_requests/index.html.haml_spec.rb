require 'rails_helper'

RSpec.describe "activation_call_requests/index", type: :view do
  before(:each) do
    assign(:activation_call_requests, [
      ActivationCallRequest.create!(
        :imi_number => "Imi Number",
        :cell_number => "Cell Number",
        :longitude => 1.5,
        :latitude => 1.5,
        :attempt => 1,
        :address => "Address"
      ),
      ActivationCallRequest.create!(
        :imi_number => "Imi Number",
        :cell_number => "Cell Number",
        :longitude => 1.5,
        :latitude => 1.5,
        :attempt => 1,
        :address => "Address"
      )
    ])
  end

  it "renders a list of activation_call_requests" do
    render
    assert_select "tr>td", :text => "Imi Number".to_s, :count => 2
    assert_select "tr>td", :text => "Cell Number".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
  end
end
