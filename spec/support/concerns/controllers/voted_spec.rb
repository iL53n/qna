require 'rails_helper'

shared_examples 'voted' do
  describe 'POST #up' do
    before { login(create(:user)) }
    it 'saves a new vote in the database' do
      expect { post :up, params: { id: voteable.id, format: :json } }.to change(voteable.votes, :count).by(1)
    end
  end

  describe 'POST #cancel' do
    before do
      post :up, params: { id: voteable.id, format: :json }
      login(create(:user))
    end

    it 'deletes a vote in the database' do
      expect { post :cancel, params: { id: voteable.id, format: :json } }.to change(voteable.votes, :count).by(-1)
    end
  end

  describe 'POST #down' do
    before { login(create(:user)) }
    it 'saves a new vote in the database' do
      expect { post :down, params: { id: voteable.id, format: :json } }.to change(voteable.votes, :count).by(1)
    end
  end
end
