require 'rails_helper'

RSpec.describe "activation_call_requests/edit", type: :view do
  before(:each) do
    @activation_call_request = assign(:activation_call_request, ActivationCallRequest.create!(
      :imi_number => "MyString",
      :cell_number => "MyString",
      :longitude => 1.5,
      :latitude => 1.5,
      :attempt => 1,
      :address => "MyString"
    ))
  end

  it "renders the edit activation_call_request form" do
    render

    assert_select "form[action=?][method=?]", activation_call_request_path(@activation_call_request), "post" do

      assert_select "input#activation_call_request_imi_number[name=?]", "activation_call_request[imi_number]"

      assert_select "input#activation_call_request_cell_number[name=?]", "activation_call_request[cell_number]"

      assert_select "input#activation_call_request_longitude[name=?]", "activation_call_request[longitude]"

      assert_select "input#activation_call_request_latitude[name=?]", "activation_call_request[latitude]"

      assert_select "input#activation_call_request_attempt[name=?]", "activation_call_request[attempt]"

      assert_select "input#activation_call_request_address[name=?]", "activation_call_request[address]"
    end
  end
end
