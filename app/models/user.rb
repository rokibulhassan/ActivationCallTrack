class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :roles, :presence => true

  before_create :set_authentication_token

  def set_authentication_token
    self.authentication_token = loop do
      token = rand(36**15).to_s(36)
      break token unless User.exists?(authentication_token: token)
    end
  end


  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  ROLES = %w[admin agency]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def admin?
    role?(:admin)
  end

  def agency_admin?
    role?(:agency)
  end

  def name
    [self.first_name, self.last_name].join(" ")
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
