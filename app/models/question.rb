class Question < ActiveRecord::Base
  include VotableModel

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :user_votes, as: :votable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :title, presence: true
  validates :body, presence: true
end
