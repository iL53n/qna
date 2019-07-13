module Voteable
  # ToDo: Покрыть тестами модель
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def up_rating
    change_rating(1)
  end

  def down_rating
    change_rating(-1)
  end

  def rating
    votes.sum(:vote)
  end

  private

  def change_rating(value)
    votes.create(vote: value, user: user)
  end
end

