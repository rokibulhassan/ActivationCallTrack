class RemoveColumnFromActivationCallRequest < ActiveRecord::Migration
  def change
    remove_column :activation_call_requests, :project_name
  end
end
