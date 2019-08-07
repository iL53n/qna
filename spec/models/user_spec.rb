require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :rewards }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:user_author) { create(:user) }
    let!(:question) { create(:question, user: user_author) }

    it 'return true if user == author' do
      expect(user_author).to be_author_of(question)
    end

    it 'return false if user != author' do
      expect(user).to_not be_author_of(question)
    end
  end

  describe '#voted?' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'return true if user voted' do
      question.votes.create(vote: 1, user: user)
      expect(user).to be_voted(question)
    end

    it 'return false if user not voted' do
      expect(user).to_not be_voted(question)
    end
  end
end
