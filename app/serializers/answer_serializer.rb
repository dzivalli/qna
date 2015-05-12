class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at

  has_many :attachments
  has_many :comments
end
