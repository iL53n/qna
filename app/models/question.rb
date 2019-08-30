class Question < ApplicationRecord
  include Voteable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation, :subscribe_to_author

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_to_author
    subscriptions.create(user: user)
  end
end
