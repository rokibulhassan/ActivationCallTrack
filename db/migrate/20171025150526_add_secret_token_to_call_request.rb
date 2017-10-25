class AddSecretTokenToCallRequest < ActiveRecord::Migration
  def change
    add_column :activation_call_requests, :secret_code, :string
  end
end
