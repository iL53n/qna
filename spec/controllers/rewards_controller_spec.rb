require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:rewards) { create_list(:reward, 3, question: question, user: user) }

  describe 'GET #index' do
    context 'Badge owner' do
      before { login(user) }
      before { get :index }

      it 'populates an array of user rewards' do
        expect(assigns(:rewards)).to match_array(rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Another user' do
      before { login(create(:user)) }
      before { get :index }

      it 'no populates an array of user rewards' do
        expect(assigns(:rewards)).to_not match_array(rewards)
      end
    end
  end
end
