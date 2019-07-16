require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'Voteable' do
    let(:voteable) { 'Answer' }
  end

  describe '#set_best' do
    let(:user_best) { create(:user) }
    let(:user_not_best) { create(:user) }
    let(:question) { create(:question, user: user_best) }
    let!(:reward) { create(:reward, question: question) }
    let(:answer_best) { create(:answer, question: question, user: user_best) }
    let(:answer_not_best) { create(:answer, question: question, user: user_not_best) }

    before { answer_best.set_best }

    it 'return true if answer == best' do
      answer_best.reload
      expect(answer_best).to be_best
    end

    it 'return false if answer != best' do
      expect(answer_not_best).to_not be_best
    end

    it "should reward must belong to the best answer's author" do
      expect(answer_best.user).to eq question.reward.user
    end

    it "change best: if change question's best answer" do
      answer_not_best.set_best
      answer_best.reload
      answer_not_best.reload

      expect(answer_not_best).to be_best
      expect(answer_best).to_not be_best
    end
  end

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
