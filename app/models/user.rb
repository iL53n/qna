class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[github facebook twitter vkontakte]

  def author_of?(object)
    self.id == object.user_id
  end
  
  def voted?(object)
    object.votes.where(user: self).exists?
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  protected

  def confirmation_required?
    false
  end
end
