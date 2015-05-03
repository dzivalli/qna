class AnswerSerializer < ActiveModel::Serializer
  attributes :id

  has_many :attachments
end
