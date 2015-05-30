class CreateActivationCallRequests < ActiveRecord::Migration
  def change
    create_table :activation_call_requests do |t|
      t.string :imi_number
      t.string :cell_number
      t.float :longitude
      t.float :latitude
      t.integer :attempt
      t.string :address

      t.timestamps
    end
  end
end
