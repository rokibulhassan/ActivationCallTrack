class ActivationCallRequest < ActiveRecord::Base

  #validate :validated_already_called
  #before_validation :reset_attempt_count
  after_save :send_message

  scope :by_imi_number, ->(imi_number) { where(imi_number: imi_number) }
  scope :by_cell_number, ->(cell_number) { where(cell_number: cell_number) }

  reverse_geocoded_by :latitude, :longitude, :address => :address
  after_validation :reverse_geocode

  def requests
    ActivationCallRequest.where('project_name=?', project_name).where('imi_number=? OR cell_number=?', imi_number, cell_number)
  end

  def duplicate_requests_count
    requests.count
  end

  def previously_called?
    duplicate_requests_count >= 1
  end

  #def requests_exist?
  #  requests.count >= 1
  #end

  #def validated_already_called
  #  errors.add(:domain, "Validation Failed Previously Called.") if requests_exist?
  #end

  #def reset_attempt_count
  #  requests.last.update_column(:attempt, attempt.to_i+1) if requests_exist?
  #end

  def project_name_str
    self.project_name.to_s.gsub(' ', '+')
  end

  def send_message
    msg = "Congratulations!+Your+are+eligible+to+receive+a+free+sample+of+#{self.project_name_str}"
    msg = "Already+Registered+in+#{self.project_name_str}" if previously_called?
    url = URI.parse("http://sms.nixtecsys.com/index.php?app=webservices&ta=pv&u=Rajiul.Karim&p=Rajiul123&to=#{self.cell_number}&msg=#{msg}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
  end

end

