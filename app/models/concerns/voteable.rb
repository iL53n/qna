module Voteable
  # ToDo: Покрыть тестами модель
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def up_rating
    change_rating(1)
  end

  def cancel_vote
    votes.where(user: user).destroy_all
  end

  def down_rating
    change_rating(-1)
  end

  def rating
    votes.sum(:vote)
  end

  private

  def change_rating(value)
    # ToDo: Покрыть тестами - автор + повторное голосование
    # votes.create(vote: value, user: user) unless user.author_of?(self) || user.voted?(self)
    votes.create(vote: value, user: user) unless user.voted?(self)
  end
end

