class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :vote, presence: true
  validates :vote, inclusion: [-1, 1]
  validates :user_id, uniqueness: { scope: %i[voteable_type voteable_id] }
end
