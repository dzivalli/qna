class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  include Reputable

  has_many :answers, dependent: :destroy
  has_many :notifications, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  scope :for_last_day, -> { where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight) }
end
