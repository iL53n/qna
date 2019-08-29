require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:request_create) { post :create, params: { question_id: question }, format: :js }
  let(:request_destroy) { delete :destroy, params: { id: subscription.id }, format: :js }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      it 'saves a new questions subscription in the database' do
        expect { request_create }.to change(question.subscriptions, :count).by(1)
      end

      it 'saves a new users subscription in the database' do
        expect { request_create }.to change(question.subscriptions, :count).by(1)
      end
    end

    context 'non-authenticated user' do
      it 'does not save the subscription' do
        expect { request_create }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'POST #destroy' do
    let!(:subscription) { create :subscription, question: question, user: user }

    context 'authenticated user' do
      before { login(user) }

      it 'deletes questions subscription in the database' do
        expect { request_destroy }.to change(question.subscriptions, :count).by(-1)
      end

      it 'deletes users subscription in the database' do
        expect { request_destroy }.to change(question.subscriptions, :count).by(-1)
      end
    end

    context 'non-authenticated user' do
      it 'does not delete the subscription' do
        expect { request_destroy }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
