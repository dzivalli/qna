class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :votes

  has_many :answers
end
