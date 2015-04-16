class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :title, presence: true
  validates :body, presence: true

  def vote_up!
    update votes: votes + 1
    end

  def vote_down!
    update votes: votes - 1
  end
end
