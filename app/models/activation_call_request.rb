class ActivationCallRequest < ActiveRecord::Base

  belongs_to :project
  validates_presence_of :project_id

  #validate :validated_already_called
  #before_validation :reset_attempt_count
  after_save :send_message
  before_create :set_address, :set_secret_code

  scope :by_imi_number, ->(imi_number) { where(imi_number: imi_number) }
  scope :by_cell_number, ->(cell_number) { where(cell_number: cell_number) }
  scope :order_by_date, -> { order('created_at DESC') }
  scope :in_between, ->(from, to) { where('created_at >=? and created_at <=?', from, to) }
  scope :by_date, ->(date) { in_between(date.beginning_of_day, date.end_of_day) }


  # reverse_geocoded_by :latitude, :longitude, :address => :address
  # after_validation :reverse_geocode

  def set_secret_code
    self.secret_code = loop do
      token = rand(36**15).to_s(36)
      break token unless ActivationCallRequest.exists?(secret_code: token)
    end
  end

  def requests
    ActivationCallRequest.where('project_id=? AND cell_number=?', project_id, cell_number)
  end

  def duplicate_requests_count
    requests.count
  end

  def previously_called?
    duplicate_requests_count > 1
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

  def set_address
    url = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?latlng=#{self.latitude},#{self.longitude}&sensor=true")
    req = Net::HTTP::Get.new(url.to_s)
    req.use_ssl = true if url.scheme == 'https'
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    result = JSON.parse(res.body)
    self.address = result['results'][0]['formatted_address'] rescue "Not Found"
  end

  def project_name
    self.project.try(:name)
  end

  def project_name_str
    self.project_name.to_s.gsub(' ', '+')
  end

  def send_message
    # return if previously_called?
    mobile_number = self.cell_number.gsub(/\+/, '')
    msg = "Congratulations!+#{self.secret_code}+code+ti+#{self.project_name_str}+activation+BP+ke+dekhiye+apnar+jar+ti+bujhe+nin.+Next+time+Unilever+apnar+sathe+contact+korte+pare."
    # msg = "Already+Registered+in+#{self.project_name_str}" if previously_called?
    # url = URI.parse("http://sms.nixtecsys.com/index.php?app=webservices&ta=pv&u=Rajiul.Karim&p=Rajiul123&to=#{self.cell_number}&msg=#{msg}")
    url = URI.parse("http://powersms.banglaphone.net.bd/httpapi/sendsms?userId=miniaturesm&password=Dhaka1212&smsText=#{msg}&commaSeperatedReceiverNumbers=#{mobile_number}")
    req = Net::HTTP::Get.new(url.to_s)
    req.use_ssl = true if url.scheme == 'https'
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    logger.info "Send sms >>>>> #{res.body}"
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

