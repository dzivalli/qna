class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :questions
  has_many :answers
  has_many :authentications

  def owns?(obj)
    obj.respond_to?(:user_id) && obj.user_id == id
  end

  def self.from_omniauth(auth)
    user = find_or_create_by(email: auth[:info][:email]) do |u|
      u.password = u.password_confirmation = Devise.friendly_token
    end

    user.authentications.find_or_create_by(provider: auth[:provider], uid: auth[:uid])
    user
  end
end
