require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :add_file, user: user) }
  let(:file) { question.files.first }

  describe 'DELETE #destroy' do
    context 'User tries to delete file in' do
      before { login(user) }

      it 'his question' do
        expect { delete :destroy, params: { id: file.id }, format: :js }.to change(question.files, :count).by(-1)
      end
    end

    context 'User tries to delete file in' do
      before { login(create(:user)) }

      it 'not his question' do
        expect { delete :destroy, params: { id: file.id }, format: :js }.to_not change(question.files, :count)
        expect(response).to have_http_status(403)
      end
    end
  end
end
