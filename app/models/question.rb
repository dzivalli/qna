class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  include Reputable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
end
