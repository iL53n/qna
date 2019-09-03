require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #result' do
    let(:question) { create(:question) }

    context 'with valid attributes' do
      before do
        get :result, params: { q: question.title, resource: Question }
      end

      it 'return OK' do
        expect(response).to be_successful
      end

      it 'renders result template' do
        expect(response).to render_template :result
      end
    end

    context 'with invalid attributes' do
      it 'show flash alert' do
        get :result, params: {q: '', resource: Question}
        expect(controller).to set_flash.now[:alert].to 'Search field is empty'
      end
    end
  end
end
