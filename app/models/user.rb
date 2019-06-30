class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def generate_new_access_token
  	token = User.generate_unique_secure_token
  	update_attributes authentication_token: token
  end
end

