require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe '#set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer_best) { create(:answer, question: question, user: user) }
    let(:answer_not_best) { create(:answer, question: question, user: user) }

    it 'return true if answer == best' do
      answer_best.set_best
      answer_best.reload
      expect(answer_best).to be_best
    end

    it 'return false if answer != best' do
      expect(answer_not_best).to_not be_best
    end
  end
end
