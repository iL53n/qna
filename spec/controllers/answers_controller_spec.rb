require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let (:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end
      it 'redirect to current question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns :question
      end
    end

    context 'with invalid attributes' do
      let(:answer_invalid) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: answer_invalid } }.to_not change(question.answers, :count)
      end
      it 'redirect to current question view' do
        post :create, params: { question_id: question, answer: answer_invalid }
        expect(response).to render_template :show
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:authored_answer) { create(:answer, user: user, question: question) }

    context 'User tries to delete his answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: authored_answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: authored_answer }
        expect(response).to redirect_to authored_answer.question
      end
    end

    context 'User tries to delete not his answer' do
      before { login(create(:user)) }

      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: authored_answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: authored_answer }
        expect(response).to redirect_to authored_answer.question
      end
    end
  end
end
