# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :me, user
    can :read, user

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :best, Answer, question: { user_id: user.id }

    can [:up, :cancel, :down], [Question, Answer] do |obj|
      !user.author_of? obj
    end

    can :destroy, Link, linlable: { user_id: user.id }

    can :manage, ActiveStorage::Attachment do |attachment|
      user.author_of? attachment.record
    end
  end
end
