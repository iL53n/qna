require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'Guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'Admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'User' do
    let(:user) { create :user }
    let(:question) { create :question, :add_file, user: user }
    let(:answer) { create :answer, :add_file, question: question, user: user }
    let(:subscription) { create :subscription, question: question, user: user }

    let(:other_user) { create :user }
    let(:other_question) { create :question, :add_file, user: other_user }
    let(:other_answer) { create :answer, :add_file, question: question, user: other_user }

    let(:answer_for_other_question) { create :answer, question: other_question, user: user }

    it { should_not be_able_to :manage, :all }

    context 'CRUD' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Subscription }

      it { should be_able_to :read, Question }
      it { should be_able_to :read, Answer }
      it { should be_able_to :read, Comment }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, other_question }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, other_answer }
      it { should be_able_to :destroy, subscription }
    end

    context 'set the best' do
      it { should be_able_to :best, other_answer }
      it { should_not be_able_to :best, answer_for_other_question }
    end

    context 'voting' do
      it { should be_able_to :up, other_answer }
      it { should_not be_able_to :up, answer }
      it { should be_able_to :cancel, other_answer }
      it { should_not be_able_to :cancel, answer }
      it { should be_able_to :down, other_answer }
      it { should_not be_able_to :down, answer }

      it { should be_able_to :up, other_question }
      it { should_not be_able_to :up, question }
      it { should be_able_to :cancel, other_question }
      it { should_not be_able_to :cancel, question }
      it { should be_able_to :down, other_question }
      it { should_not be_able_to :down, question }
    end

    context 'attachments' do
      it { should be_able_to :destroy, answer.files.last }
      it { should_not be_able_to :destroy, other_answer.files.last }
      it { should be_able_to :destroy, question.files.last }
      it { should_not be_able_to :destroy, other_question.files.last }
    end

    context 'user profiles' do
      it { should be_able_to :read, user }
      it { should_not be_able_to :read, other_user }
      it { should be_able_to :me, user }
    end
  end
end
