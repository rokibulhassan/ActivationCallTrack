class Project < ActiveRecord::Base
  has_many :activation_call_requests

  validates_uniqueness_of :name

  scope :order_by_name, -> { order('name ASC') }

  def total_requests
    self.activation_call_requests.count
  end

  def today_requests
    self.activation_call_requests.by_date(Time.zone.now).count
  end


  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |call|
        csv << call.attributes.values_at(*column_names)
      end
    end
  end

end
