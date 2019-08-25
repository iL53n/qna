class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at
  has_many :links
  has_many :comments
  has_many :files, serializer: FileSerializer
  belongs_to :user
end
