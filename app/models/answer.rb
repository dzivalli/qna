class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def belongs_to?(current_user)
    user == current_user
  end
end
