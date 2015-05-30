require 'rails_helper'

RSpec.describe "activation_call_requests/show", type: :view do
  before(:each) do
    @activation_call_request = assign(:activation_call_request, ActivationCallRequest.create!(
      :imi_number => "Imi Number",
      :cell_number => "Cell Number",
      :longitude => 1.5,
      :latitude => 1.5,
      :attempt => 1,
      :address => "Address"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Imi Number/)
    expect(rendered).to match(/Cell Number/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Address/)
  end
end
