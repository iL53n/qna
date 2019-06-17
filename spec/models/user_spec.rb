require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'user.author?' do
    let(:user) { create(:user) }
    let(:user_author) { create(:user) }
    let!(:question) { create(:question, user: user_author) }

    it 'return true if user == author' do
      # expect(user_author).to be_author_of(question)
      expect(user_author.author?(question)).to eq true
    end

    it 'return false if user != author' do
      expect(user.author?(question)).to eq false
    end
  end
end
