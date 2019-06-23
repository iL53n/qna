require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'saves a new user answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'redirect to current question view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:answer_invalid) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: answer_invalid }, format: :js }.to_not change(question.answers, :count)
      end
      it 'redirect to current question view' do
        post :create, params: { question_id: question, answer: answer_invalid }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
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
