require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :rewards }
  it { should have_many(:votes) }
  it { should have_many :comments }
  it { should have_many(:authorizations) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    context 'user already has authorization' do
      it 'return the user' do
        user.authorizations.create(provider: 'github', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }
        it 'creates new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
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
