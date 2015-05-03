class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body

  has_many :attachments
end
