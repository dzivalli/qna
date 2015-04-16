class Question < ActiveRecord::Base
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :title, presence: true
  validates :body, presence: true
end
