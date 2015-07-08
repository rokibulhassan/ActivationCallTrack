class AddExtraColumnToActivationCallRequest < ActiveRecord::Migration
  def change
    add_column :activation_call_requests, :device_phone_number, :string
    add_column :activation_call_requests, :project_name, :string
    add_column :activation_call_requests, :team_number, :string
    add_column :activation_call_requests, :team_area, :string
  end
end
