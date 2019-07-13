class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :vote, presence: true
  validates :vote, inclusion: [-1, 1]
end
