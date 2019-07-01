class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many_attached :files

  validates :body, presence: true

  scope :by_best, -> { order(best: :desc) }

  def set_best
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer&.update!(best: false)
      update!(best: true)
    end
  end
end
