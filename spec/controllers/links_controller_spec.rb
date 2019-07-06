require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }
  let!(:questions_link) { create(:link, linkable: question) }
  let!(:answers_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    context 'User tries to delete link in his' do
      before { login(user) }

      it 'question' do
        expect { delete :destroy, params: { id: questions_link.id }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'answer' do
        expect { delete :destroy, params: { id: answers_link.id }, format: :js }.to change(answer.links, :count).by(-1)
      end
    end

    context 'User tries to delete link in not his' do
      before { login(create(:user)) }

      it 'question' do
        expect { delete :destroy, params: { id: questions_link.id }, format: :js }.to_not change(question.links, :count)
        expect(response).to have_http_status(403)
      end

      it 'answer' do
        expect { delete :destroy, params: { id: answers_link.id }, format: :js }.to_not change(answer.links, :count)
        expect(response).to have_http_status(403)
      end
    end
  end
end
