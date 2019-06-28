require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :add_file, user: user) }
  let(:answer) { create(:answer, :add_file, user: user, question: question) }
  let(:questions_file) { question.files.first }
  let(:answers_file) { answer.files.first }

  describe 'DELETE #destroy' do
    context 'User tries to delete file in his' do
      before { login(user) }

      it 'question' do
        expect { delete :destroy, params: { id: questions_file.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'answer' do
        expect { delete :destroy, params: { id: answers_file.id }, format: :js }.to change(answer.files, :count).by(-1)
      end
    end

    context 'User tries to delete file in not his' do
      before { login(create(:user)) }

      it 'question' do
        expect { delete :destroy, params: { id: questions_file.id }, format: :js }.to_not change(question.files, :count)
      end

      it 'answer' do
        expect { delete :destroy, params: { id: answers_file.id }, format: :js }.to_not change(answer.files, :count)
      end
    end
  end
end
