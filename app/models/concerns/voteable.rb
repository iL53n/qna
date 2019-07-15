module Voteable
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

  def change_rating(value)
    votes.create(vote: value, user: user) unless !user.author_of?(self) || user.voted?(self)
  end
end

