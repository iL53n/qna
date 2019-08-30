require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it_behaves_like 'Voteable' do
    let(:voteable) { 'Question' }
  end

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:answer) { build(:answer) }

    it 'calls NewAnswerNotificationJob' do
      expect(NewAnswerNotificationJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end

  describe '#subscribe_to_author' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: author) }

    it 'author has subscription' do
      expect(author.subscriptions.last).to eq question.subscriptions.last
    end

    it 'not author has not subscription' do
      expect(user.subscriptions).to eq []
    end
  end
end
