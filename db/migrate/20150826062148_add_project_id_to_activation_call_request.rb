class AddProjectIdToActivationCallRequest < ActiveRecord::Migration
  def change
    add_column :activation_call_requests, :project_id, :integer
  end
end
