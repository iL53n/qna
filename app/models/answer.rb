class Answer < ApplicationRecord
  include Voteable

  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :by_best, -> { order(best: :desc) }

  def set_best
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer&.update!(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
