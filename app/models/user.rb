class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(object)
    self.id == object.user_id
  end
end
