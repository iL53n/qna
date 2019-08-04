class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes
  has_many :comments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def author_of?(object)
    self.id == object.user_id
  end
  
  def voted?(object)
    object.votes.where(user: self).exists?
  end

  def self.find_for_oauth(auth)
    #
  end
end
