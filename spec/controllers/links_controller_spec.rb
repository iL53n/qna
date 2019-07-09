require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'User tries to delete link in' do
      before { login(user) }

      it 'his question' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(question.links, :count).by(-1)
      end
    end

    context 'User tries to delete link in' do
      before { login(create(:user)) }

      it 'not his question' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(question.links, :count)
        expect(response).to have_http_status(403)
      end
    end
  end
end
