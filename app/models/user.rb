class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  before_create :set_authentication_token

  def set_authentication_token
    self.authentication_token = loop do
      token = rand(36**15).to_s(36)
      break token unless User.exists?(authentication_token: token)
    end
  end
end
