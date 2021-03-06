class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :authentications, dependent: :destroy
  has_many :notifications, dependent: :destroy

  scope :except_of, -> (user) { where.not(id: user) }

  def owns?(obj)
    obj.respond_to?(:user_id) && obj.user_id == id
  end

  def self.from_omniauth(auth)
    if auth[:info][:email].present?
      user = find_or_create_by(email: auth[:info][:email]) do |u|
        u.password = Devise.friendly_token
        u.confirmed_at = Date.today
      end

      user.authentications.find_or_create_by(provider: auth[:provider], uid: auth[:uid])
      user
    else
      Authentication.find_by(provider: auth[:provider], uid: auth[:uid]).try(:user)
    end
  end

  def provider?(provider)
    authentications.where(provider: provider).any?
  end
end
